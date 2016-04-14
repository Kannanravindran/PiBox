package com.pibox.api.rest;

import java.sql.SQLException;
import java.util.List;

import javax.ws.rs.DELETE;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.pibox.bean.UserBean;
import com.pibox.dao.UserDAO;

@Path("rest/users")
public class UserRest {
	
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Response getAllUsers() {
		Response response = null;
		UserDAO userDao = new UserDAO();
		List<UserBean> usersToReturn;
		try {
			usersToReturn = userDao.readAllUsers();
			if(usersToReturn != null) {
				response = Response.ok(usersToReturn).build();
			} else {
				response = Response.status(404).build();
			}
			
		} catch (SQLException e) {
			response = Response.status(500).build();
			e.printStackTrace();
		}
		return response;
	}
	
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("{id}")
	public Response getUserById(@PathParam("id") int id) {
		Response response = null;
		UserDAO userDao = new UserDAO();
		UserBean userToReturn;
		try {
			userToReturn = userDao.readUser(id);
			if(userToReturn != null) {
				response = Response.ok(userToReturn).build();
			} else {
				response = Response.status(404).build();
			}
			
		} catch (SQLException e) {
			response = Response.status(500).build();
			e.printStackTrace();
		}
		return response;
	}
	
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public Response createUser( @FormParam("username") String username,
								@FormParam("password") String password,
								@FormParam("type") String type,
								@FormParam("email") String email,
								@FormParam("firstName") String firstName,
								@FormParam("lastName") String lastName) {
		Response response = null;
		
		UserBean userToCreate = new UserBean(username, password, type, email, firstName, lastName);
		UserBean userToReturn;
		try {
			UserDAO userDao = new UserDAO();
			userToReturn = userDao.createUser(userToCreate);
			response = Response.ok(userToReturn).build();
		} catch (SQLException e) {
			response = Response.status(500).build();
			e.printStackTrace();
		}
		return response;
	}
	
	@PUT
	@Produces(MediaType.APPLICATION_JSON)
	public Response updateUser( @FormParam("id") int userId,
								@FormParam("username") String username,
								@FormParam("password") String password,
								@FormParam("email") String email,
								@FormParam("firstName") String firstName,
								@FormParam("lastName") String lastName,
								@FormParam("type") String type) {
		Response response = null;
		
		UserDAO userDao = new UserDAO();
		UserBean userToUpdate = new UserBean(username, password, type, email, firstName, lastName);
		userToUpdate.setId(userId);
		UserBean userToReturn;
		try {
			userToReturn = userDao.updateUser(userToUpdate);
			response = Response.ok(userToReturn).build();
		} catch (SQLException e) {
			response = Response.status(500).build();
			e.printStackTrace();
		}
		return response;
	}
	
	@DELETE
	@Produces(MediaType.APPLICATION_JSON)
	public Response deleteUser( @FormParam("id") int userId) {
		Response response = null;
		UserDAO userDao = new UserDAO();
		try {
			userDao.deleteUser(userId);
			response = Response.noContent().build();
		} catch (SQLException e) {
			response = Response.status(500).build();
			e.printStackTrace();
		}
		return response;
	}
}
