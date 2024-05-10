// comment_model.dart
import 'package:educonnect/features/posts/domain/entities/comment.dart';

class CommentModel extends Comment {
   CommentModel({
    required int id,
    required int postId,
    required int userId,
    required String text,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int likesCount,
    required int repliesCount,
    required List<CommentModel> replies,
    required bool isLiked,
    required String firstName,
    required String lastName,
    String? profilePicture,
  }) : super(
          id: id,
          postId: postId,
          userId: userId,
          text: text,
          createdAt: createdAt,
          updatedAt: updatedAt,
          likesCount: likesCount,
          repliesCount: repliesCount,
          replies: replies,
          isLiked: isLiked,
          firstName: firstName,
          lastName: lastName,
          profilePicture: profilePicture,
        );

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json["id"],
      postId: json["post_id"] ?? json["comment_id"],
      userId: json["user_id"],
      text: json["text"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      likesCount: json["likes_count"],
      repliesCount: json["replies_count"] ?? 0,
      replies: (json["replies"] as List?)
              ?.map((item) => CommentModel.fromJson(item))
              .toList() ??
          [],
      isLiked: json["isLiked"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      profilePicture: json["profile_picture"]?.isNotEmpty == true
          ? json["profile_picture"]
          : 'assets/images/edu.png',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "user_id": userId,
        "text": text,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "likes_count": likesCount,
        "replies_count": repliesCount,
        "replies": replies.map((item) => item.toJson()).toList(),
        "isLiked": isLiked,
        "first_name": firstName,
        "last_name": lastName,
        "profile_picture": profilePicture,
      };
}
