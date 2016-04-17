package com.pibox.util;

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

public class MemberServiceFilter implements Filter {
	public FilterConfig filterConfig;
	UserDAO userDao;

	@Override
	public void destroy() {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest)request;
		HttpServletResponse httpResponse = (HttpServletResponse)response;
		HttpSession session = httpRequest.getSession(false);
		
		if(session != null) {
			String username = (String)session.getAttribute("username");
			String incomingUserType = null;
			try {
				incomingUserType = this.userDao.getUserTypeForUsername(username);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(incomingUserType != null) {
				// user is of type user, continue filter chain
				if(incomingUserType.equalsIgnoreCase("User")) {
					chain.doFilter(request, response);
				// not a user; deny access
				} else {
					httpResponse = (HttpServletResponse) response;
					httpResponse.sendRedirect("/PiBox/error.html");
				}
			} else {
				// failed to get user
				httpResponse = (HttpServletResponse) response;
				httpResponse.sendRedirect("/PiBox/error.html");
			}
		
		// user not in session
		} else {
			httpResponse = (HttpServletResponse) response;
			httpResponse.sendRedirect("/PiBox/Login");
		}
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		userDao = new UserDAO();
		this.filterConfig = arg0;
	}

}
