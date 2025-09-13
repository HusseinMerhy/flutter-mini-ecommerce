import 'package:flutter/foundation.dart';

class Cart {
  Cart._internal();
  static final Cart instance = Cart._internal();
  final ValueNotifier<List<Map<String, dynamic>>> items = ValueNotifier([]);

  void addItem(Map<String, dynamic> product) {
    final current = List<Map<String, dynamic>>.from(items.value);
    final id = product['id'];
    final idx = current.indexWhere((e) => e['id'] == id);

    if (idx >= 0) {
      final item = Map<String, dynamic>.from(current[idx]);
      final int qty = (item['quantity'] as int?) ?? 1;
      item['quantity'] = qty + 1;
      current[idx] = item;
    } else {
      final newItem = Map<String, dynamic>.from(product);
      newItem['quantity'] = 1;
      current.add(newItem);
    }

    items.value = current;
  }

  void updateQuantity(dynamic id, int newQty) {
    final current = List<Map<String, dynamic>>.from(items.value);
    final idx = current.indexWhere((e) => e['id'] == id);
    if (idx >= 0) {
      if (newQty <= 0) {
        current.removeAt(idx);
      } else {
        final item = Map<String, dynamic>.from(current[idx]);
        item['quantity'] = newQty;
        current[idx] = item;
      }
      items.value = current;
    }
  }

  void removeById(dynamic id) {
    final current = List<Map<String, dynamic>>.from(items.value);
    current.removeWhere((e) => e['id'] == id);
    items.value = current;
  }

  void clear() {
    items.value = [];
  }

  double subtotal() {
    double sum = 0;
    for (final i in items.value) {
      final price = (i['price'] is num) ? (i['price'] as num).toDouble() : double.tryParse('${i['price']}') ?? 0.0;
      final qty = (i['quantity'] as int?) ?? 0;
      sum += price * qty;
    }
    return sum;
  }

  int totalItems() {
    return items.value.fold<int>(0, (s, i) => s + ((i['quantity'] as int?) ?? 0));
  }
}
