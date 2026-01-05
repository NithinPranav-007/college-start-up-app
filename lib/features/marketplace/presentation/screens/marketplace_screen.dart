import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/product_model.dart';
import '../controllers/marketplace_controller.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Repair',
    'Design',
    'Tutoring',
    'Books',
    'Electronics',
    'Services'
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search products & services...',
                      prefixIcon: const Icon(Icons.search,
                          color: AppTheme.primaryColor),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () =>
                                  setState(() => _searchQuery = ''),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(category),
                          onSelected: (selected) {
                            setState(() => _selectedCategory = category);
                          },
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Products Grid
          Expanded(
            child: AsyncValueWidget<List<ProductModel>>(
              value: state,
              builder: (List<ProductModel> items) {
                // Apply filters
                var filteredItems = items.where((item) {
                  final matchesSearch = item.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      item.description
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                  final matchesCategory = _selectedCategory == 'All' ||
                      item.category == _selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredItems.isEmpty) {
                  return Center(
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
                            Icons.search_off,
                            size: 64,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ProductModel product = filteredItems[index];
                    return _ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

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
      case 'services':
        return Icons.handyman;
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

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(product.category);

    return GestureDetector(
      onTap: () => context.go('/product', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image Placeholder with Icon
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withOpacity(0.8),
                      categoryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(product.category),
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  if (product.rating > 0)
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: AppTheme.warningColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Price
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
