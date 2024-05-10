// Domain Layer - Use Cases

import 'package:dartz/dartz.dart';
import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/auth/domain/repositories/auth_repository.dart';


class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User?>> call(String email, String password) {
    return repository.login(email, password);
  }
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, User?>> call(String firstName, String lastName, String role,String email, String password, String confirmPassword) {
    return repository.signUp(firstName, lastName, role, email, password, confirmPassword);
  }
}