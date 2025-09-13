package com.example.demo.controller;

import com.example.demo.model.Product;
import com.example.demo.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
@CrossOrigin
public class ProductController {

	@Autowired
	private ProductService productService;


	@GetMapping
	public ResponseEntity<List<Product>> getAllProducts() {
		List<Product> products = productService.getAllProducts();
		return ResponseEntity.ok(products);
	}


	@GetMapping("/{id}")
	public ResponseEntity<Product> getProductById(@PathVariable Long id) {
		Optional<Product> product = productService.getProductById(id);
		return product.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	@PreAuthorize("hasRole('ADMIN')")
	public ResponseEntity<Product> addProduct(@RequestBody Product product) {
		Product savedProduct = productService.addProduct(product);
		return ResponseEntity.status(HttpStatus.CREATED).body(savedProduct);
	}


	@PutMapping("/{id}")
	@PreAuthorize("hasRole('ADMIN')")
	public ResponseEntity<Product> editProduct(@PathVariable Long id, @RequestBody Product updatedProduct) {
		Product savedProduct = productService.editProduct(id, updatedProduct);
		return ResponseEntity.ok(savedProduct);
	}

	@DeleteMapping("/{id}")
	@PreAuthorize("hasRole('ADMIN')")
	public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
		productService.deleteProduct(id);
		return ResponseEntity.noContent().build();
	}

	@GetMapping("/low-stock")
	@PreAuthorize("hasRole('ADMIN')")
	public ResponseEntity<List<Product>> getLowStockProducts(@RequestParam(defaultValue = "5") int threshold) {
		List<Product> lowStockProducts = productService.getLowStockProducts(threshold);
		return ResponseEntity.ok(lowStockProducts);
	}
}
