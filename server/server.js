var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var game = require('./game');

/** Server needs to support:
- Location - add sliders for:
	- Latitude: [55.871200, 55.871800]
	- Longitude: [-4.289500, -4.287500]
- Direction - same slider
- Health
- Experience
- Bonus: Powerups (emp, mines, nukes)
*/


app.get('/', function(req, res){
	res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){

	console.log('Connected: ', socket.id);

	// User login
	socket.on('login', function(name) {
		console.log(name, 'joined');
		game.players.push(name);
		io.emit('login', name);
		console.log(game.players);
	});

	socket.on('chat message', function(msg){
		console.log('message: ' + msg);
		io.emit('chat message', msg);
	});

	socket.on('disconnect', function(){
		console.log('user disconnected');
	});

	// Emit an event for the front-end
	socket.on('typing', function(bool) {
		socket.broadcast.emit('typing', bool);
	})

});

http.listen(3000, function(){
	console.log('listening on *:3000');
});