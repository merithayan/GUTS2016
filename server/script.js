var socket = io();
var socketId;
var data = {};

// Prevent reloading the page
$("form").submit(function(e) {
	$("#join").trigger("click");
	return false;
});

// Update fields
$('.updates').on('input', function() {
	var key = $(this).attr('name');
	data = {
		id: socketId,
		[key]: $(this).val()
	};
	socket.emit("update-player", data);
}); 

// Sending to the server
$("#join").click(function() {
	data.name = $("#name").val();
	data.lat = $("#lat").val();
	data.lng = $("#lng").val();
	data.angle = $("#angle").val();
	data ? socket.emit("login", data) : console.log("Enter data...");

	// playerMarkers = populatePlayer(socketId, playerMarkers);
});

$("#update").click(function() {
	var data = {
		id: socketId,
		lat: $("#lat").val(),
		lng: $("#lng").val(),
		angle: $("#angle").val()
	};
	console.log();
	socket.emit("update-player", data);
});

$("#fire").click(function() {
	socket.emit("fire");
});

// When this user has logged in
socket.on("logged-in", function(id) {
	socketId = id;
	$("#display").append("<h4>Joined as ID "+id+"</h4>");
});

socket.on("initial-draw", function(players) {
	console.log("initial drawe");
	addInitialMarkers(players);
});

socket.on("additional-draw", function(player) {
	addAdditionalMarker(player);
});

socket.on("remove-marker", function(id) {
	console.log("remove marker socket");
	removeMarker(id);
})

socket.on("update", function(players) {
	// console.log(data);
	if (players[socketId])
		console.log(players[socketId].health, players[socketId].deadFor);
	
	$("#players").html(" ");
	
	for (var key in players) {
		var p = players[key];

		// Show the player info in Godmode
		$("#players").append("<li>"+p.name+" "+key+" "+p.lat+" "+p.lng+" "+p.angle+"</li>");

		updateMarkers(players);
	}
	
});

socket.on("fire", function() {
	$("#fire").append("<h1>Shots Fired</h1>");
});

socket.on("hit", function(name) {
	console.log("You hit "+name+"!");
});

socket.on("got-shot", function() {
	console.log("You got shot!");
});
