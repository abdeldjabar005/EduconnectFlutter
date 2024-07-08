// post.dart
import 'package:equatable/equatable.dart';
import 'package:educonnect/features/posts/data/models/comment_model.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';

class Post extends Equatable {
  final int id;
  final int userId;
  final int classOrSchoolId;
  final String text;
  final String type;
  final DateTime createdAt;
  final int commentsCount;
  int likesCount;
  bool isLiked;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final String classname;
   bool isSaved;
  final  List<Map<String, dynamic>> content;

  Post({
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

  Post copyWith({
    int? id,
    int? userId,
    int? classOrSchoolId,
    String? text,
    String? type,
    DateTime? createdAt,
    int? commentsCount,
    int? likesCount,
    bool? isLiked,
    String? firstName,
    String? lastName,
    String? profilePicture,
    String? classname,
    bool? isSaved,
    List<Map<String,String>>? content,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      classOrSchoolId: classOrSchoolId ?? this.classOrSchoolId,
      text: text ?? this.text,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      classname: classname ?? this.classname,
      isSaved: isSaved ?? this.isSaved,
      content: content ?? this.content,
    );
  }
}
