package com.example.demo.config;

import com.example.demo.filter.JwtRequestFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
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
		http
				.authorizeHttpRequests(auth -> auth
						.requestMatchers("/h2-console/**").permitAll()
						.requestMatchers("/api/auth/**").permitAll()
						.requestMatchers(HttpMethod.GET, "/api/products").permitAll()
						.requestMatchers(HttpMethod.GET, "/api/products/*").permitAll()

						// Product admin endpoints
						.requestMatchers(HttpMethod.POST, "/api/products").hasAuthority("ROLE_ADMIN")
						.requestMatchers(HttpMethod.PUT, "/api/products/*").hasAuthority("ROLE_ADMIN")
						.requestMatchers(HttpMethod.DELETE, "/api/products/*").hasAuthority("ROLE_ADMIN")
						.requestMatchers(HttpMethod.GET, "/api/products/low-stock").hasAuthority("ROLE_ADMIN")

						// Order endpoints
						.requestMatchers(HttpMethod.POST, "/api/orders").authenticated()
						.requestMatchers(HttpMethod.GET, "/api/orders/my-orders").authenticated()
						.requestMatchers(HttpMethod.GET, "/api/orders/*").authenticated()

						// Admin order endpoints
						.requestMatchers(HttpMethod.GET, "/api/orders/admin/**").hasAuthority("ROLE_ADMIN")
						.requestMatchers(HttpMethod.PUT, "/api/orders/*/status").hasAuthority("ROLE_ADMIN")

						.anyRequest().authenticated()
				)
				.headers(headers -> headers.frameOptions().disable())
				.csrf(csrf -> csrf
						.ignoringRequestMatchers("/h2-console/**")
						.ignoringRequestMatchers("/api/**")
				)
				.sessionManagement(session -> session
						.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
				);

		// Add JWT filter
		http.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);

		return http.build();
	}
}