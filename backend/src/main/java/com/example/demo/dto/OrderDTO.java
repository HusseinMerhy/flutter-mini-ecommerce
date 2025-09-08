package com.example.demo.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class OrderDTO {
	private Long id;
	private Long userId;
	private String userEmail;
	private LocalDateTime orderDate;
	private BigDecimal totalAmount;
	private String status;
	private List<OrderItemDTO> items;

	// Constructors, getters, and setters
	public OrderDTO() {}

	public OrderDTO(Long id, Long userId, String userEmail, LocalDateTime orderDate,
	                BigDecimal totalAmount, String status, List<OrderItemDTO> items) {
		this.id = id;
		this.userId = userId;
		this.userEmail = userEmail;
		this.orderDate = orderDate;
		this.totalAmount = totalAmount;
		this.status = status;
		this.items = items;
	}

	// Getters and setters for all fields
	public Long getId() { return id; }
	public void setId(Long id) { this.id = id; }

	public Long getUserId() { return userId; }
	public void setUserId(Long userId) { this.userId = userId; }

	public String getUserEmail() { return userEmail; }
	public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

	public LocalDateTime getOrderDate() { return orderDate; }
	public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

	public BigDecimal getTotalAmount() { return totalAmount; }
	public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }

	public List<OrderItemDTO> getItems() { return items; }
	public void setItems(List<OrderItemDTO> items) { this.items = items; }
}