<html>
	<head>
		<title>Welcome <%= session.getAttribute("username") %></title>
		<script type="text/javascript" src="/PiBox/js/jquery-1.11.1.min.js"></script>
		<script type="text/javascript" src="/PiBox/js/mustache.js"></script>
		
	</head>
	Welcome <%= session.getAttribute("username") %>!
	ID: <%= session.getAttribute("userId") %>
	
	<p>Here are a list of available sessions:</p>
	
	<div id="tableDiv"></div>
	<script id="mustacheTemplate" type="x-tmpl-mustache">
	<table cellspacing="0" cellpadding="5">
	<tbody>
		<tr>
			<td>ID</td>
			<td>Name</td>
			<td>Activity</td>
			<td>Status</td>
		</tr>
		{{#.}}
		<tr>
			<td>{{id}}</td>
			<td>{{name}}</td> 
			<td>{{activity}}</td> 
			<td>{{status}}</td>
			<td><a href="./activity/quick-reflex.jsp?sessionId={{id}}">Enter Room</a></td>
		</tr>
		{{/.}}
	</tbody>
	</table>
	</script>
	
	<p>Logout: <a href="/PiBox/Logout"> here </a></p>

</html>

<script>
$(document).ready(function(){
	$.ajax({
		url: "/PiBox/api/rest/sessions",
		dataType:"json"
	}).then(function(data) {
		var template = $('#mustacheTemplate').html();
		var out = Mustache.render(template, data);
		$('#tableDiv').html(out);
	});
});
</script>