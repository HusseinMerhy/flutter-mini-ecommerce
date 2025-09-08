package com.example.demo.service;

import com.example.demo.model.Product;
import com.example.demo.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
@Service
public class ProductService {

	@Autowired
	private ProductRepository productRepository;

	// FIXED: Changed from getCatalog() to getAllProducts()
	public List<Product> getAllProducts() {
		return productRepository.findAll();
	}

	public Product addProduct(Product product) {
		return productRepository.save(product);
	}

	public List<Product> getLowStockProducts(int threshold) {
		return productRepository.findByStockLessThan(threshold);
	}

	public Optional<Product> getProductById(Long id) {
		return productRepository.findById(id);
	}
	public Product editProduct(Long id, Product updatedProduct) {
		return productRepository.findById(id)
				.map(existingProduct -> {
					existingProduct.setName(updatedProduct.getName());
					existingProduct.setPrice(updatedProduct.getPrice());
					existingProduct.setStock(updatedProduct.getStock());
					return productRepository.save(existingProduct);
				})
				.orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
	}
	public void deleteProduct(Long id) {
		if (!productRepository.existsById(id)) {
			throw new RuntimeException("Product not found with id: " + id);
		}
		productRepository.deleteById(id);
	}

}