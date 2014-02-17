$(document).ready(function () {
	var id = $('title').attr('id');
	initialize_timemap(id);
});

function initialize_timemap(id) {
	var datasets = new Array();
	
	//first dataset
	datasets.push({
		id: 'dist',
		title: "Distribution",
		type: "kml",
		options: {
			url: id + '.kml'
		}
	});
	
	var tm;
	tm = TimeMap.init({
		mapId: "map", // Id of map div element (required)
		timelineId: "timeline", // Id of timeline div element (required)
		options: {
			eventIconPath: "../ui/images/timemap/"
			//mapFilter:'true'
		},
		datasets: datasets,
		bandIntervals:[
		Timeline.DateTime.YEAR,
		Timeline.DateTime.DECADE]
	});
	
	function toggleDataset(dsid, toggle) {
		if (toggle) {
			tm.datasets[dsid].show();
		} else {
			tm.datasets[dsid].hide();
		}
	}
}