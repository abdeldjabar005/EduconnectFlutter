import 'package:educonnect/features/posts/domain/entities/poll.dart';

class PollModel extends Poll {
  const PollModel({
    required int id,
    required int postId,
    required String question,
    required String options,
    required String results,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          postId: postId,
          question: question,
          options: options,
          results: results,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory PollModel.fromJson(Map<String, dynamic> json) => PollModel(
        id: json["id"],
        postId: json["post_id"],
        question: json["question"],
        options: json["options"],
        results: json["results"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "question": question,
        "options": options,
        "results": results,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}