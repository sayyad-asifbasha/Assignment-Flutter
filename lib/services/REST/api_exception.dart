import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  String message = "";

  DioExceptions.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = "Request cancelled!";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout!";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout!";
        break;
      case DioExceptionType.sendTimeout:
        message = "Connection problem!";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(dioException.response!.statusCode!.toInt(),
            dioException.response!.data);
        break;
      case DioExceptionType.unknown:
        message = "Something went wrong!";
        break;
      default:
        message =  "Something went wrong!";
        break;
    }
  }

  String _handleError(int statusCode, dynamic error) {
    if (error is Map) {
      return error['error'] ??
          error["message"] ??
          _defaultErrorMessage(statusCode);
    } else if (error is String) {
      final isHtml =
          error.contains('<!DOCTYPE html>') || error.contains('<html');
      return isHtml
          ? _defaultErrorMessage(statusCode)
          : (error.isNotEmpty ? error : _defaultErrorMessage(statusCode));
    } else {
      return _defaultErrorMessage(statusCode);
    }
  }

  String _defaultErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad request";
      case 401:
        return "Unauthorized!";
      case 404:
        return "Api Url Incorrect";
      case 500:
        return "Internal Server Error";
      default:
        return  "Something went wrong!";
    }
  }

  @override
  String toString() => message;
}