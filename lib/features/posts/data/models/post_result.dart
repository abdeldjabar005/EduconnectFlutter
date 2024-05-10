import 'package:educonnect/features/posts/data/models/post_model.dart';

class PostsResult {
  final List<PostModel> data;
  final Meta meta;

  PostsResult({required this.data, required this.meta});
}

class Meta {
  final int currentPage;
  final int lastPage;

  Meta({required this.currentPage, required this.lastPage});
}