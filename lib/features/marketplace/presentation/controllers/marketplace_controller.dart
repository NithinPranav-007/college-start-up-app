import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../../core/services/service_locator.dart';

final productRepositoryProvider =
    Provider<ProductRepository>((ProviderRef<ProductRepository> ref) {
  return sl<ProductRepository>();
});

final marketplaceControllerProvider = StateNotifierProvider<
    MarketplaceController, AsyncValue<List<ProductModel>>>(
  (StateNotifierProviderRef<MarketplaceController,
          AsyncValue<List<ProductModel>>>
      ref) {
    final ProductRepository repository = ref.watch(productRepositoryProvider);
    return MarketplaceController(repository);
  },
);

class MarketplaceController
    extends StateNotifier<AsyncValue<List<ProductModel>>> {
  MarketplaceController(this._repository) : super(const AsyncValue.loading()) {
    _subscribe();
  }

  final ProductRepository _repository;
  StreamSubscription<List<ProductModel>>? _subscription;

  void _subscribe() {
    _subscription?.cancel();
    _subscription =
        _repository.watchMarketplace().listen((List<ProductModel> data) {
      state = AsyncValue.data(data);
    }, onError: (Object error, StackTrace stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    });
  }

  Future<void> delete(String id) async {
    await _repository.deleteProduct(id);
  }

  Future<void> addProduct(ProductModel product) async {
    await _repository.addProduct(product);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
