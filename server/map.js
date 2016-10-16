var markerList = {};

var blueIcon = L.icon({
	iconUrl: 'http://www.omnipush.com/images/blue_dot_icon.png',
	iconSize: [15, 15],
});

var redIcon = L.icon({
	iconUrl: 'https://storage.googleapis.com/support-kms-prod/SNP_2752125_en_v0',
	iconSize: [15, 15]
});

var grayIcon = L.icon({
	iconUrl: 'http://www.iconsdb.com/icons/preview/dark-gray/circle-xl.png',
	iconSize: [15, 15]
});

function addInitialMarkers(players) {
    for (key in players) {
    	var p = players[key];
    	var options = {
    		icon: blueIcon
    	};
    	markerList[key] = new L.marker([p.lat, p.lng], options).addTo(mapLeaflet);
    	// markerList[key].setIcon(redIcon);
    	// console.log(markerList[key]);
    }    
    mapLeaflet.scrollWheelZoom.disable();
}

function addAdditionalMarker(player) {
	// console.log("Adding newly joined player");
	// console.log(player.id);
	if (markerList[player.id]) return;
	var options = {
		icon: blueIcon
	};
	markerList[player.id] = new L.marker([player.lat, player.lng], options).addTo(mapLeaflet);
}

function updateMarkers(players) {
    for (key in players) {
    	if (!markerList[key]) {
    		console.log(key, "hasn't been added to the map - skipping...");
    		continue;
    	};
    	var p = players[key];
        markerList[key].setLatLng(L.latLng(p.lat, p.lng));

        if (p.health < 0) {
			markerList[key].setIcon(grayIcon);
        }
    }
}

function setRedIcon() {
	console.log("setting red icon");
	if (!markerList[socketId]) {
		console.log("cannot set red icon");
		return;
	};
	markerList[socketId].setIcon(redIcon);
}

function setBlueIcon() {
	if (!markerList[socketId]) return;
	markerList[socketId].setIcon(blueIcon);
}

function removeMarker(id) {
	mapLeaflet.removeLayer(markerList[id]);
}