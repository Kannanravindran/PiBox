package com.pibox.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	protected void doGet( HttpServletRequest request,
			   HttpServletResponse response) throws IOException, ServletException {
		request.getRequestDispatcher("/WEB-INF/pages/logout.jsp").forward(request, response);
	}

	protected void doPost( HttpServletRequest request,
						   HttpServletResponse response) throws IOException, ServletException {
		
		HttpSession session=request.getSession();
		if(session != null) {
			session.invalidate(); 
		}
		response.sendRedirect("/PiBox/Welcome");
	}
}