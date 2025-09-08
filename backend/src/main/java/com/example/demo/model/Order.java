package com.example.demo.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
public class Order {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;

	@Column(nullable = false)
	private LocalDateTime orderDate;

	@Column(nullable = false)
	private BigDecimal totalAmount;

	@Column(nullable = false)
	private String status;

	@OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
	@JsonManagedReference
	private List<OrderItem> items = new ArrayList<>();

	public Order () {
		this.orderDate = LocalDateTime.now();
		this.status = "PENDING";
	}

	public Order (User user) {
		this();
		this.user = user;
	}

	public void addItem (OrderItem item) {
		items.add(item);
		item.setOrder(this);
	}

	public void calculateTotalAmount() {
		this.totalAmount = items.stream()
				.map(item -> item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
				.reduce(BigDecimal.ZERO, BigDecimal::add);
	}

	public Long getId () {
		return id;
	}

	public void setId (Long id) {
		this.id = id;
	}

	public User getUser () {
		return user;
	}

	public void setUser (User user) {
		this.user = user;
	}

	public LocalDateTime getOrderDate () {
		return orderDate;
	}

	public void setOrderDate (LocalDateTime orderDate) {
		this.orderDate = orderDate;
	}

	public BigDecimal getTotalAmount () {
		return totalAmount;
	}

	public void setTotalAmount (Double totalAmount) {
		this.totalAmount = BigDecimal.valueOf(totalAmount);
	}

	public String getStatus () {
		return status;
	}

	public void setStatus (String status) {
		this.status = status;
	}

	public List<OrderItem> getItems () {
		return items;
	}

	public void setItems (List<OrderItem> items) {
		this.items = items;
	}
}