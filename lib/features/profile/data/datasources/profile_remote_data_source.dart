import 'dart:developer';

import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';

abstract class ProfileRemoteDataSource {
  Future<List<ChildModel>> getChildren();
  Future<ChildModel> addChild(ChildModel child);
  Future<void> removeChild(int? id);
  Future<void> updateChild(ChildModel child);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProfileRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<ChildModel>> getChildren() async {
    final response = await apiConsumer.get(EndPoints.getChildren);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data']['data'] as List)
        .map((i) => ChildModel.fromJson(i))
        .toList();
  }

  @override
  Future<ChildModel> addChild(ChildModel child) async {
    final response =
        await apiConsumer.post(EndPoints.addChild, body: child.toJson());
    if (response['statusCode'] != 201) {
      throw ServerException();
    }
    return ChildModel.fromJson(response['data']);
  }

  @override
  Future<void> removeChild(int? id) async {
    final response = await apiConsumer.delete(EndPoints.removeChild(id));
    if (response['statusCode'] != 204) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateChild(ChildModel child) async {
    log(child.id.toString());
    log(child.toJson().toString());

    final response = await apiConsumer.put(EndPoints.updateChild(child.id),
        body: child.toJson());
    if (response['statusCode'] != 201) {
      throw ServerException();
    }
  }
}
