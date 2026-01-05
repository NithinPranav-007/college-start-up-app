import 'package:equatable/equatable.dart';

enum UserRole { client, merchant }

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? photoUrl;
  final bool isVerified;

  factory UserModel.empty() => const UserModel(
        id: '',
        name: 'Student',
        email: '',
        role: UserRole.client,
        isVerified: false,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: _roleFromString(json['role'] as String?),
      photoUrl: json['photoUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'photoUrl': photoUrl,
      'isVerified': isVerified,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? photoUrl,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  static UserRole _roleFromString(String? value) {
    if (value == UserRole.merchant.name) {
      return UserRole.merchant;
    }
    return UserRole.client;
  }

  @override
  List<Object?> get props =>
      <Object?>[id, name, email, role, photoUrl, isVerified];
}
