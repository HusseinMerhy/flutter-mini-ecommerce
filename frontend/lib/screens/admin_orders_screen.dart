import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final ordersList = await ApiService.getAllOrders();
      if (!mounted) return;
      setState(() {
        orders = ordersList;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Failed to load orders: ${e.toString().replaceAll("Exception: ", "")}';
        isLoading = false;
      });
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown date';
    try {
      final parsed = DateTime.parse(date.toString());
      return '${parsed.day}/${parsed.month}/${parsed.year} ${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return date.toString();
    }
  }

  String _formatPrice(dynamic value) {
    if (value == null) return '0.00';
    if (value is num) return value.toStringAsFixed(2);
    final parsed = double.tryParse(value.toString());
    return parsed?.toStringAsFixed(2) ?? '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : RefreshIndicator(
        onRefresh: _loadOrders,
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final id = order['id'] ?? order['orderId'] ?? order['orderID'] ?? 'N/A';
            final total = order['totalAmount'] ?? order['total_amount'] ?? order['total'] ?? 0;
            final status = order['status'] ?? 'Unknown';
            final date = order['orderDate'] ?? order['order_date'] ?? order['date'] ?? order['createdDate'] ?? order['created_at'] ?? 'Unknown date';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('Order #$id'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: \$${_formatPrice(total)}'),
                    Text('Date: ${_formatDate(date)}'),
                    Text('Status: $status'),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                },
              ),
            );
          },
        ),
      ),
    );
  }
}