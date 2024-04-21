// classroom_repository_impl.dart
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/network/netwok_info.dart';
import 'package:quotes/features/classrooms/data/datasources/classroom_remote_data_source.dart';
import 'package:quotes/features/classrooms/data/models/class_m.dart';
import 'package:quotes/features/classrooms/data/models/class_member.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/member_model.dart';
import 'package:quotes/features/classrooms/data/models/school_m.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';
import 'package:quotes/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ClassroomRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<PostModel>>> getPosts(
      int id, int page, String type) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteClassroom = await remoteDataSource.getPosts(id, page, type);
        return Right(remoteClassroom);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ClassModel>> joinClass(String code) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.joinClass(code);
        return Right(remoteResponse);
      } on JoinedException {
        return Left(JoinedFailure());
      } on InvalidCodeException {
        return Left(InvalidCodeFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SchoolModel>> joinSchool(String code) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.joinSchool(code);
        return Right(remoteResponse);
      } on JoinedException {
        return Left(JoinedFailure());
      } on InvalidCodeException {
        return Left(InvalidCodeFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, List<MemberModel>>> getMembers(int id, String type) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.getMembers(id, type);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<ClassMemberModel>>> getClasses(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.getClasses(id);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, List<ClassModel>>> getTeacherClasses(int? id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.getTeacherClasses(id);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, ClassModel>> addClass(ClassM classModel, File? image) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.addClass(classModel, image);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, void>> removeClass(int? id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.removeClass(id);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, ClassModel>> updateClass(int id, ClassM classModel, File? image) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.updateClass(id, classModel, image);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, SchoolModel>> addSchool(SchoolM schoolModel, File? image) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.addSchool(schoolModel, image);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, void>> removeSchool(int? id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.removeSchool(id);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, SchoolModel>> updateSchool(int id, SchoolM schoolModel, File? image) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.updateSchool(id, schoolModel, image);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
