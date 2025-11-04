import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../domain/error_handler/failures.dart';

class GlobalApiInterceptor extends Interceptor {
  final String bearerToken;

  GlobalApiInterceptor({required this.bearerToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('REQUEST[${options.method}] => PATH: ${options.uri}');
    }

    options.headers.addAll({'Authorization': 'Bearer $bearerToken'});

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('ERROR[${err.response?.statusCode ?? err.type}] => PATH: ${err.requestOptions.uri}');
    }

    Failure failure;
    final statusCode = err.response?.statusCode;

    String errorMessage = 'An unknown error occurred';
    final responseData = err.response?.data;

    if (responseData is Map && responseData['data'] != null) {
      final data = responseData['data'];
      if (data is List && data.isNotEmpty) {
       final errorDetail = data.first;
        errorMessage = errorDetail['field'] != null
            ? '${errorDetail['field']} ${errorDetail['message']}'
            : errorDetail['message'] ?? errorMessage;
      } else if (data is Map && data['message'] != null) {
        errorMessage = data['message'];
      }
    } else if (err.message != null) {
      errorMessage = err.message!;
    }

    if (statusCode == 422) {
      failure = ValidationFailure(message: errorMessage, statusCode: statusCode!);
    } else if (statusCode != null && statusCode >= 500) {
      failure = ServerFailure(message: errorMessage, statusCode: statusCode);
    } else if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      failure = ValidationFailure(message: errorMessage, statusCode: statusCode);
    } else {
      // Handle non-HTTP status errors (Network/Timeout)
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          failure = const NetworkFailure(message: 'Connection Timeout');
          break;
        case DioExceptionType.badResponse:
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
        default:
          failure = const NetworkFailure(message: 'Check your internet connection');
          break;
      }
    }

    // Pass the converted failure object
    return handler.next(err.copyWith(error: failure));
  }
}
