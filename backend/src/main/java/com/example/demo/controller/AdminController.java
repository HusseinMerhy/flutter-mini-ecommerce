package com.example.demo.controller;

import com.example.demo.model.Order;
import com.example.demo.model.Product;
import com.example.demo.service.OrderService;
import com.example.demo.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin
public class AdminController {

	@Autowired
	private OrderService orderService;

	@Autowired
	private ProductService productService;

	@GetMapping("/orders")
	public ResponseEntity<List<Order>> getAllOrders() {
		List<Order> orders = orderService.getAllOrders();
		return ResponseEntity.ok(orders);
	}

	@GetMapping("/low-stock")
	public ResponseEntity<List<Product>> getLowStock(@RequestParam(defaultValue = "5") int threshold) {
		List<Product> lowStockProducts = productService.getLowStockProducts(threshold);
		return ResponseEntity.ok(lowStockProducts);
	}
}
