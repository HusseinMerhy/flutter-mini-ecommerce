import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> product;
  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameC;
  late TextEditingController _priceC;
  late TextEditingController _stockC;
  late TextEditingController _imageC;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.product['name']?.toString() ?? '');
    _priceC = TextEditingController(text: widget.product['price']?.toString() ?? '');
    _stockC = TextEditingController(text: widget.product['stock']?.toString() ?? '');
    _imageC = TextEditingController(text: widget.product['imageUrl'] ?? widget.product['image_url'] ?? '');
  }

  @override
  void dispose() {
    _nameC.dispose();
    _priceC.dispose();
    _stockC.dispose();
    _imageC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final payload = {
      'name': _nameC.text.trim(),
      'price': double.tryParse(_priceC.text.trim()) ?? 0.0,
      'stock': int.tryParse(_stockC.text.trim()) ?? 0,
      'imageUrl': _imageC.text.trim().isEmpty ? null : _imageC.text.trim(),
    };

    try {
      final id = widget.product['id'] as int;
      await ApiService.updateProduct(id, payload);
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product updated'), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(controller: _nameC, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
            TextFormField(controller: _priceC, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number, validator: (v) => (v == null || double.tryParse(v) == null) ? 'Invalid price' : null),
            TextFormField(controller: _stockC, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number, validator: (v) => (v == null || int.tryParse(v) == null) ? 'Invalid stock' : null),
            TextFormField(controller: _imageC, decoration: const InputDecoration(labelText: 'Image URL (optional)')),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: _loading ? null : () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: _loading ? null : _save, child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save')),
      ],
    );
  }
}

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _priceC = TextEditingController();
  final _stockC = TextEditingController();
  final _imageC = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _priceC.dispose();
    _stockC.dispose();
    _imageC.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final payload = {
      'name': _nameC.text.trim(),
      'price': double.tryParse(_priceC.text.trim()) ?? 0.0,
      'stock': int.tryParse(_stockC.text.trim()) ?? 0,
      'imageUrl': _imageC.text.trim().isEmpty ? null : _imageC.text.trim(),
    };

    try {
      await ApiService.addProduct(payload);
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added'), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create failed: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(controller: _nameC, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
            TextFormField(controller: _priceC, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number, validator: (v) => (v == null || double.tryParse(v) == null) ? 'Invalid price' : null),
            TextFormField(controller: _stockC, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number, validator: (v) => (v == null || int.tryParse(v) == null) ? 'Invalid stock' : null),
            TextFormField(controller: _imageC, decoration: const InputDecoration(labelText: 'Image URL (optional)')),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: _loading ? null : () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: _loading ? null : _create, child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Create')),
      ],
    );
  }
}
