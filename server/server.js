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

app.get('/test', function(req, res) {
	res.sendFile(__dirname + '/test.html');
})

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

// Check for revival
setInterval(function() {
	for (var p in players) {
		p = players[p];
		if (p.deadFor > 0) p.deadFor--;
		if (p.health==0 && p.deadFor==0) p.health = defaultHealth;
	}
}, 1000);


io.on('connection', function(socket) {

	// console.log('Connected: ', socket.id);
	socket.emit('initial-draw', players);

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
			experience: defaultExperience,
			deadFor: 0
		};

		// Send socket ID to sender
		socket.emit('logged-in', socket.id);
		socket.emit('initial-draw', players);
		var p = players[socket.id];
		p.id = socket.id;
		console.log(p);
		socket.broadcast.emit('additional-draw', p);
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

	socket.on('fire', function(id) {
		//console.log("FIRING");
		var self = players[socket.id];

		// Loop through all players
		for (var id in players) {
			if (id == socket.id) {
				// console.log("Found you, skipping...");
				continue;
			}

			var target = players[id];

			// If player is dead - skip
			if (target.health < 1) continue;			

			// Find angle between other players
			// Don't judge me, it's a hackathon ಠ_ಠ
			var xdiff = parseFloat(target.lng) - parseFloat(self.lng);
			var ydiff = parseFloat(target.lat) - parseFloat(self.lat);
			//console.log("xdiff: ", xdiff);
			//console.log("ydiff: ", ydiff);
			var azimuth = Math.atan2(xdiff, ydiff)*180/Math.PI;
			if (azimuth < 0) azimuth += 360;

			//console.log("Checking if", self.name, "hit", target.name);
			// console.log("angle: ", self.angle, "azimuth: ", azimuth);

			// If the difference is small enough - emit "shot" event to target
			if (Math.abs(self.angle - azimuth) < 5) {
				console.log(target.name, "was shot");

				target.health -= 1;
				if (target.health < 1) {
					target.deadFor = 10;
				}

				// Send event to target
				socket.to(target.id).emit("got-shot");

				// Send event to marksman
				socket.to(self.id).emit("hit");
			}

		}

		// socket.broadcast.emit("fire");
	});

	socket.on('disconnect', function() {
		console.log( (players[socket.id]) ? players[socket.id].name : socket.id, ' disconnected');
		
		// Remove from players array
		delete players[socket.id];

		socket.broadcast.emit('remove-marker', socket.id);
	});
	
	//to send socket to specific person
	//io.to(socketid).emit('message', 'for your eyes only');

});

http.listen(3000, function() {
	console.log('listening on *:3000');
});