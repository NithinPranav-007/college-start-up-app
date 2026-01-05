import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product_model.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'repair':
        return Icons.build;
      case 'design':
        return Icons.palette;
      case 'tutoring':
        return Icons.school;
      case 'books':
        return Icons.menu_book;
      case 'electronics':
        return Icons.devices;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'repair':
        return const Color(0xFFFF6584);
      case 'design':
        return const Color(0xFF9D8FF6);
      case 'tutoring':
        return const Color(0xFF4ECDC4);
      case 'books':
        return const Color(0xFFFFAB00);
      case 'electronics':
        return const Color(0xFF6C63FF);
      default:
        return AppTheme.primaryColor;
    }
  }

  void _handleBuyNow(BuildContext context, WidgetRef ref) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: AppTheme.successColor, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Confirm Purchase'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to purchase:',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(product.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppTheme.accentColor, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'The merchant will be notified and contact you soon.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to orders screen
              context.go('/orders');
              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Order placed successfully!'),
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
            child: const Text('Confirm Purchase'),
          ),
        ],
      ),
    );
  }

  void _handleContactMerchant(BuildContext context) {
    context.go('/chat');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Chat with merchant started'),
        backgroundColor: AppTheme.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryColor = _getCategoryColor(product.category);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withOpacity(0.8),
                      categoryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(product.category),
                    size: 120,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: categoryColor, width: 1.5),
                          ),
                          child: Text(
                            product.category.toUpperCase(),
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Rating and Reviews
                        Row(
                          children: [
                            if (product.rating > 0) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.warningColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: AppTheme.warningColor, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '(24 reviews)',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Price Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Merchant Info
                        Container(
                          padding: const EdgeInsets.all(16),
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
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppTheme.primaryColor,
                                child: const Icon(Icons.store,
                                    color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Campus Merchant',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Verified Seller',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.verified,
                                  color: AppTheme.successColor, size: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Features
                        const Text(
                          'What\'s Included',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _FeatureItem(
                            icon: Icons.check_circle,
                            text: 'Campus-verified service'),
                        _FeatureItem(
                            icon: Icons.check_circle, text: 'Fast delivery'),
                        _FeatureItem(
                            icon: Icons.check_circle,
                            text: 'Secure transaction'),
                        _FeatureItem(
                            icon: Icons.check_circle,
                            text: '24/7 customer support'),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Contact Button
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => _handleContactMerchant(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(
                        color: AppTheme.primaryColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Icon(Icons.chat_bubble_outline,
                      color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(width: 12),
              // Buy Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _handleBuyNow(context, ref),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.successColor, size: 22),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
