import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/order_model.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../../core/services/service_locator.dart';

final orderRepositoryProvider =
    Provider<OrderRepository>((ProviderRef<OrderRepository> ref) {
  return sl<OrderRepository>();
});

final ordersControllerProvider = StateNotifierProvider.family<OrdersController,
    AsyncValue<List<OrderModel>>, String>(
  (StateNotifierProviderRef<OrdersController, AsyncValue<List<OrderModel>>> ref,
      String userId) {
    final OrderRepository repository = ref.watch(orderRepositoryProvider);
    return OrdersController(repository: repository, userId: userId);
  },
);

class OrdersController extends StateNotifier<AsyncValue<List<OrderModel>>> {
  OrdersController(
      {required OrderRepository repository, required String userId})
      : _repository = repository,
        _userId = userId,
        super(const AsyncValue.loading()) {
    _subscribe();
  }

  final OrderRepository _repository;
  final String _userId;
  StreamSubscription<List<OrderModel>>? _subscription;

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _repository.watchOrders(userId: _userId).listen(
        (List<OrderModel> data) {
      state = AsyncValue.data(data);
    }, onError: (Object error, StackTrace stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    });
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await _repository.updateStatus(orderId: orderId, status: status);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
