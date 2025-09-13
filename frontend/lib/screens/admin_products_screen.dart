import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'admin_product_dialogs.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;
  Set<int> _deletingIds = {}; // Track which products are being deleted

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final list = await ApiService.getProducts();
      if (!mounted) return;
      setState(() {
        products = list;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> _confirmDelete(int id, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm delete'),
        content: Text('Delete product "$name"? This will keep historical orders intact.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')
          ),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
    if (ok == true) {
      await _deleteProduct(id);
    }
  }

  Future<void> _deleteProduct(int id) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Double-check admin status before proceeding
    if (!auth.isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin privileges required to delete products'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _deletingIds.add(id);
    });

    try {
      await ApiService.deleteProduct(id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Remove the deleted product from the local list
      setState(() {
        products.removeWhere((p) => p['id'] == id);
        _deletingIds.remove(id);
      });
    } catch (e) {
      if (!mounted) return;

      final errorMsg = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete: $errorMsg'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        _deletingIds.remove(id);
      });
    }
  }

  Future<void> _openEditDialog(Map<String, dynamic> product) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => EditProductDialog(product: Map<String, dynamic>.from(product)),
    );
    if (changed == true) _loadProducts();
  }

  Future<void> _openAddDialog() async {
    final added = await showDialog<bool>(
        context: context,
        builder: (_) => const AddProductDialog()
    );
    if (added == true) _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Manage Products')),
        body: const Center(child: Text('Admin access required')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: _openAddDialog,
              tooltip: 'Add product'
          ),
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadProducts,
              tooltip: 'Refresh'
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : products.isEmpty
          ? const Center(child: Text('No products'))
          : RefreshIndicator(
        onRefresh: _loadProducts,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, idx) {
            final p = products[idx];
            final id = p['id'] ?? p['productId'];
            final stock = p['stock'] ?? 0;
            final price = p['price'] ?? 0;
            final isDeleting = _deletingIds.contains(id);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                leading: (p['imageUrl'] ?? p['image_url'] ?? '').toString().isNotEmpty
                    ? Image.network(
                    p['imageUrl'] ?? p['image_url'],
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag)
                )
                    : const Icon(Icons.shopping_bag),
                title: Text(p['name'] ?? 'Unnamed'),
                subtitle: Text('Stock: $stock'),
                trailing: isDeleting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openEditDialog(p)
                    ),
                    IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(id as int, p['name'] ?? '')
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}