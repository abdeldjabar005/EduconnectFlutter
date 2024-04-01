// post.dart
import 'package:equatable/equatable.dart';
import 'package:quotes/features/posts/data/models/comment_model.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';

class Post extends Equatable {
  final int id;
  final int userId;
  final int classOrSchoolId;
  final String text;
  final String type;
  final DateTime createdAt;
  final int commentsCount;
  final int likesCount;
  final bool isLiked;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final String classname;
  final bool isSaved;
  final List<String> content;

  const Post({
    required this.id,
    required this.userId,
    required this.classOrSchoolId,
    required this.text,
    required this.type,
    required this.createdAt,
    required this.commentsCount,
    required this.likesCount,
    required this.isLiked,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.classname,
    required this.isSaved,
    required this.content,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        classOrSchoolId,
        text,
        type,
        createdAt,
        commentsCount,
        likesCount,
        isLiked,
        firstName,
        lastName,
        profilePicture,
        classname,
        isSaved,
        content,
      ];
}
