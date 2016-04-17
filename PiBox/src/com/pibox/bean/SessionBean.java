package com.pibox.bean;

import java.io.Serializable;
import java.util.List;

public class SessionBean implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int id;
	private String name;
	private String activity;
	private String status;
	private List<UserActivitySession>  userSessions;
	
	public SessionBean(int sessionId, String sessionName, String sessionGame, List<UserActivitySession> userSessions) {
		this.id = sessionId;
		this.name = sessionName;
		this.activity = sessionGame;
		this.userSessions = userSessions;
	}
	
	public SessionBean(int sessionId, String sessionName, String sessionGame, String status) {
		this.id = sessionId;
		this.name = sessionName;
		this.activity = sessionGame;
		this.status = status;
	}
	
	public SessionBean(String sessionName, String sessionGame, String status) {
		this.name = sessionName;
		this.activity = sessionGame;
		this.status = status;
	}
	
	public SessionBean() {
		this.id = -1;
		this.name = null;
		this.status  = null;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int sessionId) {
		this.id = sessionId;
	}
	public String getName() {
		return name;
	}
	public void setName(String sessionName) {
		this.name = sessionName;
	}
	public String getActivity() {
		return activity;
	}
	public void setActivity(String sessionGame) {
		this.activity = sessionGame;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public void setIsActive(String status) {
		this.status = status;
	}
	public List<UserActivitySession> getUserSessions() {
		return userSessions;
	}
	public void setUserSessions(List<UserActivitySession> userSessions) {
		this.userSessions = userSessions;
	}
	
	
	
}
