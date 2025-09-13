import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> response = await ApiService.getProducts();
      _products = response.map((p) => Map<String, dynamic>.from(p)).toList();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load products';
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> search(String query) {
    query = query.toLowerCase();
    return _products.where((p) {
      final name = (p['name'] ?? '').toString().toLowerCase();
      final desc = (p['description'] ?? '').toString().toLowerCase();
      return name.contains(query) || desc.contains(query);
    }).toList();
  }
}
