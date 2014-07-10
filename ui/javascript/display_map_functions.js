$(document).ready(function () {
	var id = $('title').attr('id');
	initialize_timemap(id);
});

function initialize_timemap(id) {
	var datasets = new Array();
	
	//first dataset
	datasets.push({
		id: 'places',
		title: "Places",
		type: "json",
		options: {
			url: '../api/get?model=timemap&format=json&mode=places&id=' + id,
			theme: "red"
		}
	});	
	datasets.push({
		id: 'objects',
		title: "Objects",
		type: "json",
		placemarkVisible: false,
		options: {
			url: '../api/get?model=timemap&format=json&mode=objects&id=' + id,
			theme: "blue"
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
	
	//hide objects from map
	//tm.datasets["objects"].visible=false;
}