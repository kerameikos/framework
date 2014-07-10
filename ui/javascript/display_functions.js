$(document).ready(function () {
	$('.toggle-geoJSON').click(function () {
		$('#geoJSON-fragment').toggle();
		$('#geoJSON-full').toggle();
		return false;
	});
	
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
	
	$('#container').highcharts({
		data: {
			table: document.getElementById('calculate')
		},
		chart: {
			type: 'column'
		},
		title: {
			text: $(this).children('caption').text()
		},
		legend: {
			enabled: true
		},
		xAxis: {
			labels: {
				rotation: - 45,
				align: 'right',
				style: {
					fontSize: '11px',
					fontFamily: 'Verdana, sans-serif'
				}
			}
		},
		yAxis: {
			allowDecimals: false,
			title: {
				text: 'Occurrences'
			}
		},
		tooltip: {
			formatter: function () {
				return '<b>' + this.point.name + '</b><br/>' +
				'Count: ' + this.point.y;
			}
		}
	});
});