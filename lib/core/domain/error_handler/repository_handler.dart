import 'dart:io';
import 'package:dio/dio.dart';

import 'failures.dart';
import 'network_exceptions.dart';

class RepositoryHandler {

  /// الخطوة 1: تحويل DioException إلى NetworkExceptions
  static NetworkExceptions getDioException(DioException dioError) {
    // التعامل مع أخطاء الاتصال
    if (dioError.type == DioExceptionType.unknown && dioError.error is SocketException) {
      return const NetworkExceptions.noInternetConnection();
    }

    switch (dioError.type) {
      case DioExceptionType.cancel:
        return const NetworkExceptions.requestCancelled();
      case DioExceptionType.receiveTimeout:
        return const NetworkExceptions.sendTimeout();;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkExceptions.sendTimeout();
      case DioExceptionType.badResponse:
        final response = dioError.response;
        if (response != null && response.statusCode != null) {
          final statusCode = response.statusCode!;
          final dynamic errorData = response.data;
          // محاولة استخراج رسالة الخطأ من الرد
          final message = errorData is Map<String, dynamic> && errorData['message'] != null
              ? errorData['message'].toString()
              : 'Server Error';

          // الربط بين Status Codes وكلاسات NetworkExceptions
          switch (statusCode) {
            case 400: // Bad Request
              return NetworkExceptions.badRequest(message, errors: errorData);
            case 401: // Unauthorized
              return NetworkExceptions.unauthorizedRequest(message);
            case 404: // Not Found
              return const NetworkExceptions.notFound();
            case 422: // Unprocessable Entity (مهم لخطأ 'Duplicate Email')
              return NetworkExceptions.unprocessableEntity(message, errors: errorData);
            case 500: // Internal Server Error
              return const NetworkExceptions.internalServerError();
            default:
              return NetworkExceptions.defaultError('Received invalid status code: $statusCode');
          }
        }
        return const NetworkExceptions.defaultError('Unknown error in bad response');
      case DioExceptionType.badCertificate:
        return const NetworkExceptions.defaultError('Bad Certificate');
      case DioExceptionType.connectionError:
        return const NetworkExceptions.noInternetConnection();
      case DioExceptionType.unknown:
        return NetworkExceptions.unexpectedError('Unknown error occurred: ${dioError.error}');
    }
  }

  /// الخطوة 2: تحويل NetworkExceptions إلى Failure (للاستخدام في الـ Repository)
  static Failure getResultFailure(NetworkExceptions networkExceptions) {
    return networkExceptions.when(
      noInternetConnection: () => const NetworkFailure(),
      requestCancelled: () => const NetworkFailure(message: 'Request Cancelled'),
      unauthorizedRequest: (String error) => ValidationFailure(message: error, statusCode: 401),
      loggingInRequired: () => const ValidationFailure(message: 'Login Required', statusCode: 401),
      badRequest: (String error, Map<String, dynamic>? errors) => ValidationFailure(message: error, statusCode: 400),
      unprocessableEntity: (String error, Map<String, dynamic>? errors) => ValidationFailure(message: error, statusCode: 422),
      notFound: () => const ServerFailure(message: 'Not Found', statusCode: 404),
      methodNotAllowed: () => const ServerFailure(message: 'Method Not Allowed', statusCode: 405),
      notAcceptable: () => const ServerFailure(message: 'Not Acceptable', statusCode: 406),
      tooManyRequest: () => const ServerFailure(message: 'Too Many Requests', statusCode: 429),
      requestTimeout: () => const NetworkFailure(message: 'Request Timeout'),
      sendTimeout: () => const NetworkFailure(message: 'Send Timeout'),
      conflict: () => const ServerFailure(message: 'Conflict', statusCode: 409),
      internalServerError: () => const ServerFailure(message: 'Internal Server Error', statusCode: 500),
      notImplemented: () => const ServerFailure(message: 'Not Implemented', statusCode: 501),
      serviceUnavailable: () => const ServerFailure(message: 'Service Unavailable', statusCode: 503),
      formatException: () => const LocalFailure(message: 'Data Format Exception'),
      unableToProcess: () => const LocalFailure(message: 'Unable to Process Data'),
      defaultError: (String error) => ServerFailure(message: error, statusCode: 0),
      unexpectedError: (String error) => LocalFailure(message: error),
    );
  }
}