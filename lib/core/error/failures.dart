import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvalidCredentialsFailure extends Failure {}

class EmailAlreadyExistsFailure extends Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class JoinedFailure extends Failure {}

class InvalidCodeFailure extends Failure {}

class StudentAlreadyAssociatedFailure extends Failure {}