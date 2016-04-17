<html>
	<head>
		<Title>Quick Reflex</Title>
		<script type="text/javascript" src="/PiBox/js/jquery-1.11.1.min.js"></script>
		<script type="text/javascript" src="/PiBox/js/mustache.js"></script>
		<link rel="stylesheet" type="text/css" href="./css/quick-reflex.css">
	</head>
	<div id="AppContainer">
		<div id="sessionInfo">
			<table>
				<tr>
					<td>Session Name: </td>
					<td><p id="sessionName"></p></td>
				</tr>
				<tr>
					<td>Activity: </td>
					<td><p id="sessionActivity"></p></td>
				</tr>
				<tr>
					<td>Status: </td>
					<td><p id="sessionInfoStatus"></p></td>
				</tr>
			</table>
		</div>
		
		<div id="waiting">Waiting for host to start...</div>
		<div id="live">Get ready! The session is starting</div>
	</div>
	
</html>

<script>
var SessionInfo;



// First time entering the session... register & get session information
function registerForSession() {
	var sessionId = getUrlParameter('sessionId');
	var userId = <%= session.getAttribute("userId") %>;
	$.ajax({
		url: "/PiBox/api/rest/sessions/"+sessionId+"/"+userId,
		type:"POST"
	}).then(function(data) {
		console.log(data);
		SessionInfo = data;
	});
}

// Update gaming session
function pollSession() {
	var sessionId = getUrlParameter('sessionId');
	$.ajax({
		url: "/PiBox/api/rest/sessions/"+sessionId,
		dataType:"json",
		complete: function() {
			setTimeout(pollSession, 2000);
		}
	}).then(function(data) {
		console.log(data);
		if(data.status == "Wait") {
			$("#waiting").show();
			$("#live").hide();
		} else {
			$("#waiting").hide();
			$("#live").show();
		}
	});
}


// DOCUMENT READY
$(document).ready(function(){
	// Get RESTful service's URL with an id parameter
	var sessionId = getUrlParameter('sessionId');
	var userId = <%= session.getAttribute("userId") %>;
	var restUrl = ("/PiBox/api/rest/sessions/"+sessionId+"/"+userId);
	
	$.ajax({
		url: restUrl,
		dataType:"json",
		statusCode: {
			404:function() {
				alert("Entering for the first time eh?");
				registerForSession();
			}
		}
	}).then(function(data) {
		console.log(data);
		pollSession();
	});
	
	
});



//Function used to get parameters from URL
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
</script>