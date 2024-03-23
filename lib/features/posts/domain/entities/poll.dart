// poll.dart
import 'package:equatable/equatable.dart';

class Poll extends Equatable {
  final int id;
  final int postId;
  final String question;
  final String options;
  final String results;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Poll({
    required this.id,
    required this.postId,
    required this.question,
    required this.options,
    required this.results,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        question,
        options,
        results,
        createdAt,
        updatedAt,
      ];
}