import 'package:quotes/core/api/api_consumer.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';

abstract class ProfileRemoteDataSource {
  Future<List<ChildModel>> getChildren();
  Future<void> addChild(ChildModel child);
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
  Future<void> addChild(ChildModel child) async {
    final response = await apiConsumer.post(EndPoints.addChild, body :child.toJson());
    if (response['statusCode'] != 201) {
      throw ServerException();
    }
  }
}
