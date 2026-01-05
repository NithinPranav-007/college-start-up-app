import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../domain/entities/order_model.dart';
import '../../domain/repositories/order_repository.dart';

class DummyOrderRepository implements OrderRepository {
  DummyOrderRepository();

  final StreamController<List<OrderModel>> _controller =
      StreamController<List<OrderModel>>.broadcast();
  final List<OrderModel> _orders = <OrderModel>[];
  final Uuid _uuid = const Uuid();

  @override
  Stream<List<OrderModel>> watchOrders({required String userId}) {
    return _controller.stream.map((List<OrderModel> list) {
      return list
          .where((OrderModel order) =>
              order.clientId == userId || order.merchantId == userId)
          .toList();
    });
  }

  @override
  Future<void> placeOrder(OrderModel order) async {
    final OrderModel item = order.copyWith(
      id: order.id.isEmpty ? _uuid.v4() : order.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: OrderStatus.pending,
    );
    _orders.add(item);
    _controller.add(List<OrderModel>.unmodifiable(_orders));
  }

  @override
  Future<void> updateStatus(
      {required String orderId, required OrderStatus status}) async {
    final int index =
        _orders.indexWhere((OrderModel element) => element.id == orderId);
    if (index == -1) {
      return;
    }
    _orders[index] =
        _orders[index].copyWith(status: status, updatedAt: DateTime.now());
    _controller.add(List<OrderModel>.unmodifiable(_orders));
  }

  void dispose() {
    _controller.close();
  }
}
