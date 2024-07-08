// classroom_remote_data_source.dart

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/classrooms/data/models/class_m.dart';
import 'package:educonnect/features/classrooms/data/models/class_member.dart';
import 'package:educonnect/features/classrooms/data/models/class_model.dart';
import 'package:educonnect/features/classrooms/data/models/member_model.dart';
import 'package:educonnect/features/classrooms/data/models/request_model.dart';
import 'package:educonnect/features/classrooms/data/models/school_m.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/data/models/post_result.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';

abstract class ClassroomRemoteDataSource {
  Future<PostsResult> getPosts(int id, int page, String? type);
  Future<ClassModel> joinClass(String code);
  Future<SchoolModel> joinSchool(String code);
  Future<List<MemberModel>> getMembers(int id, String type);
  Future<List<ClassMemberModel>> getClasses(int id);
  Future<List<ClassModel>> getTeacherClasses(int? id);
  Future<ClassModel> addClass(ClassM classModel, File? image);
  Future<void> removeClass(int? id);
  Future<ClassModel> updateClass(int id, ClassM classModel, File? image);
  Future<SchoolModel> addSchool(SchoolM schoolModel, File? image);
  Future<void> removeSchool(int? id);
  Future<SchoolModel> updateSchool(int id, SchoolM schoolModel, File? image);
  Future<SchoolModel> schoolVerifyRequest(
      int id, String email, String phoneNumber, File? file);
  Future<void> associateStudent(int studentId, int schoolId, String type);
  Future<void> leave(int id, String type);
  Future<void> sendJoinRequest(int id);
  Future<List<ChildModel>> getStudents(int id, String type);
  Future<List<RequestModel>> getRequests(int id, String type);
  Future<MemberModel> accept(int id, String type);
  Future<void> refuse(int id, String type);
  Future<List<String>> generateCodes(String type, int id, int number);
  Future<void> removeMember(int id, int id2, String type);
}

class ClassroomRemoteDataSourceImpl implements ClassroomRemoteDataSource {
  final ApiConsumer apiConsumer;

  ClassroomRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<PostsResult> getPosts(int id, int page, String? type) async {
    if (type == "school") {
      final response = await apiConsumer.get(
        "${EndPoints.getSchool(id)}?page=$page",
      );
      final posts = (response['data']['data'] as List)
          .map((i) => PostModel.fromJson(i))
          .toList();
      final meta = Meta(
        currentPage: response['data']['meta']['current_page'],
        lastPage: response['data']['meta']['last_page'],
      );
      return PostsResult(data: posts, meta: meta);
    } else {
      final response = await apiConsumer.get(
        "${EndPoints.getClass(id)}?page=$page",
      );
      final posts = (response['data']['data'] as List)
          .map((i) => PostModel.fromJson(i))
          .toList();
      final meta = Meta(
        currentPage: response['data']['meta']['current_page'],
        lastPage: response['data']['meta']['last_page'],
      );
      return PostsResult(data: posts, meta: meta);
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
  Future<void> sendJoinRequest(int id) async {
    final response = await apiConsumer.post(EndPoints.sendJoinRequest, body: {
      'class_id': id,
    });

    if (response['statusCode'] == 409) {
      throw JoinedException();
    } else if (response['statusCode'] != 200) {
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

  @override
  Future<List<MemberModel>> getMembers(int id, String type) async {
    String endpoint;
    if (type == "school") {
      endpoint = EndPoints.getMembers(id);
    } else {
      endpoint = EndPoints.getClassMembers(id);
    }
    final response = await apiConsumer.get(endpoint);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data'] as List)
        .map((i) => MemberModel.fromJson(i))
        .toList();
  }

  @override
  Future<List<ChildModel>> getStudents(int id, String type) async {
    String endpoint;
    if (type == "school") {
      endpoint = EndPoints.getStudents(id);
    } else {
      endpoint = EndPoints.getClassStudents(id);
    }
    final response = await apiConsumer.get(endpoint);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data'] as List)
        .map((i) => ChildModel.fromJson(i))
        .toList();
  }

  @override
  Future<void> associateStudent(
      int studentId, int schoolId, String type) async {
    String endpoint;
    if (type == 'school') {
      endpoint = EndPoints.associateStudent(schoolId);
    } else {
      endpoint = EndPoints.associateStudent2(schoolId);
    }
    final response = await apiConsumer.post(
      endpoint,
      body: {
        'student_id': studentId,
      },
    );
    if (response['statusCode'] == 403) {
      throw StudentAlreadyAssociatedException();
    } else if (response['statusCode'] != 200) {
      throw ServerException();
    }
  }

  @override
  Future<List<ClassMemberModel>> getClasses(int id) async {
    final response = await apiConsumer.get(EndPoints.getClasses(id));
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data'] as List)
        .map((i) => ClassMemberModel.fromJson(i))
        .toList();
  }

  @override
  Future<List<ClassModel>> getTeacherClasses(int? id) async {
    final response = await apiConsumer.get(EndPoints.getTeacherClasses);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data']['data'] as List)
        .map((i) => ClassModel.fromJson(i))
        .toList();
  }

  @override
  Future<ClassModel> addClass(ClassM classModel, File? image) async {
    FormData formData;
    if (image != null) {
      String fileName = image.path.split('/').last;
      formData = FormData.fromMap({
        ...classModel.toJson(),
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap(classModel.toJson());
    }

    final response = await apiConsumer.post2(
      EndPoints.addClass,
      body: formData,
    );

    if (response['statusCode'] == 201) {
      return ClassModel.fromJson(response['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> removeClass(int? id) async {
    final response = await apiConsumer.delete(EndPoints.removeClass(id));
    if (response['statusCode'] != 204) {
      throw ServerException();
    }
  }

  @override
  Future<ClassModel> updateClass(int id, ClassM classModel, File? image) async {
    FormData formData;
    if (image != null) {
      String fileName = image.path.split('/').last;
      formData = FormData.fromMap({
        ...classModel.toJson(),
        "_method": "PUT",
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        ...classModel.toJson(),
        "_method": "PUT",
      });
    }

    final response = await apiConsumer.post2(
      EndPoints.removeClass(id),
      body: formData,
    );
    if (response['statusCode'] == 201) {
      return ClassModel.fromJson(response['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SchoolModel> addSchool(SchoolM schoolModel, File? image) async {
    FormData formData;
    if (image != null) {
      String fileName = image.path.split('/').last;
      formData = FormData.fromMap({
        ...schoolModel.toJson(),
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap(schoolModel.toJson());
    }

    final response = await apiConsumer.post2(
      EndPoints.addSchool,
      body: formData,
    );

    if (response['statusCode'] == 201) {
      return SchoolModel.fromJson(response['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> removeSchool(int? id) async {
    final response = await apiConsumer.delete(EndPoints.removeSchool(id));
    if (response['statusCode'] != 204) {
      throw ServerException();
    }
  }

  @override
  Future<SchoolModel> updateSchool(
      int id, SchoolM schoolModel, File? image) async {
    FormData formData;
    if (image != null) {
      String fileName = image.path.split('/').last;
      formData = FormData.fromMap({
        ...schoolModel.toJson(),
        "_method": "PUT",
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        ...schoolModel.toJson(),
        "_method": "PUT",
      });
    }

    final response = await apiConsumer.post2(
      EndPoints.updateSchool(id),
      body: formData,
    );
    if (response['statusCode'] == 201) {
      return SchoolModel.fromJson(response['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SchoolModel> schoolVerifyRequest(
      int id, String email, String phoneNumber, File? file) async {
    FormData formData;
    if (file != null) {
      String fileName = file.path.split('/').last;
      formData = FormData.fromMap({
        "email": email,
        "phone_number": phoneNumber,
        "document": await MultipartFile.fromFile(file.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        "email": email,
        "phone_number": phoneNumber,
      });
    }

    final response = await apiConsumer.post2(
      EndPoints.schoolVerifyRequest(id),
      body: formData,
    );
    if (response['statusCode'] == 200) {
      return SchoolModel.fromJson(response['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> leave(int id, String type) async {
    String endpoint;
    if (type == 'school') {
      endpoint = EndPoints.leaveSchool(id);
    } else {
      endpoint = EndPoints.leaveClass(id);
    }
    final response = await apiConsumer.post(endpoint);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
  }

  @override
  Future<List<RequestModel>> getRequests(int id, String type) async {
    String endpoint;
    if (type == 'school') {
      endpoint = EndPoints.getSchoolRequests(id);
    } else {
      endpoint = EndPoints.getClassRequests(id);
    }
    final response = await apiConsumer.get(endpoint);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data'] as List)
        .map((i) => RequestModel.fromJson(i))
        .toList();
  }

  @override
  Future<MemberModel> accept(int id, String type) async {
    String endpoint;
    if (type == 'school') {
      endpoint = EndPoints.acceptSchool(id);
    } else {
      endpoint = EndPoints.acceptClass(id);
    }
    final response = await apiConsumer.post(endpoint);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return MemberModel.fromJson(response['data']);
  }

  @override
  Future<void> refuse(int id, String type) async {
    String endpoint;
    if (type == 'school') {
      endpoint = EndPoints.refuseSchool(id);
    } else {
      endpoint = EndPoints.refuseClass(id);
    }
    final response = await apiConsumer.post(endpoint);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> removeMember(int id,int id2, String type) async {
    String endpoint;
    if (type == 'school') {
      endpoint = EndPoints.removeMember1(id, id2);
    } else {
      endpoint = EndPoints.removeMember2(id, id2);
    }
    final response = await apiConsumer.delete(endpoint);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
  }
  @override
  Future<List<String>> generateCodes(String type, int id, int number) async {
    String endpoint;
    if (type == 'school') {
      endpoint = EndPoints.generateCodes("schools", id);
    } else {
      endpoint = EndPoints.generateCodes("classes", id);
    }
    final response = await apiConsumer.post(endpoint, body: {
      'number': number,
    });
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data']['codes'] as List)
        .map((i) => i.toString())
        .toList();
  }
}
