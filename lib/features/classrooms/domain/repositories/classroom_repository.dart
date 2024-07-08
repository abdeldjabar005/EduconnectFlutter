// classroom_repository.dart
import 'dart:io';

import 'package:dartz/dartz.dart';
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

abstract class ClassroomRepository {
  Future<Either<Failure, PostsResult>> getPosts(int id, int page, String? type);
  Future<Either<Failure, ClassModel>> joinClass(String code);
  Future<Either<Failure, SchoolModel>> joinSchool(String code);
  Future<Either<Failure, List<MemberModel>>> getMembers(int id, String type);
  Future<Either<Failure, List<ClassMemberModel>>> getClasses(int id);
  Future<Either<Failure, ClassModel>> addClass(ClassM classModel, File? image);
  Future<Either<Failure, SchoolModel>> addSchool(
      SchoolM schoolModel, File? image);
  Future<Either<Failure, List<ClassModel>>> getTeacherClasses(int? id);
  Future<Either<Failure, void>> removeClass(int? id);
  Future<Either<Failure, void>> removeSchool(int? id);
  Future<Either<Failure, ClassModel>> updateClass(
      int id, ClassM classModel, File? image);
  Future<Either<Failure, SchoolModel>> updateSchool(
      int id, SchoolM schoolModel, File? image);
  Future<Either<Failure, SchoolModel>> schoolVerifyRequest(
      int id, String email, String phoneNumber, File? file);
  Future<Either<Failure, void>> associateStudent(
      int studentId, int schoolId, String type);
  Future<Either<Failure, void>> leave(int id, String type);
  Future<Either<Failure, void>> sendJoinRequest(int id);
  Future<Either<Failure, List<ChildModel>>> getStudents(int id, String type);
  Future<Either<Failure, List<RequestModel>>> getRequests(int id, String type);
  Future<Either<Failure, MemberModel>> accept(int id, String type);
  Future<Either<Failure, void>> refuse(int id, String type);
  Future<Either<Failure, List<String>>> generateCodes(
      String type, int id, int number);
  Future<Either<Failure, void>> removeMember(int id, int id2, String type);
}
