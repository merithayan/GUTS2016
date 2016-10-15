mapboxgl.accessToken = 'pk.eyJ1IjoiZGFyZWFsZG9kbyIsImEiOiJjaXViMnZtMnQwMDBpMzNwcmFuajZ2Y3U2In0.YoZtUZYEUoZFjJ5UN8V1IA';

var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v9',
    minZoom: 16,
    center: [-4.288500, 55.871500]
});

map.on('load', function () {
    var point = {
        "type": "Point",
        "coordinates": [-74.50, 40]
    };

    map.addSource("points", {
        "type": "geojson",
        "data": {
            "type": "FeatureCollection",
            "features": [{
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [-4.29, 55.87]
                },
                "properties": {
                    "title": "Mapbox DC",
                    "icon": "monument"
                }
            }, {
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [-122.414, 37.776]
                },
                "properties": {
                    "title": "Mapbox SF",
                    "icon": "harbor"
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
