$(document).ready(function () {
    var id = $('title').attr('id');
    
    $('.toggle-geoJSON').click(function () {
        $('#geoJSON-fragment').toggle();
        $('#geoJSON-full').toggle();
        return false;
    });
    
    if ($('#mapcontainer').length > 0) {
        initialize_map(id);
    };
});

function initialize_map(id) {
    var prefLabel = $('span[property="skos:prefLabel"]:lang(en)').text();
    //alert(prefLabel);
    var type = $('#type').text();
    var mapboxKey = $('#mapboxKey').text();
    
    //baselayers
    var mb_physical = L.tileLayer(
    'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="http://mapbox.com">Mapbox</a>', id: 'mapbox/outdoors-v11', maxZoom: 12, accessToken: mapboxKey
    });
    
    var osm = L.tileLayer(
    'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'OpenStreetMap',
        maxZoom: 18
    });
    
    var imperium = L.tileLayer(
    'https://dh.gu.se/tiles/imperium/{z}/{x}/{y}.png', {
        maxZoom: 10,
        attribution: 'Powered by <a href="http://leafletjs.com/">Leaflet</a>. Map base: <a href="https://dh.gu.se/dare/" title="Digital Atlas of the Roman Empire, Department of Archaeology and Ancient History, Lund University, Sweden">DARE</a>, 2015 (cc-by-sa).'
    });
    
    //overlays
    var map = new L.Map('mapcontainer', {
        center: new L.LatLng(0, 0),
        zoom: 4,
        layers:[mb_physical]
    });
    
    //add controls
    var baseMaps = {
        "Terrain and Streets": mb_physical,
        "Modern Streets": osm,
        "Imperium": imperium
    };
    
    //add controls
    var layerControl = L.control.layers(baseMaps).addTo(map);
    
    //add GeoJSON from AJAX
    $.getJSON(id + '.geojson', function (data) {
        
        //split features into separate objects
        var productionPlaces = {
            "type": "FeatureCollection",
            "features":[]
        };
        var findspots = {
            "type": "FeatureCollection",
            "features":[]
        };
        
        $.each(data.features, function (key, value) {
            
            //populate objects
            if (value.properties.type == 'productionPlace') {
                productionPlaces.features.push(value);
            }
            if (value.properties.type == 'find') {
                findspots.features.push(value);
            }
        });
        
        //create overlays for the three types of features
        var productionPlacesLayer = L.geoJson(productionPlaces, {
            onEachFeature: onEachFeature,
            style: function (feature) {
                if (feature.geometry.type == 'Polygon') {
                    var fillColor = getFillColor(feature.properties.type);
                    
                    return {
                        color: fillColor
                    }
                }
            },
            pointToLayer: function (feature, latlng) {
                return renderPoints(feature, latlng);
            }
        }).addTo(map);
        
        var findLayer = L.geoJson(findspots, {
            onEachFeature: onEachFeature,
            style: function (feature) {
                if (feature.geometry.type == 'Polygon') {
                    var fillColor = getFillColor(feature.properties.type);
                    
                    return {
                        color: fillColor
                    }
                }
            },
            pointToLayer: function (feature, latlng) {
                return renderPoints(feature, latlng);
            }
        }).addTo(map);
        
        //add layers to controls
        layerControl.addOverlay(productionPlacesLayer, 'Production Places');
        layerControl.addOverlay(findLayer, 'Finds');
        
        var group = new L.featureGroup([findLayer, productionPlacesLayer]);
        map.fitBounds(group.getBounds());
    });
    
    
    /*****
     * Features for manipulating layers
     *****/
    function renderPoints(feature, latlng) {
        var fillColor = getFillColor(feature.properties.type);
        
        if (feature.properties.hasOwnProperty('radius')) {
            var radius = feature.properties.radius;
        } else {
            var radius = 5;
        }
        
        return new L.CircleMarker(latlng, {
            radius: radius,
            fillColor: fillColor,
            color: "#000",
            weight: 1,
            opacity: 1,
            fillOpacity: 0.6
        });
    }
    
    function getFillColor (type) {
        var fillColor;
        switch (type) {
            case 'productionPlace':
            fillColor = '#6992fd';
            break;
            case 'find':
            fillColor = '#d86458';
            break;
            default:
            fillColor = '#efefef'
        }
        
        return fillColor;
    }
    
    function onEachFeature (feature, layer) {
        var str;
        //individual finds
        if (feature.properties.hasOwnProperty('gazetteer_uri') == false) {
            str = feature.label;
        } else {
            var str = '';
            //display hoard link and gazetteer link
            if (feature.hasOwnProperty('id') == true) {
                str += '<a href="' + feature.id + '">' + feature.label + '</a><br/>';
            }
            if (feature.properties.hasOwnProperty('gazetteer_uri') == true) {
                str += '<span>';
                str += '<a href="' + feature.properties.gazetteer_uri + '">' + feature.properties.toponym + '</a></span>';
            }
            if (feature.properties.hasOwnProperty('count') == true) {
                str += '<br/><b>Count: </b>' + feature.properties.count;
            }
        }
        layer.bindPopup(str);
    }
}