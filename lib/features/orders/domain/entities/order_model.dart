import 'package:equatable/equatable.dart';

enum OrderStatus { pending, accepted, completed, rejected }

class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.productId,
    required this.clientId,
    required this.merchantId,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String productId;
  final String clientId;
  final String merchantId;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      merchantId: json['merchantId'] as String? ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0,
      status: _statusFromString(json['status'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'clientId': clientId,
      'merchantId': merchantId,
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? productId,
    String? clientId,
    String? merchantId,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      clientId: clientId ?? this.clientId,
      merchantId: merchantId ?? this.merchantId,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static OrderStatus _statusFromString(String? value) {
    return OrderStatus.values.firstWhere(
        (OrderStatus status) => status.name == value,
        orElse: () => OrderStatus.pending);
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        productId,
        clientId,
        merchantId,
        total,
        status,
        createdAt,
        updatedAt
      ];
}
