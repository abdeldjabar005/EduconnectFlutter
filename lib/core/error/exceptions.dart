import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String? message;

  const ServerException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}



class InvalidCredentialsException extends ServerException {
  const InvalidCredentialsException([String? message]) : super("Invalid credentials");
}
class ValidationException extends ServerException {
  const ValidationException([String? message]) : super("Validation error");
}

class FetchDataException extends ServerException {
  const FetchDataException([message]) : super("Error During Communication");
}

class BadRequestException extends ServerException {
  const BadRequestException([message]) : super("Bad Request");
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException([message]) : super("Unauthorized");
}

class NotFoundException extends ServerException {
  const NotFoundException([message]) : super("Requested Info Not Found");
}

class ConflictException extends ServerException {
  const ConflictException([message]) : super("Conflict Occurred");
}

class JoinedException extends ServerException {
  const JoinedException([message]) : super("You are already joined");
}
class InvalidCodeException extends ServerException {
  const InvalidCodeException([message]) : super("Invalid code");
}
class EmailAlreadyExistsException extends ServerException {
  const EmailAlreadyExistsException([message])
      : super("Email already exists");
}
class OldPasswordWrongException extends ServerException {
  const OldPasswordWrongException([message])
      : super("Old password is wrong");
}
class EmailDoesNotExistException extends ServerException {
  const EmailDoesNotExistException([message])
      : super("Email does not exist");
}
class StudentAlreadyAssociatedException extends ServerException {
  const StudentAlreadyAssociatedException([message])
      : super("Student already associated");
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException([message])
      : super("Internal Server Error");
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException([message])
      : super("No Internet Connection");
}

class CacheException implements Exception {}
