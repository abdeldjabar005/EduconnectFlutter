import 'package:equatable/equatable.dart';

class Picture extends Equatable {
  final int id;
  final int postId;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;

  Picture({
    required this.id,
    required this.postId,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        url,
        createdAt,
        updatedAt,
      ];
}
