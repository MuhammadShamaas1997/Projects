const fs = require('fs')
const http = require('http')
//const rsvp=require('rsvp')
//const routes = require('./routes')
const one = 1
const two = 2
const zero = 0
const ten = 10
const hundred = 100
const port = process.env.PORT || 3000;
const sockets = []
let shift = 0
var collection = []
var totalPlayers=0;
var totalGames=0;

const app = http.createServer((req, res) => {
    console.log('connected')
    fs.readFile('b.html', (err, data) => {
        res.end(data)
    })
}).listen(port);



function newGame(socket) {
collection.push({       
                        blue: ['3 3', '4 4'],
                        red: ['3 4', '4 3'],
                        blueScore: 0,
                        redScore: 0,
                        player1Id: totalPlayers,
                        player2Id: totalPlayers + one,
                        player1id: socket.id,
                        player2id: socket.id,
                        code: totalGames
                })
                console.log('new game')
}








function entry(socket, id, player, coordinates) {
   
        if (player % two === zero) {
            for (var i = 0; i < collection.length; i++) {
           	if(collection[i].player1id== socket.id)
           	{
           	collection[i].blue.push (Math.floor(coordinates / ten)).toString() +' ' + (coordinates % ten).toString();
            collection[i].blueScore+=1; 
           	}
           }           
    }


    else {
    for (var i = 0; i < collection.length; i++) {
           	if(collection[i].player2id== socket.id)
           	{
           	collection[i].red.push (Math.floor(coordinates / ten)).toString() +' ' + (coordinates % ten).toString();
            collection[i].redScore+=1; 
           	}
           }
    }

}

















const chat = require('socket.io').listen(app)
chat.on('connection', (socket) => {
	
                if (totalPlayers % two == zero) {
                   totalGames++;
                    newGame(socket)
                } 
                else {
                    collection[totalGames-1].player2id = socket.id;
                    }

            sockets.push(socket)
            socket.emit('welcome', totalPlayers.toString())
            totalPlayers++;

        



        socket.on('clientMessage', (data) => {
            
            if (parseInt(data) % two === zero) {
                socket.broadcast.emit('serverMessage',
          (parseInt(data) + one).toString())
            } else {
                socket.broadcast.emit('serverMessage',
                (parseInt(data) - one).toString())
            }
        })







        socket.on('update', (data) => {
            if (Math.floor(parseInt(data) / hundred) % two === zero) {
                socket.broadcast.emit('update',(Math.floor(parseInt(data) / hundred) + one).toString() + Math.floor(parseInt(data) % hundred / ten).toString() + (parseInt(data) % ten).toString())

                entry(socket, Math.floor(parseInt(data) / hundred) + one, Math.floor(parseInt(data) / hundred),Math.floor(parseInt(data) % hundred))
            } 

            else {
                socket.broadcast.emit('update',(Math.floor(parseInt(data) / hundred) - one).toString() +Math.floor(parseInt(data) % hundred / ten).toString() +(parseInt(data) % ten).toString())
                entry(socket, Math.floor(parseInt(data) / hundred), Math.floor(parseInt(data) / hundred),Math.floor(parseInt(data) % hundred))
            }
        })











        socket.on('game_over', (data) => {
            console.log('game_over')
            if (Math.floor(parseInt(data)) % two === zero) {
                socket.broadcast.emit('game_over', (Math.floor(parseInt(data)) + one).toString())
            } else {
                socket.broadcast.emit('game_over',(Math.floor(parseInt(data)) - one).toString())
                }
        
        })












        socket.on('disconnect', () => {
            if ((sockets.indexOf(socket) + shift) % two === zero) {
                socket.broadcast.emit('player_left',
                (sockets.indexOf(socket) + shift + one).toString())
            } else {
                socket.broadcast.emit('player_left',
                (sockets.indexOf(socket) + shift - one).toString())
            }
            console.log('left')
            
        
        })


})
