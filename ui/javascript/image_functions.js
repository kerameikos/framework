$(document).ready(function () {
    var map = L.map('map', {
        center:[0, 0],
        crs: L.CRS.Simple,
        zoom: 0
    });
    var iiifLayers = {
    };
    
    manifest = 'http://iiif.harvardartmuseums.org/manifests/object/288118';
    
    // Grab a IIIF manifest
    $.getJSON(manifest, function (data) {
        //determine where it is a collection or image manifest
        if (data[ '@context'] == 'http://iiif.io/api/image/2/context.json') {
            L.tileLayer.iiif(manifest).addTo(map);
        } else if (data[ '@context'] == 'http://iiif.io/api/presentation/2/context.json') {
            // For each image create a L.TileLayer.Iiif object and add that to an object literal for the layer control
            $.each(data.sequences[0].canvases, function (_, val) {
                iiifLayers[val.label] = L.tileLayer.iiif(val.images[0].resource.service[ '@id'] + '/info.json');
            });
            // Add layers control to the map
            L.control.layers(iiifLayers).addTo(map);
            
            // Access the first Iiif object and add it to the map
            iiifLayers[Object.keys(iiifLayers)[0]].addTo(map);
        }
    });
});