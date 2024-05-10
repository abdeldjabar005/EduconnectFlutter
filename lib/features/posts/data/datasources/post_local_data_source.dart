// post_local_data_source.dart
import 'dart:convert';

import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getLastPosts();
  Future<void> cachePosts(List<PostModel> posts);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PostModel>> getLastPosts() {
    final jsonString = sharedPreferences.getString('cachedPosts');
    if (jsonString != null) {
      return Future.value(
          (json.decode(jsonString) as List).map((i) => PostModel.fromJson(i)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePosts(List<PostModel> posts) {
    return sharedPreferences.setString(
      'cachedPosts',
      json.encode(posts.map((post) => post.toJson()).toList()),
    );
  }
}