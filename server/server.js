var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var _ = require('underscore');
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

// Broadcast all player locations
setInterval(function() {
	console.log("Trigger update: ", game.players);
	var clone = _.extend({}, game.players);
	io.emit('update', clone);
}, 3000);

io.on('connection', function(socket) {

	// console.log('Connected: ', socket.id);

	socket.on('login', function(data) {
		console.log(data.name, 'joined');

		game.players[socket.id] = {
			name: data.name,
			lat: data.lat,
			lng: data.lng,
			health: game.defaultHealth,
			experience: game.defaultExperience
		};

		// Send socket ID to front-end
		socket.emit('logged-in', socket.id);
		console.log(game.players);
	});

	// Update player location & direction
	socket.on('update-player', function(data) {
		console.log(data);

		game.players[data.id].lat = data.lat;
		game.players[data.id].lng = data.lng;
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
		// console.log(socket.id, ' disconnected');

		// Remove from players array
		delete game.players[socket.id]
	});

});

http.listen(3000, function() {
	console.log('listening on *:3000');
});