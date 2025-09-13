package com.example.demo.service;

import com.example.demo.dto.OrderItemRequest;
import com.example.demo.model.*;
import com.example.demo.repository.OrderRepository;
import com.example.demo.repository.ProductRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class OrderService {

	@Autowired
	private OrderRepository orderRepository;

	@Autowired
	private ProductRepository productRepository;

	@Autowired
	private UserRepository userRepository;

	public Order createOrder(Long userId, List<OrderItemRequest> orderItemRequests) {
		User user = userRepository.findById(userId)
				.orElseThrow(() -> new RuntimeException("User not found"));

		Order order = new Order(user);

		for (OrderItemRequest itemRequest : orderItemRequests) {
			Product product = productRepository.findById(itemRequest.getProductId())
					.orElseThrow(() -> new RuntimeException("Product not found: " + itemRequest.getProductId()));

			if (product.getStock() < itemRequest.getQuantity()) {
				throw new RuntimeException("Insufficient stock for product: " + product.getName());
			}

			product.setStock(product.getStock() - itemRequest.getQuantity());
			productRepository.save(product);

			OrderItem orderItem = new OrderItem(product, itemRequest.getQuantity(), product.getPrice());
			order.addItem(orderItem);
		}

		order.calculateTotalAmount();
		return orderRepository.save(order);
	}

	public List<Order> getAllOrders() {
		return orderRepository.findAllByOrderByOrderDateDesc();
	}

	public Optional<Order> getOrderById(Long id) {
		return orderRepository.findById(id);
	}

	public Order updateOrderStatus(Long orderId, String status) {
		Order order = orderRepository.findById(orderId)
				.orElseThrow(() -> new RuntimeException("Order not found"));
		order.setStatus(status);
		return orderRepository.save(order);
	}

	public List<Order> getUserOrders(Long userId) {
		User user = userRepository.findById(userId)
				.orElseThrow(() -> new RuntimeException("User not found"));
		return orderRepository.findByUser(user);
	}
}