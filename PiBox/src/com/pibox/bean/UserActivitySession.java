package com.pibox.bean;

import java.io.Serializable;

public class UserActivitySession implements Serializable {
	private static final long serialVersionUID = 1L;
	
	int sessionId;
	int userId;
	String sessionName;
	String userName;
	int userScore;
	
	public UserActivitySession(int sessionId, String sessionName, int userId, String userName, int userScore) {
		this.sessionId = sessionId;
		this.sessionName = sessionName;
		this.userId = userId;
		this.userName = userName;
		this.userScore = userScore;
	}

	public int getSessionId() {
		return sessionId;
	}

	public void setSessionId(int sessionId) {
		this.sessionId = sessionId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getUserScore() {
		return userScore;
	}

	public void setUserScore(int userScore) {
		this.userScore = userScore;
	}

	public String getSessionName() {
		return sessionName;
	}

	public void setSessionName(String sessionName) {
		this.sessionName = sessionName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
}
