import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  static final RegExp _campusPattern = RegExp(r'@college\.edu$');

  @override
  Future<UserModel?> loginWithCampusEmail(
      {required String email, required String password}) async {
    if (!_campusPattern.hasMatch(email)) {
      throw const FormatException('Use your campus email');
    }
    final UserCredential credential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    final User? user = credential.user;
    if (user == null) {
      return null;
    }
    return UserModel(
      id: user.uid,
      name: user.displayName ?? 'Student',
      email: user.email ?? email,
      role: UserRole.client,
      isVerified: user.emailVerified,
    );
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> watchCurrentUser() {
    return _firebaseAuth.authStateChanges().map((User? user) {
      if (user == null) {
        return null;
      }
      return UserModel(
        id: user.uid,
        name: user.displayName ?? 'Student',
        email: user.email ?? '',
        role: UserRole.client,
        isVerified: user.emailVerified,
      );
    });
  }
}
