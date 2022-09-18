const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);
var { MongoClient, ServerApiVersion } = require('mongodb');

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', (socket) => {
  console.log('a user connected');
  socket.on( 'Request' , function(d) {
    	console.log('Request received: '+d);
    	var data = dbread();
    	data.then(result => {
    		console.log("result");
			socket.emit('Response',result);
		});
	});
  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
});

server.listen(3000, () => {
  console.log('listening on *:3000');
});

async function dbread() {
    const uri = "mongodb+srv://muhammadshamaas:skipq@cluster0.oajbu.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";
    const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true, serverApi: ServerApiVersion.v1 });
    try {
        await client.connect();
        var data = await client.db("muhammadshamaas").collection("urls").find({}).toArray();
        if (data.length) {
            return data;
        }
        else {
            return 'Not Found';
        }
    }
    finally {
        await client.close();
    }
}