package com.pibox.servlet;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.DatatypeConverter;

import com.pibox.bean.UserBean;
import com.pibox.dao.UserDAO;

public class LoginServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private static String getPasswordHashText(String password)
	    throws NoSuchAlgorithmException, UnsupportedEncodingException {
	    MessageDigest digest = MessageDigest.getInstance("SHA-1");
	    digest.reset();
	    byte[] hash = digest.digest(password.getBytes("UTF-8"));
	    return DatatypeConverter.printHexBinary(hash);
	}
	
	protected void doGet( HttpServletRequest request,
			   HttpServletResponse response) throws IOException, ServletException {
		request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
	}

	protected void doPost( HttpServletRequest request,
						   HttpServletResponse response) throws IOException, ServletException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		try {
			password = getPasswordHashText(request.getParameter("password"));
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/error");
		}
		
		UserDAO userDao = new UserDAO();
		UserBean user = null;
		try {
			user = userDao.getUserForCredentials(username);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(user != null) {
			HttpSession session = request.getSession(true);
			session.setAttribute("user", user);
			session.setMaxInactiveInterval(5*60);
			
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
			request.setAttribute("postMessage", "Invalid Login");
			request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
		}
	}
}