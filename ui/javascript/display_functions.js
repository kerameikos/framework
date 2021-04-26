$(document).ready(function () {
    
    //display the magnifying glass glyph when hovering the mouse of divs that contain it (for IIIF)
    $("#listObjects").on('mouseenter', '.obj-container', function () {
        $(this).children('.iiif-zoom-glyph').fadeIn();
    });
    $("#listObjects").on('mouseleave', '.obj-container', function () {
        $(this).children('.iiif-zoom-glyph').fadeOut();
    });
    
    //show/hide sections
    $('.toggle-button').click(function () {
        var div = $(this).attr('id').split('-')[1];
        $('#' + div).toggle();
        
        //replace minus with plus and vice versa
        var span = $(this).children('span');
        if (span.attr('class').indexOf('right') > 0) {
            span.removeClass('glyphicon-triangle-right');
            span.addClass('glyphicon-triangle-bottom');
        } else {
            span.removeClass('glyphicon-triangle-bottom');
            span.addClass('glyphicon-triangle-right');
        }
        return false;
    });
    
    $('.model-button').fancybox({
        beforeShow: function () {
            var url = this.element.attr('model-url');
            this.title = '<a href="' + this.element.attr('object-url') + '">' + this.element.attr('content') + '</a>';
            //if the URL is sketchfab, then remove existing iframe and reload iframe
            if (url.indexOf('sketchfab') > 0) {
                $('#sketchfab-window').children('iframe').remove();
                $("#model-iframe-template").clone().removeAttr('id').attr('src', url + '/embed').appendTo("#sketchfab-window");
            } else if (url.indexOf('.ply') > 0) {
                //set up 3dhop
                init3dhop();
                
                setup3dhop(url);
                
                resizeCanvas(640, 480);
                
                moveToolbar(20, 20);
            }
        },
        helpers: {
            title: {
                type: 'inside'
            }
        }
    });
    
    $('.iiif-image').fancybox({
        beforeShow: function () {
            this.title = '<a href="' + this.element.attr('uri') + '">' + this.element.attr('title') + '</a>'
            var manifest = this.element.attr('manifest');
            //remove and replace #iiif-container, if different or new
            if (manifest != $('#manifest').text()) {
                $('#iiif-container').remove();
                $(".iiif-container-template").clone().removeAttr('class').attr('id', 'iiif-container').appendTo("#iiif-window");
                $('#manifest').text(manifest);
                render_image(manifest);
            }
        },
        helpers: {
            title: {
                type: 'inside'
            }
        }
    });
    
    $('a.fancybox').fancybox({
        type: 'image',
        beforeShow: function () {
            this.title = '<a href="' + this.element.attr('uri') + '">' + this.element.attr('title') + '</a>'
        },
        helpers: {
            title: {
                type: 'inside'
            }
        }
    });
    
    //if there is a div with a id=listObjects, then initiate ajax call
    if ($('#listObjects').length > 0) {
        var path = '../';
        var id = $('#id').text();
        var type = $('#type').text();
        var page = 1;
        
        $.get(path + 'ajax/listObjects', {
            id: id, type: type, page: page
        },
        function (data) {
            $('#listObjects').html(data);
        });
    }
    
    $('#listObjects').on('click', '.paging_div .page-nos .btn-toolbar .btn-group a.btn', function (event) {        
        var path = '../';
        var id = $('#id').text();
        var type = $('#type').text();        
        var page = $(this).attr('href').split('=')[1];
        
        
        $.get(path + 'ajax/listObjects', {
            id: id, type: type, page: page
        },
        function (data) {
            $('#listObjects').html(data);
        });
        return false;
    });
    
    function render_image(manifest) {
        
        var iiifImage = L.map('iiif-container', {
            center:[0, 0],
            crs: L.CRS.Simple,
            zoom: 0
        });
        
        // Grab a IIIF manifest
        $.getJSON(manifest, function (data) {
            //determine where it is a collection or image manifest
            if (data[ '@context'] == 'http://iiif.io/api/image/2/context.json' || data[ '@context'] == 'http://library.stanford.edu/iiif/image-api/1.1/context.json') {
                L.tileLayer.iiif(manifest).addTo(iiifImage);
            } else if (data[ '@context'] == 'http://iiif.io/api/presentation/2/context.json') {
                var iiifLayers = {
                };
                
                // For each image create a L.TileLayer.Iiif object and add that to an object literal for the layer control
                $.each(data.sequences[0].canvases, function (_, val) {  
                    if (val.hasOwnProperty('label')) {
                        var label = val.label;
                    } else {
                        var label = _;
                    }
                    iiifLayers[label] = L.tileLayer.iiif(val.images[0].resource.service[ '@id'] + '/info.json');
                });
                // Add layers control to the map
                L.control.layers(iiifLayers).addTo(iiifImage);
                
                // Access the first Iiif object and add it to the map
                iiifLayers[Object.keys(iiifLayers)[0]].addTo(iiifImage);
            }
        });
    }
});

var presenter = null;

function setup3dhop(url) {
    presenter = new Presenter("draw-canvas");
    
    presenter.setScene({
        meshes: {
            "Vase": {
                url: url
            }
        },
        modelInstances: {
            "Model1": {
                mesh: "Vase"
            }
        },
        trackball: {
            type: TurnTableTrackball,
            trackOptions: {
                startPhi: 0.0,
                startTheta: 0.0,
                startDistance: 2.5,
                minMaxPhi:[-180, 180],
                minMaxTheta:[-180, 180],
                minMaxDist:[0.5, 3.0]
            }
        }
    });
}

function actionsToolbar(action) {
    if (action == 'home')
    presenter.resetTrackball(); else if (action == 'zoomin')
    presenter.zoomIn(); else if (action == 'zoomout')
    presenter.zoomOut(); else if (action == 'light' || action == 'light_on') {
        presenter.enableLightTrackball(! presenter.isLightTrackballEnabled());
        lightSwitch();
    } else if (action == 'full' || action == 'full_on')
    fullscreenSwitch();
}