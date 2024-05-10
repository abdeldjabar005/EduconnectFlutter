// Data Layer - Data Sources

import 'dart:async';

import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String firstName, String lastName, String role,
      String email, String password, String confirmPassword);
  Future<UserModel> verifyEmail(String email, String verificationCode);
  Future<void> resendEmail(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiConsumer apiConsumer;

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
}
