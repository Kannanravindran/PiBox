<html>
	<head>
		<Title>Quick Reflex</Title>
		<script type="text/javascript" src="/PiBox/js/jquery-1.11.1.min.js"></script>
		<script type="text/javascript" src="/PiBox/js/mustache.js"></script>
		<link rel="stylesheet" type="text/css" href="./css/quick-reflex.css">
		<script type="text/javascript" src="js/Game.js"></script>
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
			</table>
		</div>
		
		<div id="waiting">
			Waiting for host to start...
			<br/>
			<br/>
			Here's who you'll be playing with:
			<div id="startingUsersTemplateDiv"></div>
			<script id="startingUsersTemplate" type="x-tmpl-mustache">
				<p>Usernames: </p>
				<list>
					{{#userSessions}}
					<li>
						<p>{{userName}}</p> 
					</li>
					{{/userSessions}}
				</list>
			</script>
		</div>
		
		<div id="tooLate">
			The session has already started, however you can spectate:
			<br/>
			Here's the current scoring:
			<div id="spectateUsersTemplateDiv"></div>
			<script id="spectateUsersTemplate" type="x-tmpl-mustache">
				<p>Usernames: </p>
				<table>
						<td>Username</td>
						<td>Score</td>
					</tr>
					{{#userSessions}}
					<tr>
						<td>{{userName}}</td> 
						<td>{{userScore}}</td> 
					</tr>
					{{/userSessions}}
				</list>
			</script>
		</div>
		<!-- Game info starts-->
		<br>
		<div id="dataContainerOrientation">
			No device Orientation.	
		</div>
		<div id="positionInfo">
			Waiting for host to send command
		</div>
		<br>
		<!-- Game data ends -->
		<div id="finish">
			The session has ended!
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>
	<br/>
	<a href="/PiBox/member/">Back to member page</a>
	
</html>

<script>
var SessionInfo;
var boolSessionStarted = false;
var sessionId = getUrlParameter('sessionId');
var userId = <%= session.getAttribute("userId") %>;
var nUserScore = 0;
var cmdStatus = 0;
var command;

function updateScore(incrementByMe) {
	nUserScore = nUserScore + incrementByMe;
	console.log("get ALL the points! " + nUserScore);
}

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

// First time entering the session... register & get session information
function registerForSession() {
	$.ajax({
		url: "/PiBox/api/rest/sessions/"+sessionId+"/"+userId,
		type:"POST"
	}).then(function(data) {
		console.log(data);
		SessionInfo = data;
		location.reload();
	});
}
//Getting the commandId and direction
function startGame() {
	$.ajax({
		url: "/PiBox/api/rest/sessions/"+sessionId,
		type:"GET"
	}).then(function(data) {
		console.log(data.status);
		if (data.status.stepId == cmdStatus){
			console.log("do nothing!");
		}
		else if (data.status.commandId == cmdStatus+1){
			console.log("startgame() - " + data.status.direction);
			cmdStatus = data.status.stepId;
			init(data.status.direction);
		}
		else {
			//alert('Some problem occured with the connection. Please contact the host.');
		}
	});
}

//Update gaming session
function pollSession() {
	$.ajax({
		url: "/PiBox/api/rest/sessions/"+sessionId,
		dataType:"json",
		complete: function() {
			setTimeout(pollSession, 2000);
		}
	}).then(function(data) {	
		// Game is waiting to be started
		if(data.status == "Wait") {
			console.log('on wait');
			boolSessionStarted = true;
			$("#waiting").show();
			pollUserScore();
			
			// display users entering room
			var template = $('#startingUsersTemplate').html();
			var out = Mustache.render(template, data);
			$('#startingUsersTemplateDiv').html(out);
		}
		
		// Game is ending / ended
		else if(data.status == "Stop") {
			if(boolSessionStarted == false) {
				console.log('on stop - inactive');
				$("#waiting").hide();
				$("#live").hide();
				$("#tooLate").show();
				
				// display users entering room
				var template = $('#spectateUsersTemplate').html();
				var out = Mustache.render(template, data);
				$('#spectateUsersTemplateDiv').html(out);
			} else {
				console.log('on stop');
				$("#live").hide();
				$("#finish").show();
			}
		}
		
		// Game is started
		else {
			
			if(boolSessionStarted == false) {
				console.log('in progress - no participation');
				$("#waiting").hide();
				$("#live").hide();
				$("#tooLate").show();
				
				
				// display users entering room
				var template = $('#spectateUsersTemplate').html();
				var out = Mustache.render(template, data);
				$('#spectateUsersTemplateDiv').html(out);
				
			} else {
				console.log('in progress - active participation');
				$("#waiting").hide();
				$("#live").show();
				var sessionStatus = JSON.parse(data.status);
				
				console.log('will compare: ' + sessionStatus.status.stepId + " == " + cmdStatus )
				console.log(sessionStatus);
				if (data.status.stepId == cmdStatus+1){
					console.log("startgame() - " + sessionStatus.status.direction);
					cmdStatus = sessionStatus.status.stepId;
					init(sessionStatus.status.direction);
				}
				
				//var outcome = startGame(); // initialize the game
				//if(Boolean(outcome) == true)
				//	updateScore(10);
				//else
				//	updateScore(0);

			}
		}
	});
}

//Update gaming session
function pollUserScore() {
	$.ajax({
		url: "/PiBox/api/rest/sessions/"+sessionId+"/"+userId,
		dataType:"json",
		type:"POST",
		data: {
			userScore: nUserScore
		},
		complete: function() {
			setTimeout(pollUserScore, 4000);
		}
	}).then(function(data) {
		console.log('on poll user score: ' + nUserScore);
	});
}

$(document).ready(function(){	
	// get session info
	var sessionId = getUrlParameter('sessionId');
	$.ajax({
		url: "/PiBox/api/rest/sessions/"+sessionId,
		dataType:"json"
	}).then(function(data) {
		console.log(data);
		SessionInfo = data;
		
		// update static fields
		$("#sessionName").text(SessionInfo.name);
		$("#sessionActivity").text(SessionInfo.activity);
		$("#sessionInfoStatus").text(SessionInfo.status);
	});
	
	$.ajax({
		url: "/PiBox/api/rest/sessions/"+sessionId+"/"+userId,
		dataType:"json",
		statusCode: {
			404:function() {
				if(confirm("Welcome to the room! Would you like to participate?")) {
					registerForSession();
				} else {
					window.location = "/PiBox/member/"
				}
			}
		}
	}).then(function(data) {
		pollSession();
	});
	
	
});
</script>