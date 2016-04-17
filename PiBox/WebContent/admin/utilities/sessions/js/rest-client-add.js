$(document).ready(function(){
	
	// Form to add a camera is submitted 
	$("form#addForm").submit(function() {
		// Setup data for Ajax call (Pass in all camera parameters)
		var restUrl = ("/PiBox/api/rest/sessions");
		var myData = $("form#addForm").serialize();
		
		// Make Ajax call to create a new camera (remove id from POST parameter)
		$.ajax({
			type: 'POST',
			url: restUrl,
			data:myData,
			success: function(data, textStatus, jqXHR) {
				alert("Succeed with status: " + jqXHR.status);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				alert("Error with status: " + jqXHR.status + " Request sent to: " + restUrl);
			}
		});
		
	});// end form.submit()
	
});// end document.ready()