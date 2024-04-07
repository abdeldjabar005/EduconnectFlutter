// post_remote_data_source.dart
import 'dart:convert';

import 'package:quotes/core/api/api_consumer.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/features/posts/data/models/comment_model.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';
import 'package:quotes/features/posts/domain/entities/like.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts(int page);
  Future<List<CommentModel>> getComments(int postId);
  Future<CommentModel> getComment(int postId);
  Future<void> postComment(int postId, String comment);
  Future<void> postReply(int id, String reply);
  Future<PostModel> getPost(int id);
  Future<LikePostResponse> likePost(int id);
  Future<LikePostResponse> likeComment(int id);
  Future<LikePostResponse> likeReply(int postId);
  Future<LikePostResponse> checkIfPostIsLiked(int postId);
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

  @override
  Future<CommentModel> getComment(int postId) async {
    final response = await apiConsumer.get(
      EndPoints.comment(postId),
    );
    return CommentModel.fromJson(response['data']);
  }
  @override
  Future<void> postComment(int postId, String comment) async {
    await apiConsumer.post(
      EndPoints.postComment(postId),
      body: {
        'text': comment,
      },
    );
  }
  @override
  Future<void> postReply(int id, String reply) async {
    await apiConsumer.post(
      EndPoints.postReply(id),
      body: {
        'text': reply,
      },
    );
  }

  @override
  Future<PostModel> getPost(int id) async {
    final response = await apiConsumer.get(
      EndPoints.post(id),
    );
    return PostModel.fromJson(response['data']['data']);
  }

  @override
  Future<LikePostResponse> likePost(int id) async {
    final response = await apiConsumer.post(
      EndPoints.likePost(id),
    );

    if (response['statusCode'] == 200) {
      return LikePostResponse.fromJson(response['data']);
    } else {
      print('Unexpected response code: ${response.statusCode}');
      throw Exception('Unexpected response code: ${response.statusCode}');
    }
  }
  @override
  Future<LikePostResponse> likeComment(int id) async {
    final response = await apiConsumer.post(
      EndPoints.likeComment(id),
    );

    if (response['statusCode'] == 200) {
      return LikePostResponse.fromJson(response['data']);
    } else {
      throw Exception('Unexpected response code: ${response.statusCode}');
    }
  }

  @override
  Future<LikePostResponse> likeReply(int postId) async {
    final response = await apiConsumer.post(
      EndPoints.likeReply(postId),
    );

    if (response['statusCode'] == 200) {
      return LikePostResponse.fromJson(response['data']);
    } else {
      throw Exception('Unexpected response code: ${response.statusCode}');
    }
  }
  @override
  Future<LikePostResponse> checkIfPostIsLiked(int postId) async {
    final response = await apiConsumer.get(
      EndPoints.checkIfPostIsLiked(postId),
    );

    if (response['statusCode'] == 200) {
      // final body = json.decode(response['data']['data']);
      return LikePostResponse.fromJson(response['data']);
    } else {
      throw Exception('Unexpected response code: ${response.statusCode}');
    }
  }
}
