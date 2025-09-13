package com.example.demo.config;

import com.example.demo.filter.JwtRequestFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;

import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;

@Configuration
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

	@Autowired
	private JwtRequestFilter jwtRequestFilter;

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public AuthenticationManager authenticationManager(
			AuthenticationConfiguration authenticationConfiguration) throws Exception {
		return authenticationConfiguration.getAuthenticationManager();
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http.cors().and()
				.authorizeHttpRequests(auth -> auth
						// public/h2 and auth endpoints
						.requestMatchers("/h2-console/**").permitAll()
						.requestMatchers("/api/auth/**").permitAll()
						// public product reads
						.requestMatchers(HttpMethod.GET, "/api/products/**").permitAll()
						// admin area - guarded
						.requestMatchers("/api/admin/**").hasRole("ADMIN")
						.requestMatchers(HttpMethod.POST, "/api/products").hasRole("ADMIN")
						.requestMatchers(HttpMethod.PUT, "/api/products/**").hasRole("ADMIN")
						.requestMatchers(HttpMethod.DELETE, "/api/products/**").hasRole("ADMIN")
						// order endpoints - allow authenticated users to place orders and view their orders
						.requestMatchers(HttpMethod.POST, "/api/orders").hasAnyRole("USER", "ADMIN")
						.requestMatchers(HttpMethod.GET, "/api/orders/my-orders").hasAnyRole("USER", "ADMIN")
						// admin order endpoints (if used)
						.requestMatchers(HttpMethod.GET, "/api/orders/admin/**").hasRole("ADMIN")
						// everything else must be authenticated
						.anyRequest().authenticated()
				)
				.headers(headers -> headers.frameOptions().disable())
				.csrf(csrf -> csrf.disable()) // stateless REST API - disabled (H2 console is already allowed)
				.sessionManagement(session -> session
						.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
				);

		// JWT filter
		http.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
		return http.build();
	}
}
