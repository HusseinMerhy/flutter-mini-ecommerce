package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.service.UserService;
import com.example.demo.util.JwtTokenUtil;
import com.example.demo.service.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin
public class AuthController {

	@Autowired
	private UserService userService;

	@Autowired
	private JwtTokenUtil jwtTokenUtil;

	@Autowired
	private CustomUserDetailsService customUserDetailsService;

	@PostMapping("/register")
	public ResponseEntity<?> registerUser(@RequestBody User user) {
		try {
			User savedUser = userService.registerUser(user);

			Map<String, Object> response = new HashMap<>();
			response.put("message", "User registered successfully");
			response.put("userId", savedUser.getId());

			return ResponseEntity.status(HttpStatus.CREATED).body(response);
		} catch (RuntimeException e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST)
					.body("Registration failed: " + e.getMessage());
		}
	}

	@PostMapping("/login")
	public ResponseEntity<?> loginUser(@RequestBody LoginRequest loginRequest) {
		try {
			User user = userService.loginUser(loginRequest.getEmail(), loginRequest.getPassword());

			UserDetails userDetails = customUserDetailsService.loadUserByUsername(user.getEmail());

			String token = jwtTokenUtil.generateToken(userDetails);

			Map<String, Object> response = new HashMap<>();
			response.put("message", "Login successful");
			response.put("token", token);
			response.put("user", user);

			return ResponseEntity.ok(response);
		} catch (RuntimeException e) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
					.body("Invalid credentials: " + e.getMessage());
		}
	}

	public static class LoginRequest {
		private String email;
		private String password;

		public LoginRequest() {}

		public String getEmail() {
			return email;
		}

		public void setEmail(String email) {
			this.email = email;
		}

		public String getPassword() {
			return password;
		}

		public void setPassword(String password) {
			this.password = password;
		}
	}
}
