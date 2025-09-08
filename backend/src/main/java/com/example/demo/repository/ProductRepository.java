package com.example.demo.repository;

import com.example.demo.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProductRepositpry extends JpaRepository <Product,Long >{
	Optional<Product> findByStockLessThan (int stock);
}
