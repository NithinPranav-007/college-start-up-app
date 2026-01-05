import 'package:equatable/equatable.dart';

class ChatMessageModel extends Equatable {
  const ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.isMine = false,
  });

  final String id;
  final String roomId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isMine;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      roomId: json['roomId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      text: json['text'] as String? ?? '',
      sentAt:
          DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
      isMine: json['isMine'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
      'isMine': isMine,
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? text,
    DateTime? sentAt,
    bool? isMine,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      isMine: isMine ?? this.isMine,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[id, roomId, senderId, text, sentAt, isMine];
}
