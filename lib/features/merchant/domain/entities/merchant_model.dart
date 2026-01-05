import 'package:equatable/equatable.dart';

class MerchantModel extends Equatable {
  const MerchantModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.categories,
    this.rating = 0,
    this.earnings = 0,
    this.listingsCount = 0,
    this.avatarUrl,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final String bio;
  final List<String> categories;
  final double rating;
  final double earnings;
  final int listingsCount;
  final String? avatarUrl;
  final bool isVerified;

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      categories: (json['categories'] as List<dynamic>?)?.cast<String>() ??
          const <String>[],
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0,
      listingsCount: json['listingsCount'] as int? ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bio': bio,
      'categories': categories,
      'rating': rating,
      'earnings': earnings,
      'listingsCount': listingsCount,
      'avatarUrl': avatarUrl,
      'isVerified': isVerified,
    };
  }

  MerchantModel copyWith({
    String? id,
    String? name,
    String? bio,
    List<String>? categories,
    double? rating,
    double? earnings,
    int? listingsCount,
    String? avatarUrl,
    bool? isVerified,
  }) {
    return MerchantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      earnings: earnings ?? this.earnings,
      listingsCount: listingsCount ?? this.listingsCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        bio,
        categories,
        rating,
        earnings,
        listingsCount,
        avatarUrl,
        isVerified
      ];
}
