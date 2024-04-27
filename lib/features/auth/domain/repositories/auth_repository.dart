// Domain Layer - Repositories

import 'package:dartz/dartz.dart';
import 'package:quotes/features/auth/domain/entities/user.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signUp(String firstName, String lastName,
      String role, String email, String password, String confirmPassword);
  Future<Either<Failure, User>> verifyEmail(
      String email, String verificationCode);
  Future<Either<Failure, void>> resendEmail(String email);
}
