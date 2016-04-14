package com.pibox.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.pibox.bean.UserBean;

public class UserDAO {
	
	private Connection getConnection() throws SQLException {
		Connection dbConnection = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Context initContext = new InitialContext();
			Context envContext = (Context)initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource)envContext.lookup("jdbc/pibox");
			dbConnection = ds.getConnection();
			return dbConnection;
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return dbConnection;
	}
	
	/* CRUD Operations */
	public UserBean createUser(UserBean userToCreate) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String createUserSqlQuery = "INSERT INTO users (type, username, password, email, firstname, lastname)"
									+ " VALUES(?, ?, ?, ?, ?, ?)";
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(createUserSqlQuery);
			pStatement.setString(1, userToCreate.getType());
			pStatement.setString(2, userToCreate.getUsername());
			pStatement.setString(3, userToCreate.getPassword());
			pStatement.setString(4, userToCreate.getEmail());
			pStatement.setString(5, userToCreate.getFirstName());
			pStatement.setString(6, userToCreate.getLastName());
			pStatement.executeUpdate();
			// get id of user, set it, then return it
			
			//Get generated key
			int newId = -1;
			ResultSet generatedKeys = pStatement.getGeneratedKeys();
			if (generatedKeys.next()) {
				newId = (int) generatedKeys.getLong(1);
			}
			userToCreate.setId(newId);
			
		} finally {
			dbConnection.close();
		}
		return userToCreate;
	}
	
	public UserBean readUser(int userIdToRead) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSqlQuery = "SELECT id, username, type, email, firstname, lastname FROM users WHERE id = ?";
		UserBean userToReturn = null;
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSqlQuery);
			pStatement.setInt(1, userIdToRead);
			ResultSet rs = pStatement.executeQuery();
			if(rs.next()) {
				userToReturn = new UserBean(
						rs.getInt(1),	// id
						rs.getString(2),	// username
						null,				// password
						rs.getString(3),	// type
						rs.getString(4),	// email
						rs.getString(5),	// firstname
						rs.getString(6)		// lastname
						);
			}
		} finally {
			dbConnection.close();
		}
		return userToReturn;
	}
	
	public List<UserBean> readAllUsers() throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSqlQuery = "SELECT id, username, type, email, firstname, lastname FROM users";
		UserBean userToAdd = null;
		ArrayList<UserBean> usersToReturn = new ArrayList<UserBean>();
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSqlQuery);			
			ResultSet rs = pStatement.executeQuery();
			while(rs.next()) {
				userToAdd = new UserBean(
						rs.getInt(1),	// id
						rs.getString(2),	// username
						null,				// password
						rs.getString(3),	// type
						rs.getString(4),	// email
						rs.getString(5),	// firstname
						rs.getString(6)		// lastname
						);
				usersToReturn.add(userToAdd);
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return usersToReturn;
	}
	
	public UserBean updateUser(UserBean userToUpdate) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSqlQuery = "UPDATE users SET username=?, password=?, email=?, "
									+ "firstname=?, lastname=? type=? WHERE id=?";
		UserBean userToReturn = null;
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSqlQuery);
			pStatement.setString(1, userToUpdate.getUsername());
			pStatement.setString(2, userToUpdate.getPassword());
			pStatement.setString(3, userToUpdate.getEmail());
			pStatement.setString(4, userToUpdate.getFirstName());
			pStatement.setString(5, userToUpdate.getLastName());
			pStatement.setString(6, userToUpdate.getType());
			pStatement.setInt(7, userToUpdate.getId());
			ResultSet rs = pStatement.executeQuery();
			if(rs.next()) {
				userToReturn = userToUpdate;
			}
		} finally {
			dbConnection.close();
		}
		return userToReturn;
	}
	
	public void deleteUser(int userIdToDelete) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSqlQuery = "DELETE FROM users WHERE id=?";
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSqlQuery);			
			pStatement.executeQuery();
		} finally {
			dbConnection.close();
		}
	}
	
	
	/* OTHER NON-CRUD OPERATIONS */

	public String getUserTypeForUsername(String username) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSqlQuery = "SELECT type FROM users"
									+ "WHERE username = ?";
		String userTypeToReturn = null;
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSqlQuery);			
			ResultSet rs = pStatement.executeQuery();
			if(rs.next()) {
				userTypeToReturn = rs.getString(1);	// type
			}
		} finally {
			dbConnection.close();
		}
		return userTypeToReturn;
	}
	
	public UserBean getUserForCredentials(String usernameToVerify) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSqlQuery = "SELECT id, type, username, email, firstname, lastname FROM users WHERE username = ?";
		UserBean userToReturn = null;
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSqlQuery);
			pStatement.setString(1, usernameToVerify);
			ResultSet rs = pStatement.executeQuery();
			if(rs.next()) {
				userToReturn = new UserBean(
						rs.getInt(1),	// id
						rs.getString(3),	// username
						null,				// password
						rs.getString(2),	// type
						rs.getString(4),	// email
						rs.getString(5),	// firstname
						rs.getString(6)		// lastname
						);
			}
		} finally {
			dbConnection.close();
		}
		return userToReturn;
	}
}
