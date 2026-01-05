import '../entities/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> loginWithCampusEmail(
      {required String email, required String password});
  Future<void> logout();
  Stream<UserModel?> watchCurrentUser();
}
