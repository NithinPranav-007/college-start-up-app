import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../domain/entities/product_model.dart';
import '../../domain/repositories/product_repository.dart';

class DummyProductRepository implements ProductRepository {
  DummyProductRepository() {
    _seed();
  }

  final StreamController<List<ProductModel>> _controller =
      StreamController<List<ProductModel>>.broadcast();
  final List<ProductModel> _items = <ProductModel>[];
  final Uuid _uuid = const Uuid();

  void _seed() {
    final List<ProductModel> seedItems = <ProductModel>[
      ProductModel(
        id: _uuid.v4(),
        title: 'Laptop Repair',
        description: 'Fix hardware and software issues for students.',
        price: 49.0,
        category: 'Repair',
        merchantId: 'm1',
        rating: 4.7,
      ),
      ProductModel(
        id: _uuid.v4(),
        title: 'Figma UI Pack',
        description: 'Custom design templates for campus events.',
        price: 25.0,
        category: 'Design',
        merchantId: 'm2',
        rating: 4.4,
      ),
      ProductModel(
        id: _uuid.v4(),
        title: 'Math Tutoring',
        description: 'One-on-one calculus sessions.',
        price: 30.0,
        category: 'Tutoring',
        merchantId: 'm3',
        rating: 4.9,
      ),
    ];
    _items.addAll(seedItems);
    _controller.add(List<ProductModel>.unmodifiable(_items));
  }

  @override
  Stream<List<ProductModel>> watchMarketplace() => _controller.stream;

  @override
  Future<void> addProduct(ProductModel product) async {
    final ProductModel item =
        product.copyWith(id: product.id.isEmpty ? _uuid.v4() : product.id);
    _items.add(item);
    _controller.add(List<ProductModel>.unmodifiable(_items));
  }

  @override
  Future<void> deleteProduct(String id) async {
    _items.removeWhere((ProductModel product) => product.id == id);
    _controller.add(List<ProductModel>.unmodifiable(_items));
  }

  void dispose() {
    _controller.close();
  }
}
