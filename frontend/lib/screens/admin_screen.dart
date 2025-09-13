import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'admin_products_screen.dart';
import 'admin_orders_screen.dart'; // Import the new screen

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  String? errorMessage;
  List<dynamic> lowStockProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Changed length to 3
    _loadLowStock(); // preload low-stock
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        _loadLowStock();
      }
    });
  }

  Future<void> _loadLowStock({int threshold = 5}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final list = await ApiService.getLowStockProducts(threshold: threshold);
      if (!mounted) return;
      setState(() {
        lowStockProducts = list;
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (!auth.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Panel')),
        body: const Center(child: Text('Access denied. Admin privileges required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.warning), text: 'Low Stock'),
            Tab(icon: Icon(Icons.inventory), text: 'Manage Products'),
            Tab(icon: Icon(Icons.list_alt), text: 'Orders'), // New tab
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_tabController.index == 0) {
                _loadLowStock();
              } else {
                // Refresh the current tab by rebuilding
                setState(() {});
              }
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLowStockTab(),
          const AdminProductsScreen(),
          const AdminOrdersScreen(), // New tab content
        ],
      ),
    );
  }

  Widget _buildLowStockTab() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadLowStock, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (lowStockProducts.isEmpty) {
      return const Center(child: Text('No low stock items'));
    }

    return RefreshIndicator(
      onRefresh: () => _loadLowStock(),
      child: ListView.builder(
        itemCount: lowStockProducts.length,
        itemBuilder: (context, index) {
          final p = lowStockProducts[index];
          final stock = p['stock'] ?? p['stock']?.toString() ?? 'N/A';
          final price = p['price'] ?? 0;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: (p['imageUrl'] ?? p['image_url'] ?? '').toString().isNotEmpty
                  ? Image.network(p['imageUrl'] ?? p['image_url'], width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag))
                  : const Icon(Icons.shopping_bag),
              title: Text(p['name'] ?? 'Unnamed'),
              subtitle: Text('Stock: $stock'),
              trailing: Text('\$${(price is num ? price.toStringAsFixed(2) : price.toString())}'),
            ),
          );
        },
      ),
    );
  }
}