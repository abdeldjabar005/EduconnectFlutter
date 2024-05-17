import 'package:educonnect/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required String id,
    required String fromId,
    required String toId,
    required String body,
    String? attachment,
    required bool seen,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          fromId: fromId,
          toId: toId,
          body: body,
          attachment: attachment,
          seen: seen,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      fromId: json['fromId'],
      toId: json['toId'],
      body: json['body'],
      attachment: json['attachment'],
      seen: json['seen'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
}