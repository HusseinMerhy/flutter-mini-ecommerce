package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;

import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.List;

@Configuration
public class CorsConfig {

	@Bean
	public CorsFilter corsFilter() {
		CorsConfiguration corsConfiguration = new CorsConfiguration();
		corsConfiguration.setAllowCredentials(true);
		// include the URLs your Flutter app uses (adjust if needed)
		corsConfiguration.setAllowedOriginPatterns(List.of("http://localhost:8080", "http://localhost:57596", "http://10.0.2.2:8080", "*"));
		corsConfiguration.setAllowedHeaders(List.of(
				"Origin", "Content-Type", "Accept", "Authorization",
				"X-Requested-With", "Access-Control-Request-Method", "Access-Control-Request-Headers"
		));
		corsConfiguration.setExposedHeaders(List.of(
				"Origin", "Content-Type", "Accept", "Authorization",
				"Access-Control-Allow-Origin", "Access-Control-Allow-Credentials"
		));
		corsConfiguration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
		corsConfiguration.setMaxAge(3600L);

		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", corsConfiguration);

		return new CorsFilter(source);
	}
}
