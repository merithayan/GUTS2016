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

	
});

$("#update").click(function() {
	var data = {
		id: socketId,
		lat: parseFloat($("#lat").val()),
		lng: parseFloat($("#lng").val()),
		angle: parseFloat($("#angle").val())
	};
	console.log();
	socket.emit("update-player", data);
});

$("#fire").click(function() {
	socket.emit("fire", socketId);
});

// Receiving from the server
socket.on("logged-in", function(id) {
	socketId = id;
	$("#display").append("<h4>Joined as ID "+id+"</h4>");
});

socket.on("update", function(data) {
	// console.log(data[socketId]);
	
	// console.log(data);
	$("#players").html(" ");
	for (var p in data) {

		// Draw players on map
		p = data[p];

		$("#players").append("<li>"+p.name+" "+p.lat+" "+p.lng+" "+p.angle+"</li>");
	}

});

socket.on("fire", function() {
	$("#fire").append("<h1>Shots Fired</h1>");
});

socket.on("got-shot", function() {
	console.log("You got shot!");
});
