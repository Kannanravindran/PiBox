package com.pibox.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.pibox.bean.UserBean;
import com.pibox.dao.UserDAO;

public class AdminServlet implements Filter {
	
	UserDAO userDao;

	@Override
	public void destroy() {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		String username = httpRequest.getRemoteUser();
		String incomingUserType = null;
		try {
			incomingUserType = userDao.getUserTypeForUsername(username);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(incomingUserType != null) {
			// user is of type admin, continue filter chain
			if(incomingUserType.equalsIgnoreCase("Admin")) {
				chain.doFilter(request, response);
			// user not admin; deny access
			} else {
				HttpServletResponse httpResponse = (HttpServletResponse) response;
				httpResponse.sendRedirect("/PiBox/error.html");
			}
			
		} else {
			// failed to get user
			HttpServletResponse httpResponse = (HttpServletResponse) response;
			httpResponse.sendRedirect("/PiBox/error.html");
		}
		
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		userDao = new UserDAO();
	}

}
