package com.example.demo.model;

import jakarta.persistence.*;

import java.math.BigDecimal;

@Entity
@Table(name="products")
public class Product {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column(nullable = false)
	private String name;
	@Column(nullable = false)
	private BigDecimal price;

	public String getImageUrl () {
		return imageUrl;
	}

	public void setImageUrl (String imageUrl) {
		this.imageUrl = imageUrl;
	}

	@Column(nullable = false)
	private int stock;
	private String imageUrl;
	public Product () {
	}

	public Product (String name, BigDecimal price, int stock) {
		this.name = name;
		this.price = price;
		this.stock = stock;
	}

	public String getName () {
		return name;
	}

	public void setName (String name) {
		this.name = name;
	}

	public BigDecimal getPrice () {
		return price;
	}

	public void setPrice (BigDecimal price) {
		this.price = price;
	}

	public int getStock () {
		return stock;
	}

	public void setStock (int stock) {
		this.stock = stock;
	}

	public Long getId () {
		return id;
	}

	public void setId (Long id) {
		this.id = id;
	}
}
