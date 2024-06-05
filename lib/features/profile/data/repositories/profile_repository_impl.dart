import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/network/netwok_info.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';
import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/data/models/profile_model.dart';
import 'package:educonnect/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ChildModel>>> getChildren() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.getChildren();
        return Right(remoteProfile);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ChildModel>> addChild(ChildModel child) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.addChild(child);
        return Right(remoteProfile);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeChild(int? id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.removeChild(id);
        return Right(remoteProfile);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateChild(ChildModel child) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.updateChild(child);
        return Right(remoteProfile);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(
      ProfileModel user, File? image) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.updateProfile(user, image);
        return Right(remoteProfile);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
      String oldpassword, String password, String confirmPassword) async {
    try {
        await remoteDataSource.changePassword(
          oldpassword, password, confirmPassword);
      return Right(null);
    } on OldPasswordWrongException {
      return Left(OldPasswordWrongFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
