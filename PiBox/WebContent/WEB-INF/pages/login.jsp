<!DOCTYPE html>
	<html>
	<head>
		<meta charset="US-ASCII">
		<title>Login Page</title>
	</head>
	<body>
		 <P>RETURN: <%=request.getAttribute("postMessage")%>!</P>
		 <P>User: <%=request.getParameter("username")%></P>
		 <P>Pass: <%=request.getParameter("password")%></P>
		<form action="Login" method="post">
			 
			Username: <input type="text" id="username" name="username">
			<br>
			Password: <input type="password" id="password" name="password">
			<br>
			<input type="submit" value="Login">
		</form>
	</body>
</html>