import 'package:equatable/equatable.dart';

class Picture extends Equatable {
  final int id;
  final int postId;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;
  String? name;

  Picture({
    required this.id,
    required this.postId,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    this.name,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        url,
        createdAt,
        updatedAt,
        name,
      ];
}
