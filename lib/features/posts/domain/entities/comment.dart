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
  int repliesCount;
  final List<CommentModel> replies;
  final bool isLiked;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.repliesCount,
    required this.replies,
    required this.isLiked,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        userId,
        text,
        createdAt,
        updatedAt,
        likesCount,
        repliesCount,
        replies,
        isLiked,
        firstName,
        lastName,
        profilePicture
      ];

  CommentModel copyWith({
    int? id,
    int? postId,
    int? userId,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? repliesCount,
    List<CommentModel>? replies,
    bool? isLiked,
    String? firstName,
    String? lastName,
    String? profilePicture,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      repliesCount: repliesCount ?? this.repliesCount,
      replies: replies ?? this.replies,
      isLiked: isLiked ?? this.isLiked,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
