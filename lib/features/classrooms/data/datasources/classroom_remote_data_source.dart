// classroom_remote_data_source.dart

import 'package:quotes/core/api/api_consumer.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';

abstract class ClassroomRemoteDataSource {
  Future<List<PostModel>> getPosts(int id, int page, String type);
  Future<ClassModel> joinClass(String code);
  Future<SchoolModel> joinSchool(String code);
}

class ClassroomRemoteDataSourceImpl implements ClassroomRemoteDataSource {
  final ApiConsumer apiConsumer;

  ClassroomRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<PostModel>> getPosts(int id, int page, String type) async {
    if (type == "school") {
      final response = await apiConsumer.get(
        "${EndPoints.getSchool(id)}?page=$page",
      );
      return (response['data']['data'] as List)
          .map((i) => PostModel.fromJson(i))
          .toList();
    } else {
      final response = await apiConsumer.get(
        "${EndPoints.getClass(id)}?page=$page",
      );
      return (response['data']['data'] as List)
          .map((i) => PostModel.fromJson(i))
          .toList();
    }
  }

  @override
  Future<ClassModel> joinClass(String code) async {
    final response = await apiConsumer.post(
      EndPoints.joinClass,
      body: {
        'code': code,
      },
    );

    if (response['statusCode'] == 200) {
      return ClassModel.fromJson(response['data']);
    } else if (response['statusCode'] == 409) {
      throw const JoinedException();
    } else if (response['statusCode'] == 404) {
      throw const InvalidCodeException();
    } else {
      print(response);
      throw ServerException();
    }
  }

  @override
  Future<SchoolModel> joinSchool(String code) async {
    final response = await apiConsumer.post(
      EndPoints.joinSchool,
      body: {
        'code': code,
      },
    );
    if (response['statusCode'] == 200) {
      return SchoolModel.fromJson(response['data']);
    } else if (response['statusCode'] == 409) {
      throw const JoinedException();
    } else if (response['statusCode'] == 404) {
      throw const InvalidCodeException();
    } else {
      print(response);
      throw ServerException();
    }
  }
}
