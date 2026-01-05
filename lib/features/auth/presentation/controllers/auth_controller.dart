import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/service_locator.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ProviderRef<AuthRepository> ref) {
  return sl<AuthRepository>();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>(
        (StateNotifierProviderRef<AuthController, AsyncValue<UserModel?>> ref) {
  final AuthRepository repository = ref.watch(authRepositoryProvider);
  return AuthController(repository: repository);
});

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  AuthController({required AuthRepository repository})
      : _repository = repository,
        super(const AsyncValue.loading()) {
    _listenToUser();
  }

  final AuthRepository _repository;
  StreamSubscription<UserModel?>? _subscription;

  void _listenToUser() {
    _subscription?.cancel();
    _subscription = _repository.watchCurrentUser().listen((UserModel? user) {
      state = AsyncValue.data(user);
    }, onError: (Object error, StackTrace stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    });
  }

  Future<void> login(String email, String password, UserRole role) async {
    state = const AsyncValue.loading();
    try {
      final UserModel? user = await _repository.loginWithCampusEmail(
          email: email, password: password);
      state = AsyncValue.data(user?.copyWith(role: role));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
