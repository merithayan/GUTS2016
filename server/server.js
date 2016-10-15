var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var _ = require('lodash');

// Game variables
var players = {};
var defaultHealth = 3;
var defaultExperience = 0;

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

app.get('/map', function(req, res) {
	res.sendFile(__dirname + '/map.js');
});

app.get('/script', function(req, res) {
	res.sendFile(__dirname + '/script.js');
});

// Broadcast all player locations
setInterval(function() {
	// console.log("Trigger update: ", players);
	var clone = _.extend({}, players);
	io.emit('update', clone);
}, 500);

io.on('connection', function(socket) {

	// console.log('Connected: ', socket.id);

	socket.on('login', function(rawdata) {
		console.log("login rawdata:", rawdata);

		if    (typeof rawdata == 'object') data = rawdata;
		else  data = JSON.parse(rawdata);

		players[socket.id] = {
			name: data.name,
			lat: data.lat,
			lng: data.lng,
			angle: data.angle,
			health: defaultHealth,
			experience: defaultExperience
		};

		// Send socket ID to sender
		socket.emit('logged-in', socket.id);
		// console.log(players);
	});
	
	// Update player property
	socket.on('update-player', function(rawdata) {

		var data;
		if (typeof rawdata == 'object') {
			data = rawdata;
		} else {
			data = JSON.parse(rawdata);
		}

		_.assign(players[socket.id], data);
		// console.log("updating player ", socket.id+":", data);
	});

	socket.on('fire', function(data) {

		var self = players[data.id]
		var otherPlayers = _.cloneDeep(players);
		delete otherPlayers[data.id]

		// Find angle between other players
		for (var id in otherPlayers) {
			var p = otherPlayers[id];
			console.log(p.lat);
			console.log(self.lat);
			var x = Math.abs(parseFloat(p.lat) - parseFloat(self.lat));
			var y = Math.abs(parseFloat(p.lng) - parseFloat(self.lng));
			var bearing = Math.atan2(x, y)*180/Math.PI;
			console.log(bearing);
		}

		socket.broadcast.emit("fire");
	});

	socket.on('disconnect', function() {
		console.log(socket.id, ' disconnected');
		
		// Remove from players array
		delete players[socket.id];
	});
	
	//to send socket to specific person
	//io.to(socketid).emit('message', 'for your eyes only');

});

http.listen(3000, function() {
	console.log('listening on *:3000');
});