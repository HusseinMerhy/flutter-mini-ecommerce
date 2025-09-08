package com.example.demo.controller;

import com.example.demo.dto.OrderDTO;
import com.example.demo.dto.OrderItemDTO;
import com.example.demo.dto.OrderItemRequest;
import com.example.demo.model.Order;
import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

	@Autowired
	private OrderService orderService;

	@Autowired
	private UserRepository userRepository;

	@PostMapping
	public ResponseEntity<?> createOrder(
			@AuthenticationPrincipal UserDetails userDetails,
			@RequestBody List<OrderItemRequest> orderItemRequests) {
		try {
			User user = userRepository.findByEmail(userDetails.getUsername())
					.orElseThrow(() -> new RuntimeException("User not found"));
			Long userId = user.getId();

			Order order = orderService.createOrder(userId, orderItemRequests);

			// Convert to DTO
			OrderDTO orderDTO = convertToDTO(order);

			return ResponseEntity.status(HttpStatus.CREATED).body(orderDTO);
		} catch (RuntimeException e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
		}
	}

	// Helper method to handle both request formats
	private List<OrderItemRequest> convertToOrderItemRequests(List<Object> orderItems) {
		List<OrderItemRequest> requests = new ArrayList<>();

		for (Object item : orderItems) {
			if (item instanceof Map) {
				Map<String, Object> itemMap = (Map<String, Object>) item;
				OrderItemRequest request = new OrderItemRequest();

				// Handle both formats: with "productId" or with "product" object
				if (itemMap.containsKey("productId")) {
					request.setProductId(Long.valueOf(itemMap.get("productId").toString()));
					request.setQuantity(Integer.valueOf(itemMap.get("quantity").toString()));
				} else if (itemMap.containsKey("product")) {
					Map<String, Object> productMap = (Map<String, Object>) itemMap.get("product");
					request.setProductId(Long.valueOf(productMap.get("id").toString()));
					request.setQuantity(Integer.valueOf(itemMap.get("quantity").toString()));
				}

				requests.add(request);
			}
		}

		return requests;
	}
	// Helper method to convert Order to OrderDTO
	private OrderDTO convertToDTO(Order order) {
		List<OrderItemDTO> itemDTOs = order.getItems().stream()
				.map(item -> new OrderItemDTO(
						item.getId(),
						item.getProduct().getId(),
						item.getProduct().getName(),
						item.getQuantity(),
						item.getPrice(),
						item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()))
				))
				.collect(Collectors.toList());

		return new OrderDTO(
				order.getId(),
				order.getUser().getId(),
				order.getUser().getEmail(),
				order.getOrderDate(),
				order.getTotalAmount(),
				order.getStatus(),
				itemDTOs
		);
	}

	@GetMapping("/my-orders")
	public ResponseEntity<List<Order>> getUserOrders(@AuthenticationPrincipal UserDetails userDetails) {
		try {
			// Get user by email from UserDetails
			User user = userRepository.findByEmail(userDetails.getUsername())
					.orElseThrow(() -> new RuntimeException("User not found"));
			Long userId = user.getId();

			List<Order> orders = orderService.getUserOrders(userId);
			return ResponseEntity.ok(orders);
		} catch (RuntimeException e) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
		}
	}

	@GetMapping("/admin/all-orders")
	public ResponseEntity<List<Order>> getAllOrders() {
		try {
			List<Order> orders = orderService.getAllOrders();
			return ResponseEntity.ok(orders);
		} catch (RuntimeException e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	@GetMapping("/{id}")
	public ResponseEntity<Order> getOrderById(@PathVariable Long id) {
		Optional<Order> order = orderService.getOrderById(id);
		return order.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}

	@PutMapping("/{id}/status")
	public ResponseEntity<Order> updateOrderStatus(
			@PathVariable Long id,
			@RequestParam String status) {
		try {
			Order order = orderService.updateOrderStatus(id, status);
			return ResponseEntity.ok(order);
		} catch (RuntimeException e) {
			return ResponseEntity.notFound().build();
		}
	}
}