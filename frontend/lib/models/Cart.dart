package models;

class Cart {
    static final Cart _instance = Cart._internal();
    factory Cart() => _instance;
  Cart._internal();

    final List<Map<String, dynamic>> items = [];

    void addItem(Map<String, dynamic> product) {
        final index = items.indexWhere((e) => e['id'] == product['id']);
        if (index >= 0) {
            items[index]['quantity'] += 1;
        } else {
            final newItem = Map<String, dynamic>.from(product);
            newItem['quantity'] = 1;
            items.add(newItem);
        }
    }

    void removeItem(Map<String, dynamic> product) {
        items.removeWhere((e) => e['id'] == product['id']);
    }

    void clear() => items.clear();
}
