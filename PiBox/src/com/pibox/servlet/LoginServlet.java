package com.pibox.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.pibox.bean.UserBean;
import com.pibox.dao.UserDAO;

public class LoginServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	protected void doGet( HttpServletRequest request,
			   HttpServletResponse response) throws IOException, ServletException {
		request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
	}

	protected void doPost( HttpServletRequest request,
						   HttpServletResponse response) throws IOException, ServletException {
		String username = request.getParameter("username");
		
		UserDAO userDao = new UserDAO();
		UserBean user = null;
		try {
			user = userDao.getUserForCredentials(username);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(user != null) {
			HttpSession session = request.getSession(true);
			session.setAttribute("userId", user.getId());
			//session.setAttribute("userEmail", user.getEmail());
			session.setAttribute("username", user.getUsername());
			//session.setAttribute("userFirstName", user.getFirstName());
			//session.setAttribute("userLastName", user.getLastName());
			
			session.setMaxInactiveInterval(20*60);
			
			if(user.getType() == null) {
				request.setAttribute("postMessage", "Problem logging in");
				request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
			} else {
				if(user.getType().equalsIgnoreCase("Admin")) {
					response.sendRedirect(request.getContextPath() + "/admin/");
				} else if(user.getType().equalsIgnoreCase("User")) {
					response.sendRedirect(request.getContextPath() + "/member/");
				} 
			}			
		} else {
			request.setAttribute("postMessage", "Username doesn't exist");
			request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
		}
	}
}