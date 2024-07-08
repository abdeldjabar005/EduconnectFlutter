// Data Layer - Data Sources

import 'dart:async';

import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/utils/logger.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String firstName, String lastName, String role,
      String email, String password, String confirmPassword);
  Future<UserModel> verifyEmail(String email, String verificationCode);
  Future<void> resendEmail(String email);
  Future<void> forgotPassword(String email);
  Future<void> validateOtp(String code);
  Future<void> resetPassword(String password, String confirmPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiConsumer apiConsumer;
  String _token = '';

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.login,
        body: {'email': email, 'password': password},
      ).timeout(const Duration(seconds: 10));

      if (response['statusCode'] == 200) {
        return UserModel.fromJson(response['data']);
      } else if (response['statusCode'] == 401) {
        throw const InvalidCredentialsException();
      } else if (response['statusCode'] == 422) {
        throw const ValidationException();
      } else {
        print(response);
        throw ServerException();
      }
    } on TimeoutException {
      throw const ServerException();
    }
  }

  @override
  Future<UserModel> signUp(String firstName, String lastName, String role,
      String email, String password, String confirmPassword) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.signUp,
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'role': role,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword
        },
      ).timeout(const Duration(seconds: 10));

      if (response['statusCode'] == 201) {
        return UserModel.fromJson(response['data']);
      } else if (response['statusCode'] == 422) {
        throw EmailAlreadyExistsException();
      } else {
        throw ServerException();
      }
    } on TimeoutException {
      throw const ServerException();
    }
  }

  @override
  Future<UserModel> verifyEmail(String email, String verificationCode) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.verifyEmail,
        body: {
          'email': email,
          'otp': verificationCode,
        },
      ).timeout(const Duration(seconds: 10));

      if (response['statusCode'] == 200) {
        return UserModel.fromJson(response['data']);
      } else {
        throw ServerException();
      }
    } on TimeoutException {
      throw const ServerException();
    }
  }

  @override
  Future<void> resendEmail(String email) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.resendEmail,
        body: {
          'email': email,
        },
      ).timeout(const Duration(seconds: 10));

      if (response['statusCode'] == 200) {
        return;
      } else {
        throw ServerException();
      }
    } on TimeoutException {
      throw const ServerException();
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.forgotPassword,
        body: {
          'email': email,
        },
      );

      if (response['statusCode'] == 200) {
        _token = response['data']['token'];
        return;
      } else if (response['statusCode'] == 404) {
        throw EmailDoesNotExistException();
      } else {
        throw ServerException();
      }
    } on TimeoutException {
      throw const ServerException();
    }
  }

  @override
  Future<void> validateOtp(String code) async {
    try {
      vLog(_token);
      final response = await apiConsumer.post(
        EndPoints.validateOtp,
        body: {
          'otp': code,
          'token': _token,
        },
      );

      if (response['statusCode'] == 200) {
        return;
      } else if (response['statusCode'] == 400) {
        throw InvalidCodeException();
      } else {
        throw ServerException();
      }
    } on TimeoutException {
      throw const ServerException();
    }
  }

  @override
  Future<void> resetPassword(String password, String confirmPassword) async {
    try {
      final response = await apiConsumer.post(
        EndPoints.resetPassword,
        body: {
          'password': password,
          'password_confirmation': confirmPassword,
          'token': _token,
        },
      );

      if (response['statusCode'] == 200) {
        return;
      } else {
        throw ServerException();
      }
    } on TimeoutException {
      throw const ServerException();
    }
  }
}
