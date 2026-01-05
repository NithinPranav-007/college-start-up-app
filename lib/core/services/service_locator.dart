import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/chat/data/repositories/dummy_chat_repository.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/marketplace/data/repositories/dummy_product_repository.dart';
import '../../features/marketplace/domain/repositories/product_repository.dart';
import '../../features/orders/data/repositories/dummy_order_repository.dart';
import '../../features/orders/domain/repositories/order_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupCoreServices() async {
  getIt
    ..registerLazySingleton<AuthRepository>(FirebaseAuthRepository.new)
    ..registerLazySingleton<ProductRepository>(DummyProductRepository.new)
    ..registerLazySingleton<OrderRepository>(DummyOrderRepository.new)
    ..registerLazySingleton<ChatRepository>(DummyChatRepository.new);
}

T sl<T extends Object>() => getIt<T>();
