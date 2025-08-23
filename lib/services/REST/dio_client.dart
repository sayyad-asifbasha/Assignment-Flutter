import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Header {
  static const Map<String, String> defaultHeader = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
}

class DioClient {
  static const int TIME_OUT_DURATION = 20;

  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: TIME_OUT_DURATION),
    receiveTimeout: const Duration(seconds: TIME_OUT_DURATION),
    sendTimeout: const Duration(seconds: TIME_OUT_DURATION),
  ))
    ..interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: false,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

  //GET

  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      var response = await _dio.get(url,
          options: Options(headers:  Header.defaultHeader), queryParameters: params);

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  //POST

  Future<dynamic> post(
      {required String url, Map<String, dynamic>? params, dynamic body}) async {
    var payload = json.encode(body);
    try {
      var response = await _dio.post(url,
          options: Options(headers:  Header.defaultHeader),
          queryParameters: params,
          data: payload);

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  //PUT

  Future<dynamic> put(
      {required String url, Map<String, dynamic>? params, dynamic body}) async {
    var payload = json.encode(body);
    try {
      var response = await _dio.put(url,
          options: Options(headers:  Header.defaultHeader),
          queryParameters: params,
          data: payload);

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  //PATCH

  Future<dynamic> patch(
      {required String url, Map<String, dynamic>? params, dynamic body}) async {
    var payload = json.encode(body);
    try {
      var response = await _dio.patch(url,
          options: Options(headers:  Header.defaultHeader),
          queryParameters: params,
          data: payload);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  //DELETE

  Future<dynamic> delete(
      {required String url, Map<String, dynamic>? params, dynamic body}) async {
    var payload = json.encode(body);
    try {
      var response = await _dio.delete(url,
          options: Options(headers:  Header.defaultHeader),
          queryParameters: params,
          data: payload);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}