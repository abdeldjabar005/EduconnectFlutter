

import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/network/netwok_info.dart';
import 'package:educonnect/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
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
}