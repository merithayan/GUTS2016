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

$("#emp").click(function() {
	socket.emit("emp");
});

// When this user has logged in
socket.on("logged-in", function(id) {
	socketId = id;
	$("#display").append("<h4>Joined as ID "+id+"</h4>");
});

socket.on("initial-draw", function(players) {
	addInitialMarkers(players);
});

socket.on("additional-draw", function(player) {
	addAdditionalMarker(player);
});

socket.on("remove-marker", function(id) {
	removeMarker(id);
})

socket.on("update", function(players) {
	// console.log(data);
	// if (players[socketId])
	// 	console.log(players[socketId].health, players[socketId].deadFor);
	
	$("#players").html(" ");
	
	for (var key in players) {
		var p = players[key];

		// Show the player info in Godmode
		$("#players").append("<li>"+p.name+"&#9;    "+p.experience+" "+p.lat+" "+p.lng+" "+p.angle+"</li>");

		updateMarkers(players);
	}
	
});

socket.on("hit", function(name) {
	console.log("You hit "+name+"!");
});

socket.on("got-shot", function(name) {
	console.log(name, "shot you!");
	setRedIcon(socketId);
	window.setTimeout(setBlueIcon, 500);
});

socket.on("mark-as-shot", function(id) {
	setRedIcon(id);
	// window.setTimeout(setBlueIcon(id), 500);
});

socket.on("empd", function() {
	console.log("You got EMPd!");
});