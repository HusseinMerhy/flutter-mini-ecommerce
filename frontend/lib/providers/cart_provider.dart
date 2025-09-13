import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  final Map<int, Map<String, dynamic>> _items = {};
  String? _userId;

  Map<int, Map<String, dynamic>> get items => _items;

  int get itemCount => _items.length;

  int get totalQuantity {
    int total = 0;
    _items.forEach((key, product) {
      total += (product['quantity'] as int);
    });
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, product) {
      total += (product['price'] as num).toDouble() * (product['quantity'] as int);
    });
    return total;
  }

  void updateUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      _loadCartFromStorage();
    }
  }

  Future<void> _loadCartFromStorage() async {
    if (_userId == null) {
      _items.clear();
      notifyListeners();
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart_$_userId');
    if (cartData != null) {
      try {
        final decoded = (json.decode(cartData) as List).cast<Map<String, dynamic>>();
        _items.clear();
        for (var item in decoded) {
          _items[item['id'] as int] = item;
        }
        notifyListeners();
      } catch (e) {
        print('Error loading cart: $e');
        _items.clear();
      }
    }
  }

  Future<void> _saveCartToStorage() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(_items.values.toList());
    await prefs.setString('cart_$_userId', cartData);
  }

  void addItem(Map<String, dynamic> product) {
    final productId = product['id'] as int;
    final stock = int.tryParse(product['stock']?.toString() ?? '') ?? 0;

    if (stock <= 0) {
      return;
    }

    if (_items.containsKey(productId)) {
      if (_items[productId]!['quantity'] < stock) {
        _items[productId]!['quantity'] += 1;
      }
    } else {
      _items[productId] = {
        'id': product['id'],
        'name': product['name'],
        'price': (product['price'] as num).toDouble(),
        'quantity': 1,
        'imageUrl': product['imageUrl'] ?? product['image_url'] ?? "",
      };
    }

    notifyListeners();
    _saveCartToStorage();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
    _saveCartToStorage();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCartToStorage();
  }

  void decreaseQuantity(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!['quantity'] > 1) {
      _items[productId]!['quantity'] -= 1;
    } else {
      _items.remove(productId);
    }

    notifyListeners();
    _saveCartToStorage();
  }

  void updateQuantity(int productId, int quantity) {
    if (_items.containsKey(productId)) {
      _items[productId]!['quantity'] = quantity;
      notifyListeners();
      _saveCartToStorage();
    }
  }

  List<Map<String, dynamic>> getOrderItems() {
    return _items.values.map((item) {
      final productId = item['id'];
      if (productId == null) {
        print('WARNING: Item with null ID found in cart: $item');
      }

      return {
        'productId': productId, // This should match the backend expectation
        'quantity': item['quantity'],
      };
    }).toList();
  }
}
