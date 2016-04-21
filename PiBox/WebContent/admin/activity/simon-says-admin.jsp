<html>
	<head>
		<Title>Quick Reflex - ADMIN</Title>
		<script type="text/javascript" src="/PiBox/js/jquery-1.11.1.min.js"></script>
		<script type="text/javascript" src="/PiBox/js/mustache.js"></script>
		<link rel="stylesheet" type="text/css" href="./css/quick-reflex-admin.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
  		<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
  		<!-- You can move this part to the .css file you are using -->
  		<style>
			input {
			    position: absolute;
			}
​
			input#upbtn {
			    float: none;
			    position: absolute;
			    top: 10%; left: 40%;
			    nav-index: 1;
			    nav-right: #b2; nav-left: #b4;
			    nav-down: #b2; nav-up: #b4;
			}
​
			input#rightbtn {
			    float: right;
			    position: absolute;
			    top: 40%; left: 70%;
			    nav-index: 2;
			    nav-right: #b3; nav-left: #b1;
			    nav-down: #b3; nav-up: #b1;
			}
​
			input#downbtn {
			    float: none;
			    position: absolute;
			    top: 70%; left: 40%;
			    nav-index: 3;
			    nav-right: #b4; nav-left: #b2;
			    nav-down: #b4; nav-up: #b2;
			}
​
			input#leftbtn {
			    float: left;
			    top: 40%; left: 10%;
			    nav-index: 4;
			    nav-right: #b1; nav-left: #b3;
			    nav-down: #b1; nav-up: #b3;
​
			}
		</style>
		<!-- style ends here -->
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
		<div id="controlpanel">
			<table>
			<tr>
				<td><div style="width: 60px; height: 60px"></div></td>
				<td><div style="width: 60px; height: 60px"><input id="upbtn" type="image" src="images/up.svg" width="60" height="60"/></div></td>
				<td><div style="width: 60px; height: 60px"></div></td>
			</tr>
			<tr>
				<td><div style="width: 60px; height: 60px"><div style="width: 60px; height: 60px"><input id="leftbtn" type="image" src="images/left.svg" width="60" height="60"/></div></td>
				<td><div style="width: 60px; height: 60px"></div></td>
				<td><div style="width: 60px; height: 60px"> <input id="rightbtn" type="image" src="images/right.svg" width="60" height="60"/></div></td>
			</tr>
			<tr>
				<td><div style="width: 60px; height: 60px"></div></td>
				<td><div style="width: 60px; height: 60px"><input id="downbtn" type="image" src="images/down.svg" width="60" height="60"/></div></td>
				<td><div style="width: 60px; height: 60px"></div></td>
			</tr>
			</table>			
		</div>
		<br/>
		<br/>
		<br/>
		<br/>
		<a href="/PiBox/admin/">Back to admin page</a>
	</div>
	
</html>
<!-- script for  clicks -->
<script type="text/javascript">
		
</script>
<script>
	var SessionInfo;
	var boolSessionStarted = false;
	var sessionId = getUrlParameter('sessionId');
	var nUserScore = 0;
	var strSessionStatus = "Wait";
	var stepId = 0;
	
	// Session start
	function startSession() {
		var startSessionData = "{\"direction\": \"start\", \"stepId\": 0 }";
		$.ajax({
			url: "/PiBox/api/rest/sessions/"+sessionId,
			dataType:"json",
			type:"PUT",
			data: {
				status: startSessionData
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
				setTimeout(pollSession, 3000);
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
			
			// Game is ending / ended
			} else if(data.status == "Stop") {
				$("#controlpanel").hide(); // control panel hidden again when game ends
				$("#waiting").hide();
				$("#live").hide();
				$("#finish").show();
				
				// display users entering room
				var template = $('#displayUsersTemplate').html();
				var out = Mustache.render(template, data);
				$('#displayUsersTemplateDiv').html(out);
			
			// Game is started
			} else {
				$("#controlpanel").show(); // control panel shown
				$("#waiting").hide();
				$("#live").show();
				$("#finish").hide();
				
				// display users entering room
				var template = $('#currentUsersTemplate').html();
				var out = Mustache.render(template, data);
				$('#currentUsersTemplateDiv').html(out);
			}
		});
	}
	
	$(document).ready(function(){	
		$("#controlpanel").hide(); //control panel hidden untill session starts
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
	function sendCommand(direction) {
		stepId = stepId + 1;
		var dataObject = {direction: direction, stepId: stepId};
		var strDataObject = JSON.stringify(dataObject);
		console.log(strDataObject);
		$.ajax({
			url: "/PiBox/api/rest/sessions/"+sessionId+"/status",
			dataType:"json",
			type:"PUT",
			data: {
				status: strDataObject
			}
		}).then(function(data) {
			console.log(data);
		});
	}
	$("#upbtn").click(function(){
		sendCommand("up");
	});
	$("#downbtn").click(function(){
		sendCommand("down");
	});
	$("#rightbtn").click(function(){
		sendCommand("right");
	});
	$("#leftbtn").click(function(){
		sendCommand("left");
	});
</script>