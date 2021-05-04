/* Author: Ethan Gruber
Date: April 2021
Function: instantiate a Mirador 3.x viewer for IIIF manifests */
$(document).ready(function () {
    var uri = $('#uri').text();
    
    //initialize Leaflet map if applicable
    if ($('#mapcontainer').length > 0) {
        initialize_map(uri);
    };
    
    //initiate Mirador for a IIIF manifest
    if ($('#manifestURI').length) {
        //get necessary variables
        var collection = $('#collection').text();
        var manifestURI = $('#manifestURI').text();
        //var hasAnnotations = ($('#hasAnnotations').text().toLowerCase() == 'true');
        
        //construct Mirador window objects dynamically
        var windowObjects =[];
        var windowOptions = {
        };
        
        if (window.location.hash) {
            var id = window.location.hash.substring(1);
            var canvasID = manifestURI + '/canvas/' + id;
            windowOptions[ "canvasId"] = canvasID;
        }
        
        windowOptions[ "loadedManifest"] = manifestURI;
        windowOptions[ "id"] = "default";
        windowOptions[ "thumbnailNavigationPosition"] = "far-bottom";
        windowObjects.push(windowOptions);
        
        var miradorInstance = Mirador.viewer({
            "id": "mirador-div",
            "manifests": {
                manifestURI: {
                    "provider": collection
                }
            },
            "windows": windowObjects,
            "window": {
                "allowClose": false,
                "allowMaximize": false,
                "defaultSideBarPanel": "info",
                //"defaultSideBarPanel": ((hasAnnotations == true) ? 'annotations' : 'info'),
                "sideBarOpenByDefault": false,
                //"sideBarOpenByDefault": hasAnnotations,
                "forceDrawAnnotations": true
            },
            "thumbnailNavigation": {
                "defaultPosition": 'off'
            },
            "workspace": {
                "type": 'mosaic'
            },
            "workspaceControlPanel": {
                "enabled": false
            },
            "theme": {
                "palette": {
                    "annotations": {
                        "hidden": {
                            "globalAlpha": 1
                        }
                    }
                }
            }
        });
    } else if ($('#iiif-image').length) {
        var images = $('#iiif-image').text().split('|');
        
        var iiifImage = L.map('iiif-container', {
            center:[0, 0],
            crs: L.CRS.Simple,
            zoom: 0
        });
        
        var iiifLayers = {
        };
        
        images.forEach(function (image, index) {
            iiifLayers[index] = L.tileLayer.iiif(image + '/info.json');
        });
        
        // Add layers control to the map, but only if there is more than one layer
        if (images.length > 1) {
            L.control.layers(iiifLayers).addTo(iiifImage);
        }
        
        // Access the first IIIF object and add it to the map
        iiifLayers[Object.keys(iiifLayers)[0]].addTo(iiifImage);
    }
});

function initialize_map(uri) {
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
    var layer = L.geoJson.ajax('geoJSON?uri=' + uri, {
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
        "Distribution": layer
    };
    
    //var controls = L.control.layers(baseMaps, overlayMaps).addTo(map);
    
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
        str += '<a href="' + feature.id + '">' + feature.label + '</a><br/>';
        layer.bindPopup(str);
    }
}