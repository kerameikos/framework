$(document).ready(function () {
    var id = $('title').attr('id');
    
    $('.toggle-geoJSON').click(function () {
        $('#geoJSON-fragment').toggle();
        $('#geoJSON-full').toggle();
        return false;
    });
    
    initialize_map(id);
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
    
    //add individual finds layer, but don't make visible
    var findLayer = L.geoJson.ajax('../apis/getFindspots?id=' + id, {
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
        overlayMaps[ 'Finds'] = findLayer;
    } else {
        overlayMaps[ 'Production Places'] = productionLayer;
        overlayMaps[ 'Finds'] = findLayer;
    }
    
    L.control.layers(baseMaps, overlayMaps).addTo(map);
    
    //zoom to groups on AJAX complete
    productionLayer.on('data:loaded', function () {
        var group = new L.featureGroup([productionLayer, findLayer]);
        map.fitBounds(group.getBounds());
    }.bind(this));
    
    findLayer.on('data:loaded', function () {
        var group = new L.featureGroup([productionLayer, findLayer]);
        map.fitBounds(group.getBounds());
    }.bind(this));
    
    
    
    /*****
     * Features for manipulating layers
     *****/
    function renderPoints(feature, latlng) {
        var fillColor;
        switch (feature.properties.type) {
            case 'productionPlace':
            fillColor = '#6992fd';
            break;
            case 'find':
            fillColor = '#d86458';
        }
        
        return new L.CircleMarker(latlng, {
            radius: 5,
            fillColor: fillColor,
            color: "#000",
            weight: 1,
            opacity: 1,
            fillOpacity: 0.6
        });
    }
    
    function onEachFeature (feature, layer) {
        var str;
        if (feature.properties.hasOwnProperty('uri') == false) {
            str = feature.properties.name;
        } else {
            str = '<a href="' + feature.properties.uri + '">' + feature.properties.name + '</a>';
        }
        layer.bindPopup(str);
    }
}