import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';
import 'package:educonnect/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required String id,
    required int fromId,
    required int toId,
    required String body,
    String? attachment,
    required bool seen,
    required DateTime createdAt,
    required DateTime updatedAt,
     ChatUser? user,
  }) : super(
          id: id,
          fromId: fromId,
          toId: toId,
          body: body,
          attachment: attachment,
          seen: seen,
          createdAt: createdAt,
          updatedAt: updatedAt,
          user: user,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      fromId: json['from_id'],
      toId: json['toId'],
      body: json['body'],
      attachment: json['attachment'],
      seen: json['seen'],
      user: ChatUser.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromId': fromId,
      'toId': toId,
      'body': body,
      'attachment': attachment,
      'seen': seen,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ChatMessage get toChatMessage {
    return ChatMessage(
      user: user!,
      text: body,
      status: seen ? MessageStatus.read : MessageStatus.sent,
      createdAt: createdAt,
    );
  }
}