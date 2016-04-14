package com.pibox.servlet;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.pibox.bean.UserBean;
import com.pibox.dao.UserDAO;

@SuppressWarnings("serial")
public class WelcomeServlet extends HttpServlet {
	
	protected void doGet(	HttpServletRequest request,
							HttpServletResponse response ) throws IOException, ServletException {
		
		HttpSession session = request.getSession();
		
		if(session == null) {
			// first time request to container
			request.getRequestDispatcher("/WEB-INF/pages/welcome.jsp").forward(request, response); 
		} else {
			UserBean userInfo = (UserBean) request.getAttribute("user");
			if(userInfo != null) {
				request.getRequestDispatcher("/WEB-INF/pages/member/welcome.jsp").forward(request, response);
			} else {
				request.getRequestDispatcher("/WEB-INF/pages/welcome.jsp").forward(request, response);
			}
		}
	}
	
	
	protected void doPost( HttpServletRequest request,
			   HttpServletResponse response) throws IOException, ServletException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		UserDAO userDao = new UserDAO();
		UserBean user = null;
		
		try {
			user = userDao.getUserForCredentials(username);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO: accomodate DB user and password checking
		if(user != null) {
			HttpSession session = request.getSession(true);
			session.setAttribute("user", user);
			session.setMaxInactiveInterval(5*60);
			response.sendRedirect(request.getContextPath() + "/member/index.html");
		} else {
			request.setAttribute("postMessage", "Invalid Login");
			request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
		}
	}
}
