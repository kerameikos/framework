$(document).ready(function () {
    
    $('.fancybox').fancybox({
        beforeShow: function () {
            this.title = '<a href="' + this.element.attr('id') + '">' + this.element.attr('title') + '</a>'
        },
        helpers: {
            title: {
                type: 'inside'
            }
        }
    });
    
    //if there is a div with a id=listTypes, then initiate ajax call
    /*if ($('#listTypes').length > 0) {
        var path = '../';
        var id = $('title').attr('id');
        var type = $('#type').text();
        
        $.get(path + 'ajax/listTypes', {
            id: id, type: type
        },
        function (data) {
            $('#listTypes').html(data);
        });
    }*/
});