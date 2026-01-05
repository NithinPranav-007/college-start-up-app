import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../marketplace/domain/entities/product_model.dart';
import '../../../marketplace/presentation/controllers/marketplace_controller.dart';

class MerchantPanelScreen extends ConsumerStatefulWidget {
  const MerchantPanelScreen({super.key});

  @override
  ConsumerState<MerchantPanelScreen> createState() =>
      _MerchantPanelScreenState();
}

class _MerchantPanelScreenState extends ConsumerState<MerchantPanelScreen> {
  void _showAddProductDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'Repair';
    final categories = [
      'Repair',
      'Design',
      'Tutoring',
      'Books',
      'Electronics',
      'Services'
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text('Add New Product'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Product Title',
                    hintText: 'e.g., Laptop Repair Service',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe your product or service',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: '0.00',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: categories
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedCategory = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    descController.text.isEmpty ||
                    priceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                final userState = ref.read(authControllerProvider);
                final userId = userState.valueOrNull?.id ?? '';
                final newProduct = ProductModel(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  description: descController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  category: selectedCategory,
                  merchantId: userId,
                  rating: 0,
                );
                ref
                    .read(marketplaceControllerProvider.notifier)
                    .addProduct(newProduct);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Product added successfully!'),
                      ],
                    ),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(marketplaceControllerProvider);
    final products = productsState.valueOrNull ?? [];
    final userState = ref.watch(authControllerProvider);
    final userId = userState.valueOrNull?.id ?? '';
    final myProducts = products.where((p) => p.merchantId == userId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Panel'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Stats Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.inventory_2,
                  label: 'Listings',
                  value: '${myProducts.length}',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                _StatItem(
                  icon: Icons.attach_money,
                  label: 'Revenue',
                  value: '\$2.4k',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                _StatItem(
                  icon: Icons.star,
                  label: 'Rating',
                  value: '4.8',
                ),
              ],
            ),
          ),
          // Products List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Listings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddProductDialog,
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Add New'),
                ),
              ],
            ),
          ),
          Expanded(
            child: myProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.inventory_2,
                            size: 64,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No listings yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start selling by adding your first product',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _showAddProductDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Product'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: myProducts.length,
                    itemBuilder: (context, index) {
                      final product = myProducts[index];
                      return _ProductListItem(
                        product: product,
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: const Text('Delete Product'),
                              content: Text(
                                  'Are you sure you want to delete "${product.title}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(marketplaceControllerProvider
                                            .notifier)
                                        .delete(product.id);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Product deleted'),
                                        backgroundColor: AppTheme.errorColor,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.errorColor,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ProductListItem extends StatelessWidget {
  const _ProductListItem({
    required this.product,
    required this.onDelete,
  });

  final ProductModel product;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.shopping_bag, color: Colors.white, size: 28),
        ),
        title: Text(
          product.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.category,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.accentColor),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit feature coming soon!')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.errorColor),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
