import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/app_interceptors.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/api/status_code.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/features/auth/data/repositories/token_repository.dart';
import 'package:educonnect/injection_container.dart' as di;

class DioConsumer implements ApiConsumer {
  final Dio client;
  final TokenProvider tokenProvider;

  DioConsumer({required this.client, required this.tokenProvider}) {
    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..connectTimeout = 10000
      ..receiveTimeout = 10000
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
    client.interceptors.add(di.sl<AppInterceptors>());
    client.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers.addAll(
            {'Authorization': 'Bearer ${await tokenProvider.getToken()}'});
        return handler.next(options);
      },
    ));

    if (kDebugMode) {
      client.interceptors.add(di.sl<LogInterceptor>());
    }
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(path, queryParameters: queryParameters);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(String path,
      {Map<String, dynamic>? body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.post(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post2(String path,
      {dynamic body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters,
      File? file}) async {
    try {
      FormData formData;
      if (body is FormData) {
        formData = body;
      } else {
        formData = FormData.fromMap(body);
      }

      final response = await client.post(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? formData : body);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await client.put(path, queryParameters: queryParameters, data: body);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }
  @override
  Future put2(String path,
      {dynamic body,
      Map<String, dynamic>? queryParameters,
      File? file}) async {
    try {
      FormData formData;
      if (body is FormData) {
        formData = body;
      } else {
        formData = FormData.fromMap(body);
      }

      final response = await client.put(path,
          queryParameters: queryParameters, data: formData);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await client.delete(path, queryParameters: queryParameters);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  // dynamic _handleResponseAsJson(Response<dynamic> response) {
  //   final responseJson = jsonDecode(response.data.toString());
  //   return responseJson;
  // }
  dynamic _handleResponseAsJson(Response<dynamic> response) {
    if (response.statusCode == 204) {
      return {
        'statusCode': response.statusCode,
        'data': null,
      };
    }

    final responseJson = jsonDecode(response.data.toString());
    return {
      'statusCode': response.statusCode,
      'data': responseJson,
    };
  }

  dynamic _handleDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
      // throw const FetchDataException();
      case DioErrorType.response:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw const BadRequestException();
          case StatusCode.unauthorized:
          case StatusCode.forbidden:
            throw const UnauthorizedException();
          case StatusCode.notFound:
            throw const NotFoundException();
          case StatusCode.confilct:
            throw const ConflictException();

          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        throw const NoInternetConnectionException();
    }
  }
}
