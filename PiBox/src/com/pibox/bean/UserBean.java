package com.pibox.bean;

import java.io.Serializable;


public class UserBean implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private int id;
	private String username;
	private String password;
	private String type;
	private String email;
	private String firstName;
	private String lastName;
	
	public UserBean(int id, String username, String password, String type, String email,
			String firstName, String lastName) {
		this.id = id;
		this.username = username;
		this.password = password;
		this.type = type;
		this.email = email;
		this.firstName = firstName;
		this.lastName = lastName;
	}
	
	public UserBean(String username, String password, String type, String email,
					String firstName, String lastName) {
		this.username = username;
		this.password = password;
		this.type = type;
		this.email = email;
		this.firstName = firstName;
		this.lastName = lastName;
	}
	
	/* GETTERS & SETTERS */
	public int getId() {
		return id;
	}

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}
	
	public String getType() {
		return type;
	}

	public String getEmail() {
		return email;
	}

	public String getFirstName() {
		return firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	public void setType(String type) {
		this.type = type;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
}