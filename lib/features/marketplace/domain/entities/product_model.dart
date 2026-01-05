import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.merchantId,
    this.images = const <String>[],
    this.isAvailable = true,
    this.rating = 0,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String merchantId;
  final List<String> images;
  final bool isAvailable;
  final double rating;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String? ?? '',
      merchantId: json['merchantId'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)?.cast<String>() ??
          const <String>[],
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'merchantId': merchantId,
      'images': images,
      'isAvailable': isAvailable,
      'rating': rating,
    };
  }

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? merchantId,
    List<String>? images,
    bool? isAvailable,
    double? rating,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      merchantId: merchantId ?? this.merchantId,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        description,
        price,
        category,
        merchantId,
        images,
        isAvailable,
        rating
      ];
}
