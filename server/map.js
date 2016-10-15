mapboxgl.accessToken = 'pk.eyJ1IjoiZGFyZWFsZG9kbyIsImEiOiJjaXViMnZtMnQwMDBpMzNwcmFuajZ2Y3U2In0.YoZtUZYEUoZFjJ5UN8V1IA';

var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v9',
    minZoom: 17,
    center: [-4.288500, 55.871500]
});

// Draw players on map
map.on('load', function () {
    map.addSource("points", {
        "type": "geojson",
        "data": {
            "type": "FeatureCollection",
            "features": [{
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [-4.288500, 55.871500]
                },
                "properties": {
                    "title": "Player",
                    "icon": "circle"
                }
            }]
        }
    });

    map.addLayer({
        "id": "points",
        "type": "symbol",
        "source": "points",
        "layout": {
            "icon-image": "{icon}-15",
			"text-field": "{title}",
            "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
            "text-offset": [0, 0.6],
            "text-anchor": "top"
        }
    });
});