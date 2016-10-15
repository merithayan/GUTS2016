var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var game = require('./game');

/** Server needs to support:
- Location - add sliders for:
	- Latitude: [55.871200, 55.871800]
	- Longitude: [-4.289500, -4.287500]
- Direction - same slider
- Bonus: Powerups (emp, mines, nukes)
*/

app.get('/', function(req, res) {
	res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket) {

	// console.log('Connected: ', socket.id);

	socket.on('login', function(data) {
		console.log(data.name, 'joined');

		game.players.push(new game.playerFactory(
			socket.id,
			data.name,
			game.defaultHealth,
			data.lat,
			data.lng,
			game.defaultExperience)
		);

		// Emit to front-end
		io.emit('login', data.name);
		console.log(game.players);
	});

	socket.on('update', function(data) {
		
	});

	socket.on('fire', function(data) {

		socket.broadcast.emit("fire");
	});

	// Sample socket event
	socket.on('example', function(msg) {
		console.log('example ' + msg);
		io.emit('example', msg);
	});

	socket.on('disconnect', function() {
		console.log(socket.id, ' disconnected');

		// Remove from players array
		game.players = game.players.filter(function(player) {
		    return player.id != socket.id;
		});
	});

});

http.listen(3000, function() {
	console.log('listening on *:3000');
});