// post_model.dart
import 'package:educonnect/features/posts/data/models/comment_model.dart';
import 'package:educonnect/features/posts/domain/entities/post.dart';

class PostModel extends Post {
  PostModel({
    required int id,
    required int userId,
    required int classOrSchoolId,
    required String text,
    required String type,
    required DateTime createdAt,
    required int commentsCount,
    required int likesCount,
    required bool isLiked,
    required String firstName,
    required String lastName,
    required String profilePicture,
    required String classname,
    required bool isSaved,
    required List<Map<String, dynamic>> content,
  }) : super(
          id: id,
          userId: userId,
          classOrSchoolId: classOrSchoolId,
          text: text,
          type: type,
          createdAt: createdAt,
          commentsCount: commentsCount,
          likesCount: likesCount,
          isLiked: isLiked,
          firstName: firstName,
          lastName: lastName,
          profilePicture: profilePicture,
          classname: classname,
          isSaved: isSaved,
          content: content,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    int classOrSchoolId;
    if (json['class_or_school_id'] is String) {
      classOrSchoolId = int.parse(json['class_or_school_id']);
    } else {
      classOrSchoolId = json['class_or_school_id'];
    }
    List<Map<String, dynamic>> content = [];
    switch (json['type']) {
      case 'poll':
        content = (json['poll'] as List)
            .map((item) => item is Map
                ? {
                    'url': item['url'].toString(),
                    'name': item['name'].toString()
                  }
                : null)
            .where((item) => item != null)
            .toList()
            .cast<Map<String, dynamic>>();
        break;
      case 'picture':
        content = (json['pictures'] as List)
            .map((item) => item is Map
                ? {
                    'url': item['url'].toString(),
                    'name': item['name'].toString()
                  }
                : null)
            .where((item) => item != null)
            .toList()
            .cast<Map<String, dynamic>>();
        break;
      case 'video':
        content = (json['video'] as List)
            .map((item) => item is Map
                ? {
                    'url': item['url'].toString(),
                    'name': item['name'].toString()
                  }
                : null)
            .where((item) => item != null)
            .toList()
            .cast<Map<String, dynamic>>();
        break;
      case 'attachment':
        content = (json['attachment'] as List)
            .map((item) => item is Map
                ? {
                    'url': item['url'].toString(),
                    'name': item['name'].toString()
                  }
                : null)
            .where((item) => item != null)
            .toList()
            .cast<Map<String, dynamic>>();
        break;
    }

    return PostModel(
      id: json["id"],
      userId: json["user_id"],
      classOrSchoolId: classOrSchoolId,
      text: json["text"],
      type: json["type"],
      createdAt: DateTime.parse(json["created_at"]),
      commentsCount: json["comments_count"],
      likesCount: json["likes_count"],
      isLiked: json["isLiked"],
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

  PostModel copyWith({
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
    List<Map<String, String>>? content,
  }) {
    return PostModel(
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "class_or_school_id": classOrSchoolId,
        "text": text,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "comments_count": commentsCount,
        "likes_count": likesCount,
        "isLiked": isLiked,
        "first_name": firstName,
        "last_name": lastName,
        "profile_picture": profilePicture,
        "classname": classname,
        "isSaved": isSaved,
        "content": content,
      };
}
