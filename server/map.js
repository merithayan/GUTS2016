mapboxgl.accessToken = 'pk.eyJ1IjoiZGFyZWFsZG9kbyIsImEiOiJjaXViMnZtMnQwMDBpMzNwcmFuajZ2Y3U2In0.YoZtUZYEUoZFjJ5UN8V1IA';

var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v9',
    minZoom: 17,
    center: [-4.288500, 55.871500]
});

// Draw players on map