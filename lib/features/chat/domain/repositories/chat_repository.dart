import '../entities/chat_message_model.dart';

abstract class ChatRepository {
  Stream<List<ChatMessageModel>> watchRoom(String roomId);
  Future<void> sendMessage(ChatMessageModel message);
}
