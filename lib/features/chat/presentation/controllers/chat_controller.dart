import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/chat_message_model.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../../../core/services/service_locator.dart';

final chatRepositoryProvider =
    Provider<ChatRepository>((ProviderRef<ChatRepository> ref) {
  return sl<ChatRepository>();
});

final chatControllerProvider = StateNotifierProvider.family<ChatController,
    AsyncValue<List<ChatMessageModel>>, String>(
  (StateNotifierProviderRef<ChatController, AsyncValue<List<ChatMessageModel>>>
          ref,
      String roomId) {
    final ChatRepository repository = ref.watch(chatRepositoryProvider);
    return ChatController(repository: repository, roomId: roomId);
  },
);

class ChatController extends StateNotifier<AsyncValue<List<ChatMessageModel>>> {
  ChatController({required ChatRepository repository, required this.roomId})
      : _repository = repository,
        super(const AsyncValue.loading()) {
    _subscribe();
  }

  final ChatRepository _repository;
  final String roomId;
  StreamSubscription<List<ChatMessageModel>>? _subscription;

  void _subscribe() {
    _subscription?.cancel();
    _subscription =
        _repository.watchRoom(roomId).listen((List<ChatMessageModel> data) {
      state = AsyncValue.data(data);
    }, onError: (Object error, StackTrace stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    });
  }

  Future<void> send(ChatMessageModel message) async {
    await _repository.sendMessage(message);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
