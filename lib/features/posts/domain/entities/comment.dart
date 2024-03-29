// core/entities/comment.dart
import 'package:equatable/equatable.dart';
import 'package:quotes/features/posts/data/models/comment_model.dart';

class Comment extends Equatable {
  final int id;
  final int postId;
  final int userId;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int repliesCount;
  final List<CommentModel> replies;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.repliesCount,
    required this.replies,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [id, postId, userId, text, createdAt, updatedAt, likesCount, repliesCount, replies, firstName, lastName, profilePicture];
}