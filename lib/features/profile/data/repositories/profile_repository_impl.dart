

import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/network/netwok_info.dart';
import 'package:quotes/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';
import 'package:quotes/features/profile/domain/repositories/profile_repository.dart';

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
  Future<Either<Failure, void>> addChild(ChildModel child) async {
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
}