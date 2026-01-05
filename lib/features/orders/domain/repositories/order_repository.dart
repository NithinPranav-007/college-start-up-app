import '../entities/order_model.dart';

abstract class OrderRepository {
  Stream<List<OrderModel>> watchOrders({required String userId});
  Future<void> placeOrder(OrderModel order);
  Future<void> updateStatus(
      {required String orderId, required OrderStatus status});
}
