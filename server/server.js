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

	// User login
	socket.on('login', function(name) {
		console.log(name, 'joined');

		// Create new player
		game.players.push(new game.playerFactory(
			socket.id,
			name, 
			game.defaultHealth,
			game.defaultExperience)
		);

		io.emit('login', name);
		console.log(game.players);
	});

	socket.on('send-location', function(data) {

	});

	// Fire
	socket.on('fire', function(data) {
		
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