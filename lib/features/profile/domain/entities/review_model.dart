import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  const ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.targetMerchantId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String reviewerId;
  final String targetMerchantId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String? ?? '',
      reviewerId: json['reviewerId'] as String? ?? '',
      targetMerchantId: json['targetMerchantId'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'reviewerId': reviewerId,
      'targetMerchantId': targetMerchantId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      <Object?>[id, reviewerId, targetMerchantId, rating, comment, createdAt];
}
