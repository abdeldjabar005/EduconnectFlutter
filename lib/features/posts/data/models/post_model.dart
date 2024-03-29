// post_model.dart
import 'package:quotes/features/posts/data/models/comment_model.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required int id,
    required int userId,
    required int classOrSchoolId,
    required String text,
    required String type,
    required DateTime createdAt,
    required int commentsCount,
    required int likesCount,
    required String firstName,
    required String lastName,
    required String profilePicture,
    required String classname,
    required bool isSaved,
    required List<String> content,
    
  }) : super(
          id: id,
          userId: userId,
          classOrSchoolId: classOrSchoolId,
          text: text,
          type: type,
          createdAt: createdAt,
          commentsCount: commentsCount,
          likesCount: likesCount,
          firstName: firstName,
          lastName: lastName,
          profilePicture: profilePicture,
          classname: classname,
          isSaved: isSaved,
          content: content,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<String> content = [];
    switch (json['type']) {
      case 'poll':
        content = (json['poll'] as List)
            .map((item) => item is Map ? item['url'] : null)
            .where((item) => item != null)
            .toList()
            .cast<String>();
        break;
      case 'picture':
        content = (json['pictures'] as List)
            .map((item) => item is Map ? item['url'] : null)
            .where((item) => item != null)
            .toList()
            .cast<String>();
        break;
      // Add other cases for 'video' and 'attachment'
    }
    return PostModel(
      id: json["id"],
      userId: json["user_id"],
      classOrSchoolId: json["class_or_school_id"],
      text: json["text"],
      type: json["type"],
      createdAt: DateTime.parse(json["created_at"]),
      commentsCount: json["comments_count"],
      likesCount: json["likes_count"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      profilePicture: json["profile_picture"]?.isNotEmpty == true
          ? json["profile_picture"]
          : 'assets/images/edu.png',

      classname: json["classname"],
      isSaved: json["isSaved"],
      content: content, 
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "class_or_school_id": classOrSchoolId,
        "text": text,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "comments_count": commentsCount,
        "likes_count": likesCount,
        "first_name": firstName,
        "last_name": lastName,
        "profile_picture": profilePicture,
        "classname": classname,
        "isSaved": isSaved,
        "content": content, // Add this line
      };
}
