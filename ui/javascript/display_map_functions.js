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
		type: "json",
		options: {
			url: '../api/get?model=timemap&format=json&id=' + id
		}
	});
	
	var tm;
	tm = TimeMap.init({
		mapId: "map", // Id of map div element (required)
		timelineId: "timeline", // Id of timeline div element (required)
		options: {
			mapType: "physical",
			eventIconPath: "../ui/images/timemap/"
			//mapFilter:'true'
		},
		datasets: datasets,
		bandIntervals:[
		Timeline.DateTime.DECADE,
		Timeline.DateTime.CENTURY]
	});
}