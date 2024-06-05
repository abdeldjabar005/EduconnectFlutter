import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/utils/logger.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';
import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/data/models/profile_model.dart';
import 'package:educonnect/injection_container.dart';

abstract class ProfileRemoteDataSource {
  Future<List<ChildModel>> getChildren();
  Future<ChildModel> addChild(ChildModel child);
  Future<void> removeChild(int? id);
  Future<void> updateChild(ChildModel child);
  Future<void> updateProfile(ProfileModel user, File? image);
  Future<void> changePassword(
      String oldpassword, String password, String confirmPassword);
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

  @override
  Future<void> updateProfile(ProfileModel user, File? image) async {
    FormData formData;
    final authCubit = sl<AuthCubit>();
    if (image != null) {
      vLog(image.path);
      String fileName = image.path.split('/').last;
      formData = FormData.fromMap({
        ...user.toJson(),
        "_method": "PUT",
        "profile_picture":
            await MultipartFile.fromFile(image.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        ...user.toJson(),
        "_method": "PUT",
      });
    }
    vLog(formData.fields.toString());

    final response = await apiConsumer.post2(
      EndPoints.updateProfile,
      body: formData,
    );
    if (response != null && response['statusCode'] == 201) {
      if (response['data'] != null) {
        String newProfilePictureUrl = response['data']['profile_picture'];

        authCubit.updateUserProfilePicture(newProfilePictureUrl);
      } else {
        throw Exception('Data is null');
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> changePassword(
      String oldpassword, String password, String confirmPassword) async {
    final response = await apiConsumer.post(EndPoints.changePassword, body: {
      'old_password': oldpassword,
      'new_password': password,
      'new_password_confirmation': confirmPassword
    });
    if (response['statusCode'] == 400) {
      throw OldPasswordWrongException();
    }
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
  }
}
