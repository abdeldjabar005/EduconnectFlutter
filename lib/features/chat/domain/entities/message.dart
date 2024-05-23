import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final int fromId;
  final int toId;
  final String body;
  final String? attachment;
  final bool seen;
  final DateTime createdAt;
  final DateTime updatedAt;
  ChatUser? user;

  Message({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.body,
    this.attachment,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  @override
  List<Object?> get props =>
      [id, fromId, toId, body, attachment, seen, createdAt, updatedAt];
}
