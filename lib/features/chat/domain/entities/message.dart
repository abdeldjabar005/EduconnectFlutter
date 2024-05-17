import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String fromId;
  final String toId;
  final String body;
  final String? attachment;
  final bool seen;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.body,
    this.attachment,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, fromId, toId, body, attachment, seen, createdAt, updatedAt];
}