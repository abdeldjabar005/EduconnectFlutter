// post_remote_data_source.dart
import 'package:quotes/core/api/api_consumer.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiConsumer apiConsumer;

  PostRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await apiConsumer.get(
      EndPoints.posts,
    );
  return (response['data']['data'] as List).map((i) => PostModel.fromJson(i)).toList();
  }
}