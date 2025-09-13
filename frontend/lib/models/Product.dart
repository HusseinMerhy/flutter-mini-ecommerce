
class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: json['price'] is int
          ? (json['price'] as int).toDouble()
          : json['price'],
      stock: json['stock'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  bool get isOutOfStock => stock == 0;
  bool get isLowStock => stock > 0 && stock < 5;
}