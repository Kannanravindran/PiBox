$(document).ready(function(){
	$.ajax({
		url: "/CameraWarehouse/api/rest/sessions",
		dataType:"json"
	}).then(function(data) {
		var template = $('#mustacheTemplate').html();
		var out = Mustache.render(template, data);
		$('#tableDiv').html(out);
	});
});