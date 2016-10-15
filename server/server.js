var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var _ = require('lodash');
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

app.get('/map', function(req, res) {
	res.sendFile(__dirname + '/map.js');
});

app.get('/script', function(req, res) {
	res.sendFile(__dirname + '/script.js');
});

// Broadcast all player locations
setInterval(function() {
	// console.log("Trigger update: ", game.players);
	var clone = _.extend({}, game.players);
	io.emit('update', clone);
}, 500);

io.on('connection', function(socket) {

	// console.log('Connected: ', socket.id);

	socket.on('login', function(rawdata) {
		console.log(rawdata);

		if    (typeof rawdata == 'object') data = rawdata;
		else  data = JSON.parse(rawdata);

		game.players[socket.id] = {
			name: data.name,
			lat: data.lat,
			lng: data.lng,
			angle: data.angle,
			health: game.defaultHealth,
			experience: game.defaultExperience
		};

		// Send socket ID to front-end
		socket.emit('logged-in', socket.id);
		console.log(game.players);
	});
	
	socket.on('update-health', function(data){
		console.log(data);
		game.players[socket.id].health = data.health;
		
	});
	
	//update experience
	
	// Update player property
	socket.on('update-player', function(data) {

		_.assign(game.players[socket.id], data);
		
		/*game.players[socket.id].lat = data.lat;
		game.players[socket.id].lng = data.lng;
		game.players[socket.id].health = data.health;
		game.players[socket.id].experience = data.experience;*/

		console.log("updating player ", socket.id+":", data);
		
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
		delete game.players[socket.id];
		
		console.log(game.players[socket.id]);
	});
	
	//to send socket to specific person
	//io.to(socketid).emit('message', 'for your eyes only');

});

http.listen(3000, function() {
	console.log('listening on *:3000');
});