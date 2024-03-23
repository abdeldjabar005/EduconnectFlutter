import 'package:quotes/features/posts/domain/entities/picture.dart';

class PictureModel extends Picture {
  PictureModel({
    required int id,
    required int postId,
    required String url,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          postId: postId,
          url: url,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
        id: json["id"],
        postId: json["post_id"],
        url: json["url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "url": url,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}