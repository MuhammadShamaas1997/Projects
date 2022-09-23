var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
require('./lib/connection');
var employees = require('./routes/employees');
var teams = require('./routes/teams');
var { MongoClient, ServerApiVersion } = require('mongodb');
const http = require('http');


var app = express();
//const server = http.createServer(app);
const { Server } = require("socket.io");


// app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// application routes
app.use(employees);
app.use(teams);

var server = app.listen(8000);
const io = new Server(server);


io.on('connection', (socket) => {
  console.log('a user connected');
  
  socket.on( 'Request' , function(d) {
    console.log('Request received: '+d);
    var data = dbread();
    data.then(result => {
      console.log(result);
      socket.emit('Response',result);
    });
  });
  
  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
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


console.log('Server running on http://127.0.0.1:8000/')

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers
// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.send({
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
});

module.exports = app;
