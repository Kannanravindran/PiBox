<!DOCTYPE html>
	<html>
	<head>
		<meta charset="US-ASCII">
		<title>Login Page</title>
	</head>
	<body>
		 <p><%=request.getAttribute("postMessage")%></p>
		 <p><%=request.getParameter("username")%></p>
		<form action="Login" method="post">
			Username: <input type="text" id="username" name="username">
			<br/>
			<br/>
			<input type="submit" value="Login">
		</form>
	</body>
</html>