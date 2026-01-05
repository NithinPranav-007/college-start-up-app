import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message_model.dart';
import '../../domain/repositories/chat_repository.dart';

class DummyChatRepository implements ChatRepository {
  DummyChatRepository();

  final Map<String, StreamController<List<ChatMessageModel>>> _rooms =
      <String, StreamController<List<ChatMessageModel>>>{};
  final Map<String, List<ChatMessageModel>> _messages =
      <String, List<ChatMessageModel>>{};
  final Uuid _uuid = const Uuid();

  @override
  Stream<List<ChatMessageModel>> watchRoom(String roomId) {
    final StreamController<List<ChatMessageModel>> controller =
        _rooms.putIfAbsent(
            roomId, () => StreamController<List<ChatMessageModel>>.broadcast());
    controller.add(List<ChatMessageModel>.unmodifiable(
        _messages[roomId] ?? <ChatMessageModel>[]));
    return controller.stream;
  }

  @override
  Future<void> sendMessage(ChatMessageModel message) async {
    final StreamController<List<ChatMessageModel>> controller =
        _rooms.putIfAbsent(message.roomId,
            () => StreamController<List<ChatMessageModel>>.broadcast());
    final List<ChatMessageModel> current = List<ChatMessageModel>.from(
        _messages[message.roomId] ?? <ChatMessageModel>[]);
    current.add(message.copyWith(
        id: message.id.isEmpty ? _uuid.v4() : message.id,
        sentAt: DateTime.now()));
    _messages[message.roomId] = current;
    controller.add(List<ChatMessageModel>.unmodifiable(current));
  }
}
