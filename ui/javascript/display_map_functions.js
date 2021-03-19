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
    
    //add productionLayer from AJAX
    var productionLayer = L.geoJson.ajax('../apis/getProductionPlaces?id=' + id, {
        onEachFeature: onEachFeature,
        pointToLayer: renderPoints
    }).addTo(map);
    
    //add controls
    var baseMaps = {
        "Terrain and Streets": mb_physical,
        "Modern Streets": osm,
        "Imperium": imperium
    };
    
    var overlayMaps = {
    };
    
    //add baselayers
    if (type == 'kon:ProductionPlace') {
        overlayMaps[prefLabel] = productionLayer;
    } else {
        overlayMaps[ 'Production Places'] = productionLayer;
    }
    
    var controls = L.control.layers(baseMaps, overlayMaps).addTo(map);
    
    //add individual finds layer, but don't make visible
    var findLayer = $.getJSON('../apis/getFindspots?id=' + id, function (data) {
        var maxDensity = 0;
        $.each(data.features, function (key, value) {
            if (value.properties.hasOwnProperty('count') == true) {
                if (value.properties.count !== undefined) {
                    if (value.properties.count > maxDensity) {
                        maxDensity = value.properties.count;
                    }
                }
            }
        });
        
        var findLayer = L.geoJson(data, {
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
                return renderFindspotPoints(feature, latlng, maxDensity);
            }
        }).addTo(map);
        
        controls.addOverlay(findLayer, 'Finds');
        
        var group = new L.featureGroup([productionLayer, findLayer]);
        map.fitBounds(group.getBounds());
        
        return findLayer;
    });
    
    //zoom to groups on AJAX complete
    productionLayer.on('data:loaded', function (data) {
        var group = new L.featureGroup([productionLayer, findLayer]);
        map.fitBounds(group.getBounds());
    }.bind(this));
    
    
    /*****
     * Features for manipulating layers
     *****/
    function renderPoints(feature, latlng) {
        var fillColor = getFillColor(feature.properties.type);
        
        return new L.CircleMarker(latlng, {
            radius: 5,
            fillColor: fillColor,
            color: "#000",
            weight: 1,
            opacity: 1,
            fillOpacity: 0.6
        });
    }
    
    function renderFindspotPoints(feature, latlng, maxDensity) {
        var fillColor = getFillColor(feature.properties.type);
        
        if (feature.properties.hasOwnProperty('count')) {
            grade = maxDensity / 5;
            
            var radius = 5;
            if (feature.properties.count < Math.round(grade)) {
                radius = 5;
            } else if (feature.properties.count >= Math.round(grade) && feature.properties.count < Math.round(grade * 2)) {
                radius = 10;
            } else if (feature.properties.count >= Math.round(grade * 2) && feature.properties.count < Math.round(grade * 3)) {
                radius = 15;
            } else if (feature.properties.count >= Math.round(grade * 3) && feature.properties.count < Math.round(grade * 4)) {
                radius = 20;
            } else if (feature.properties.count >= Math.round(grade * 4)) {
                radius = 25;
            } else {
                radius = 5;
            }
            
            return new L.CircleMarker(latlng, {
                radius: radius,
                fillColor: fillColor,
                color: "#000",
                weight: 1,
                opacity: 1,
                fillOpacity: 0.6
            });
        } else {
            return new L.CircleMarker(latlng, {
                radius: 5,
                fillColor: fillColor,
                color: "#000",
                weight: 1,
                opacity: 1,
                fillOpacity: 0.6
            });
        }
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