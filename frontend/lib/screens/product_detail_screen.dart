import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final cart = Provider.of<CartProvider>(context, listen: false);

    final stock = int.tryParse(product['stock']?.toString() ?? '') ?? 0;
    final isOutOfStock = stock <= 0;
    final imageUrl = (product['imageUrl'] ?? product['image_url'] ?? '') as String;
    final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(product['name'] ?? 'Product Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              color: Colors.grey.shade100,
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag, size: 100))
                  : const Icon(Icons.shopping_bag, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product['name'] ?? 'Unnamed Product', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('\$${price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(children: [
                  Icon(Icons.inventory_2, color: isOutOfStock ? Colors.red : Colors.green),
                  const SizedBox(width: 8),
                  Text(isOutOfStock ? 'Out of stock' : 'In stock ($stock available)', style: TextStyle(color: isOutOfStock ? Colors.red : Colors.green)),
                ]),
                const SizedBox(height: 16),
                if (product['description'] != null) ...[
                  Text('Description', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product['description'] ?? ''),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isOutOfStock
                        ? null
                        : () {
                      cart.addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${product['name']} to cart'), backgroundColor: Colors.green));
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(isOutOfStock ? 'Out of Stock' : 'Add to Cart'),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
