package com.pibox.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.pibox.bean.UserBean;

@SuppressWarnings("serial")
public class ErrorServlet extends HttpServlet {
	
	protected void doGet(	HttpServletRequest request,
							HttpServletResponse response ) throws IOException, ServletException {
		request.getRequestDispatcher("/WEB-INF/pages/error.jsp").forward(request, response);
	}
}
