// Function used to get parameters from URL
function getUrlParameter(sParam)
{
	var sPageURL = window.location.search.substring(1);
	var sURLVariables = sPageURL.split('&');
	for(var i = 0; i < sURLVariables.length; i++) {
		var sParameterName = sURLVariables[i].split('=');
		if (sParameterName[0] == sParam) {
			return sParameterName[1];
		}
	}
}

$(document).ready(function(){
	// Get RESTful service's URL with an id parameter
	var sessionId = getUrlParameter('id');
	var restUrl = ("/PiBox/api/rest/sessions/"+sessionId);
	
	// Make Ajax call to RESTful service to get session's current info
	$.ajax({
		url: restUrl
	}).then(function(data) {
		var template = $('#mustacheSessionTemplate').html();
		var out = Mustache.render(template, data);
		$('#tableSessionDiv').html(out);
		var template = $('#mustacheUserSessionTemplate').html();
		var out = Mustache.render(template, data);
		$('#tableUserSessionDiv').html(out);
	});
	
	// Call when form is submitted
	$("form#editSessionForm").submit(function(event) {
		event.preventDefault();
		
		// Set data for Ajax call
		var restUrl = ("/PiBox/api/rest/sessions");
		var myData = $("form#editForm").serialize();
		
		// Make Ajax call to update camera via RESTful POST method
		$.ajax({
			type: 'PUT',
			url: restUrl,
			data:myData,
			dataType: "json",
			success: function(data, textStatus, jqXHR) {
				alert("Succeed with status: " + jqXHR.status);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				alert("Error with status: " + jqXHR.status + " Request sent to: " + restUrl);
			}
		});
	});// end form.submit()
	
});// end document.ready()

