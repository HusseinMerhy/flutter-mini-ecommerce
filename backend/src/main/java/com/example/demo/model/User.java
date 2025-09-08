package com.example.demo.model;

import jakarta.persistence.*;


@Entity
@Table(name = "users")
public class User {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column(nullable = false ,unique = true)
	private String email;
	@Column(nullable = false,unique = false)
	private String password;
	@Column(nullable = false)
	private String role = "ROLE_USER"; // Default role

	public static final String ROLE_USER = "ROLE_USER";
	public static final String ROLE_ADMIN = "ROLE_ADMIN";
	
	public User () {
	}

	public User (String email, String password, String role) {
		this.email = email;
		this.password = password;
		this.role = role;
	}

	public String getRole () {
		return role;
	}

	public void setRole (String role) {
		this.role = role;
	}

	public String getEmail () {
		return email;
	}

	public Long getId () {
		return id;
	}

	public String getPassword () {
		return password;
	}

	public void setEmail (String email) {
		this.email = email;
	}

	public void setId (Long id) {
		this.id = id;
	}

	public void setPassword (String password) {
		this.password = password;
	}
}
