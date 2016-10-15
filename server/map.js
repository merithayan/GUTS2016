function populatePlayer(id, playerList){     
    console.log("adding player");
    playerList.push(new L.marker([data.lat, data.lng]).addTo(mapLeaflet));
    
    var intervalId = setInterval(function(){
        // lng-=0.000005; 
        // lat+=0.000005;
        // marker.setLatLng(L.latLng(lat, lng));
    }, 10)
    setTimeout(function(){
        clearInterval(intervalId);
    }, 900);


    mapLeaflet.scrollWheelZoom.disable();

    return playerList;
}

function drawPlayers(data, playerList){
    console.log(data);
    console.log(playerList);
    for (m in data){
        //m.setLatLng(L.latLng(data.lat, data.lng));
    }  
    return playerList

}