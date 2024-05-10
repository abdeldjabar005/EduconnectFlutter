import 'package:equatable/equatable.dart';

class PostM extends Equatable {
  final int? id;
  final int? userId;
  final int? classOrSchoolId;
  final String text;
  final String type;
  final DateTime? createdAt;
  final int? commentsCount;
  final int? likesCount;
  final bool? isLiked;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final String? classname;
  final bool? isSaved;
  final List<Map<String, dynamic>>? content;

  const PostM({
    this.id,
    this.userId,
    this.classOrSchoolId,
    required this.text,
    required this.type,
    this.createdAt,
    this.commentsCount,
    this.likesCount,
    this.isLiked,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.classname,
    this.isSaved,
    this.content,
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

  PostM copyWith({
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
    return PostM(
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

  factory PostM.fromJson(Map<String, dynamic> json) {
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

    return PostM(
      id: json["id"],
      userId: json["user_id"],
      classOrSchoolId: json["class_or_school_id"],
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "class_id": classOrSchoolId,
        "text": text,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
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
  Map<String, dynamic> toJson2() => {
        "id": id,
        "user_id": userId,
        "school_id": classOrSchoolId,
        "text": text,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
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
