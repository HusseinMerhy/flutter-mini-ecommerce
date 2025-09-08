package com.example.demo.service;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder; // ← This import!
import org.springframework.stereotype.Service;

import java.util.Optional;
@Service
public class UserService {
	@Autowired
	private UserRepository userRepository;

	@Autowired
	private PasswordEncoder passwordEncoder;

	public User registerUser(User user) {

		if (userRepository.findByEmail(user.getEmail()).isPresent()) {
			throw new RuntimeException("Email already registered");
		}


		user.setPassword(passwordEncoder.encode(user.getPassword()));


		if (user.getRole() == null) {
			user.setRole(User.ROLE_USER);
		}


		if (userRepository.count() == 0) {
			user.setRole(User.ROLE_ADMIN);
		}

		return userRepository.save(user);
	}


	public User updateUserRole(Long userId, String newRole) {
		User user = userRepository.findById(userId)
				.orElseThrow(() -> new RuntimeException("User not found"));
		user.setRole(newRole);
		return userRepository.save(user);
	}

	public User loginUser(String email, String password) {
		Optional<User> userOptional = userRepository.findByEmail(email);

		if (userOptional.isPresent()) {
			User user = userOptional.get();


			if (passwordEncoder.matches(password, user.getPassword())) {
				return user;
			}
		}

		throw new RuntimeException("Invalid email or password");
	}


	public Optional<User> findByEmail(String email) {
		return userRepository.findByEmail(email);
	}

}