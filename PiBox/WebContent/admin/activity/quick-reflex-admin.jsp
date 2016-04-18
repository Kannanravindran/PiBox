<html>
	<head>
		<Title>Quick Reflex - ADMIN</Title>
		<script type="text/javascript" src="/PiBox/js/jquery-1.11.1.min.js"></script>
		<script type="text/javascript" src="/PiBox/js/mustache.js"></script>
		<link rel="stylesheet" type="text/css" href="./css/quick-reflex-admin.css">
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
			Waiting for you to start...
			<br/>
			<br/>
			<button onclick="startSession()">Press to start!</button><br/>
			<br/>
			<br/>
			Here's who will be playing:
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
		
		<div id="live">
			The session has already started, however you can spectate:
			<br/>
			<button onclick="stopSession()">Press to Stop!</button><br/>
			<br/>
			Here's the current scoring:
			<div id="currentUsersTemplateDiv"></div>
			<script id="currentUsersTemplate" type="x-tmpl-mustache">
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
		
		
		<div id="finish">
			The session has ended!
			<br/>
			<br/>
			Here's the winner:
			<div id="displayWinner"></div>
			
			Other players winner:
			<div id="displayUsersTemplateDiv"></div>
			<script id="displayUsersTemplate" type="x-tmpl-mustache">
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
		
		<br/>
		<br/>
		<br/>
		<br/>
		<a href="/PiBox/admin/">Back to admin page</a>
	</div>
	
</html>

<script>
	var SessionInfo;
	var boolSessionStarted = false;
	var sessionId = getUrlParameter('sessionId');
	var nUserScore = 0;
	var strSessionStatus = "Wait";
	
	// Session start
	function startSession() {
		strSessionStatus = "InProgress";
		$.ajax({
			url: "/PiBox/api/rest/sessions/"+sessionId+"/status",
			dataType:"json",
			type:"PUT",
			data: {
				status: strSessionStatus
			}
		}).then(function(data) {
			console.log(data);
			pollSession();
		});
	}
	
	//Session start
	function stopSession() {
		strSessionStatus = "Stop";
		$.ajax({
			url: "/PiBox/api/rest/sessions/"+sessionId+"/status",
			dataType:"json",
			type:"PUT",
			data: {
				status: strSessionStatus
			}
		}).then(function(data) {
			console.log(data);
		});
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
	
	//Update gaming session
	function pollSession() {
		$.ajax({
			url: "/PiBox/api/rest/sessions/"+sessionId,
			dataType:"json",
			complete: function() {
				setTimeout(pollSession, 2000);
			}
		}).then(function(data) {
			console.log(data);
			
			// Game is waiting to be started
			if(data.status == "Wait") {
				$("#waiting").show();
				$("#live").hide();
				$("#finish").hide();
				
				// display users entering room
				var template = $('#startingUsersTemplate').html();
				var out = Mustache.render(template, data);
				$('#startingUsersTemplateDiv').html(out);
			}
			
			// Game is started
			else if(data.status == "InProgress") {
				$("#waiting").hide();
				$("#live").show();
				$("#finish").hide();
				
				// display users entering room
				var template = $('#currentUsersTemplate').html();
				var out = Mustache.render(template, data);
				$('#currentUsersTemplateDiv').html(out);
			
			// Game is ending / ended
			} else if(data.status == "Stop") {
				$("#waiting").hide();
				$("#live").hide();
				$("#finish").show();
				
				// display users entering room
				var template = $('#displayUsersTemplate').html();
				var out = Mustache.render(template, data);
				$('#displayUsersTemplateDiv').html(out);
			}
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
		
		pollSession();
	});
</script>