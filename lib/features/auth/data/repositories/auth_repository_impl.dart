// Data Layer - Repositories
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:quotes/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/core/error/failures.dart';

import 'package:quotes/features/auth/domain/entities/user.dart';
import 'package:quotes/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  User? currentUser;
  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.secureStorage});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await secureStorage.write(key: 'token', value: userModel.token);
      // currentUser = userModel.toEntity();
      // return Right(currentUser!);
      return Right(userModel.toEntity());
    } on InvalidCredentialsException {
      return Left(InvalidCredentialsFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
      String firstName,
      String lastName,
      String role,
      String email,
      String password,
      String confirmPassword) async {
    try {
      final userModel = await remoteDataSource.signUp(
          firstName, lastName, role, email, password, confirmPassword);
      await secureStorage.write(key: 'token', value: userModel.token);
      return Right(userModel.toEntity());
    } on EmailAlreadyExistsException {
      return Left(EmailAlreadyExistsFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> verifyEmail(String email, String verificationCode) async {
    try {
      final userModel = await remoteDataSource.verifyEmail(email, verificationCode);
      return Right(userModel.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
