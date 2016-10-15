var markerList = {};

function addInitialMarkers(players) {
    for (key in players) {
    	var p = players[key];
    	console.log(p);
    	markerList[key] = new L.marker([p.lat, p.lng]).addTo(mapLeaflet);
    }    
    mapLeaflet.scrollWheelZoom.disable();
}

function addAdditionalMarker(player) {
	console.log("Adding newly joined player");
	console.log(player.id);
	if (markerList[player.id]) return;
	markerList[player.id] = new L.marker([player.lat, player.lng]).addTo(mapLeaflet);
}

function updateMarkers(players) {
    for (key in players) {
    	if (!markerList[key]) {
    		console.log(key, "hasn't been added to the map - skipping...");
    		continue;
    	};
    	var p = players[key];
        markerList[key].setLatLng(L.latLng(p.lat, p.lng));
    }
}

function removeMarker(id) {
	mapLeaflet.removeLayer(markerList[id]);
}