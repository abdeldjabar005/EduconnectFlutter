// post_remote_data_source.dart
import 'package:quotes/core/api/api_consumer.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/features/posts/data/models/comment_model.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts(int page);
  Future<List<CommentModel>> getComments(int postId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiConsumer apiConsumer;

  PostRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<PostModel>> getPosts(int page) async {
    final response = await apiConsumer.get(
      "${EndPoints.posts}?page=$page",
    );
    return (response['data']['data'] as List)
        .map((i) => PostModel.fromJson(i))
        .toList();
  }

  @override
  Future<List<CommentModel>> getComments(int postId) async {
    final response = await apiConsumer.get(
      EndPoints.comments(postId),
    );
    return (response['data']['data'] as List)
        .map((i) => CommentModel.fromJson(i))
        .toList();
  }
}
