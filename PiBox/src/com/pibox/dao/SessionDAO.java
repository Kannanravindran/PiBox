package com.pibox.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.pibox.bean.SessionBean;
import com.pibox.bean.UserBean;
import com.pibox.bean.UserActivitySession;

public class SessionDAO {
	
	private Connection getConnection() throws SQLException {
		Connection dbConnection = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			
			Context initContext = new InitialContext();
			Context envContext = (Context)initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource)envContext.lookup("jdbc/pibox");
			
			dbConnection = ds.getConnection();
			
			if(dbConnection == null) {
				Logger.getLogger("SessionDAO").log(Level.SEVERE, "Got null connection!");
			}
			
			return dbConnection;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (NamingException e) {
			e.printStackTrace();
		}
		if(dbConnection == null) {
			Logger.getLogger("SessionDAO").log(Level.SEVERE, "Got null connection!");
		}
		
		return dbConnection;
	}
	
	/* CRUD Operations */
	public SessionBean createSession(SessionBean sessionToCreate) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String createSessionSqlQuery = "INSERT INTO sessions (name, activity)"
									+ " VALUES(?, ?)";
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(createSessionSqlQuery);
			pStatement.setString(1, sessionToCreate.getName());
			pStatement.setString(2, sessionToCreate.getActivity());
			pStatement.executeUpdate();
			// get id of user, set it, then return it
			
			//Get generated key
			int newId = -1;
			ResultSet generatedKeys = pStatement.getGeneratedKeys();
			if (generatedKeys.next()) {
				newId = (int) generatedKeys.getLong(1);
			}
			sessionToCreate.setId(newId);
			
			if(pStatement != null) {
				pStatement.close();
			}
			if(generatedKeys != null) {
				generatedKeys.close();
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return sessionToCreate;
	}

	public SessionBean readSession(int sessionIdToRead) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String readSessionSqlQuery = "SELECT name, activity, status FROM sessions WHERE id = ?";
		SessionBean sessionToReturn = null;
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(readSessionSqlQuery);
			pStatement.setInt(1, sessionIdToRead);
			ResultSet rs = pStatement.executeQuery();
			if(rs.next()) {
				sessionToReturn = new SessionBean(
						sessionIdToRead,
						rs.getString(1),	// name
						rs.getString(2),	// activity
						rs.getString(3)		//status
						);
				sessionToReturn.setUserSessions(this.getUserSessionsForSessionId(sessionIdToRead));
			}
			if(pStatement != null) {
				pStatement.close();
			}
			if(rs != null) {
				rs.close();
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return sessionToReturn;
	}
	
	public List<SessionBean> readAllSessions() throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String readAllSessionsSqlQuery = "SELECT id, name, activity, status FROM sessions";
		SessionBean sessionToAdd = null;
		ArrayList<SessionBean> sessionsToReturn = new ArrayList<SessionBean>();
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(readAllSessionsSqlQuery);			
			ResultSet rs = pStatement.executeQuery();
			while(rs.next()) {
				sessionToAdd = new SessionBean(
						rs.getInt(1),		// id
						rs.getString(2),	// name
						rs.getString(3),	// activity
						rs.getString(4)		// status
						);
				sessionsToReturn.add(sessionToAdd);
			}
			
			if(pStatement != null) {
				pStatement.close();
			}
			if(rs != null) {
				rs.close();
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return sessionsToReturn;
	}
	
	public SessionBean updateSession(SessionBean sessionToUpdate) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String updateSessionSqlQuery = "UPDATE sessions SET name=?, activity=?, status=? "
									+ "WHERE id=?";
		SessionBean sessionToReturn = null;
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(updateSessionSqlQuery);
			pStatement.setString(1, sessionToUpdate.getName());
			pStatement.setString(2, sessionToUpdate.getActivity());
			pStatement.setString(3, sessionToUpdate.getStatus());
			pStatement.setInt(4, sessionToUpdate.getId());
			pStatement.executeUpdate();
			if(pStatement != null) {
				pStatement.close();
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return sessionToReturn;
	}
	
	public void deleteSession(int sessionIdToDelete) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String deleteSessionSqlQuery = "DELETE FROM sessions WHERE id=?";
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(deleteSessionSqlQuery);
			pStatement.setInt(1, sessionIdToDelete);
			pStatement.executeUpdate();
			if(pStatement != null) {
				pStatement.close();
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
	}
	
	
	/* OTHER NON-CRUD OPERATIONS */
	public List<UserActivitySession> getUserSessionsForSessionId(int id) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSessionSqlQuery = "SELECT s.id, s.name, u.id, u.username, j.userScore "
											+ "FROM sessions s, users u, sessionUserAssoc j "
											+ "WHERE j.userId = u.id AND "
												+ "j.sessionId = s.id AND "
												+ "s.id = ?";
		UserActivitySession userSessionToAdd = null;
		List<UserActivitySession> userSessionsToReturn = new ArrayList<UserActivitySession>();
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSessionSqlQuery);
			pStatement.setInt(1, id);
			ResultSet rs = pStatement.executeQuery();
			while(rs.next()) {
				userSessionToAdd = new UserActivitySession(
						rs.getInt(1),		// sessionId
						rs.getString(2),	// sessionName
						rs.getInt(3),		// userId
						rs.getString(4),	// userName
						rs.getInt(5)		// user score
						);
				userSessionsToReturn.add(userSessionToAdd);
			}
			if(pStatement != null) {
				pStatement.close();
			}
			if(rs != null) {
				rs.close();
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return userSessionsToReturn;
	}
	
	
	public SessionBean addUserToSession(int userIdToAddToSession, int sessionId) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String insertUserSessionSqlQuery = "INSERT INTO sessionuserassoc (sessionId, userId, userScore)"
															+ " VALUES (?, ?, 0);"; // start user off with a score of 0
		SessionBean sessionBeanToReturn = this.readSession(sessionId);
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(insertUserSessionSqlQuery);	
			pStatement.setInt(1, sessionId);
			pStatement.setInt(2, userIdToAddToSession);
			pStatement.executeUpdate();
			sessionBeanToReturn = this.readSession(sessionId);
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return sessionBeanToReturn;
	}
	
	public UserActivitySession getUserSessionForSessionId(int userId, int sessionId) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSessionSqlQuery = "SELECT s.id, s.name, u.id, u.username, j.userScore "
											+ "FROM sessions s, users u, sessionUserAssoc j "
											+ "WHERE j.userId = u.id AND "
												+ "j.sessionId = s.id AND "
												+ "s.id = ? AND "
												+ "u.id = ?";
		UserActivitySession userSessionToReturn = null;
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSessionSqlQuery);		
			pStatement.setInt(1, sessionId);
			pStatement.setInt(2, userId);
			
			ResultSet rs = pStatement.executeQuery();
			if(rs.next()) {
				userSessionToReturn = new UserActivitySession(
						rs.getInt(1),		// sessionId
						rs.getString(2),	// sessionName
						rs.getInt(3),		// userId
						rs.getString(4),	// userName
						rs.getInt(5)		// user score
						);
			}
			if(pStatement != null) {
				pStatement.close();
			}
			if(rs != null) {
				rs.close();
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return userSessionToReturn;
	}
	
	public UserActivitySession updateUserSession(UserActivitySession updatedSession) throws SQLException {
		Connection dbConnection = null;
		PreparedStatement pStatement;
		String selectUserSessionSqlQuery = "UPDATE sessionuserassoc "
											+ "SET userScore=? "
											+ "WHERE sessionId=? "
												+ "AND userId=?";
		UserActivitySession userSessionToReturn = null;
		try {
			dbConnection = getConnection();
			pStatement = (PreparedStatement) dbConnection.prepareStatement(selectUserSessionSqlQuery);		
			pStatement.setInt(1, updatedSession.getUserScore());
			pStatement.setInt(2, updatedSession.getSessionId());
			pStatement.setInt(3, updatedSession.getUserId());
			
			pStatement.executeUpdate();
			
			userSessionToReturn = updatedSession;
			if(pStatement != null) {
				pStatement.close();
			}
		} finally {
			if(dbConnection != null) {
				dbConnection.close();
			}
		}
		return userSessionToReturn;
	}
}
