import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions implements Exception {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;
  const factory NetworkExceptions.unauthorizedRequest(String error) =
      UnauthorizedRequest;
  const factory NetworkExceptions.loggingInRequired() = LoggingInRequired;

  const factory NetworkExceptions.badRequest(String error, {Map<String, dynamic>? errors}) = BadRequest;

  const factory NetworkExceptions.unprocessableEntity(
      String error, {
        Map<String, dynamic>? errors,
      }) = UnprocessableEntity;

  const factory NetworkExceptions.notFound() = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;
  const factory NetworkExceptions.tooManyRequest() = TooManyRequest;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;


  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError(String error) =
      UnexpectedError;

  static List<NetworkExceptions> getAllNetworkExceptions() {
    return [
      const NetworkExceptions.badRequest(''),
      const NetworkExceptions.unauthorizedRequest(''),
      const NetworkExceptions.conflict(),
      const NetworkExceptions.defaultError(''),
      const NetworkExceptions.formatException(),
      const NetworkExceptions.internalServerError(),
      const NetworkExceptions.loggingInRequired(),
      const NetworkExceptions.methodNotAllowed(),
      const NetworkExceptions.noInternetConnection(),
      const NetworkExceptions.notFound(),
      const NetworkExceptions.notAcceptable(),
      const NetworkExceptions.notImplemented(),
      const NetworkExceptions.requestCancelled(),
      const NetworkExceptions.unprocessableEntity(""),
      const NetworkExceptions.unexpectedError(''),
      const NetworkExceptions.unableToProcess(),
      const NetworkExceptions.serviceUnavailable(),
      const NetworkExceptions.sendTimeout(),
      const NetworkExceptions.tooManyRequest(),
    ];
  }

  static NetworkExceptions handleResponse(Response? response) {
    int statusCode = response?.statusCode ?? 0;
    Map<String, dynamic> data = response!.data as Map<String, dynamic>;
    switch (statusCode) {
      case 400:
        return NetworkExceptions.badRequest(
          data['message'],
          errors: data['errors'],
        );
      case 422:
        return NetworkExceptions.unprocessableEntity(
          data['message'],
          errors: data['errors'],
        );
      case 401:
        return NetworkExceptions.unauthorizedRequest(data['message']);
      case 403:
        return const NetworkExceptions.loggingInRequired();
      case 404:
        return const NetworkExceptions.notFound();
      case 405:
        return const NetworkExceptions.methodNotAllowed();
      case 409:
        return const NetworkExceptions.conflict();
      case 408:
        return const NetworkExceptions.requestTimeout();
      case 429:
        return const NetworkExceptions.tooManyRequest();
      case 500:
        return const NetworkExceptions.internalServerError();
      case 503:
        return const NetworkExceptions.serviceUnavailable();
      default:
        return NetworkExceptions.defaultError(data['message']);
    }
  }

  static NetworkExceptions getException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;
        if (error is DioException) {
          networkExceptions = _handleDioError(error);
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions =
              NetworkExceptions.unexpectedError(error.toString());
        }
        return networkExceptions;
      } on FormatException {
        return const NetworkExceptions.formatException();
      } catch (e) {
        return NetworkExceptions.unexpectedError(e.toString());
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return NetworkExceptions.unexpectedError(error.toString());
      }
    }
  }

  static NetworkExceptions _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return const NetworkExceptions.requestCancelled();

      case DioExceptionType.connectionTimeout:
        return const NetworkExceptions.requestTimeout();

      case DioExceptionType.unknown:
        return const NetworkExceptions.noInternetConnection();

      case DioExceptionType.receiveTimeout:
        return const NetworkExceptions.sendTimeout();

      case DioExceptionType.badResponse:
        return NetworkExceptions.handleResponse(error.response);

      case DioExceptionType.sendTimeout:
        return const NetworkExceptions.sendTimeout();

      case DioExceptionType.connectionError:
        return const NetworkExceptions.noInternetConnection();

      case DioExceptionType.badCertificate:
        return const NetworkExceptions.methodNotAllowed();
    }
  }

  static String getErrorMessage(NetworkExceptions? networkExceptions) {
    var errorMessage = "";
    networkExceptions?.whenOrNull(
      notImplemented: () {
        errorMessage = "Not Implemented";
      },
      requestCancelled: () {
        errorMessage = "Request Cancelled";
      },
      loggingInRequired: () {
        errorMessage = "Log in First";
      },
      internalServerError: () {
        errorMessage = 'internal Server Error';
      },
      badRequest: (String error, Map<String, dynamic>? errors) {
        errorMessage = error;
        if (errors != null) {
          errorMessage += _formatErrors(errors);
        }
      },
      unprocessableEntity: (String error, Map<String, dynamic>? errors) {
        errorMessage = error;
        if (errors != null) {
          errorMessage += _formatErrors(errors);
        }
      },
      serviceUnavailable: () {
        errorMessage = "Service unavailable";
      },
      methodNotAllowed: () {
        errorMessage = "Method Not Allowed";
      },
      unauthorizedRequest: (String error) {
        errorMessage = error;
      },
      unexpectedError: (error) {
        errorMessage = error;
      },
      requestTimeout: () {
        errorMessage = 'connection Request Timeout';
      },
      noInternetConnection: () {
        errorMessage = 'no Internet Connection';
      },
      conflict: () {
        errorMessage = "Error due to a conflict";
      },
      sendTimeout: () {
        errorMessage = "Send timeout in connection with API server";
      },
      unableToProcess: () {
        errorMessage = "Unable to process the data";
      },
      defaultError: (String error) {
        errorMessage = error;
      },
      formatException: () {
        errorMessage = 'unexpected Error Occurred';
      },
      notAcceptable: () {
        errorMessage = "Not acceptable";
      },
      tooManyRequest: () {
        errorMessage = 'please Try Again Later';
      },
    ) ??
        'something Went Wrong';

    return errorMessage;
  }


  static String _formatErrors(Map<String, dynamic> errors) {
    final buffer = StringBuffer('\n');
    debugPrint(errors.toString());
    void addErrors(dynamic errorData) {
      if (errorData is List) {
        for (final error in errorData) {
          buffer.writeln('- $error');
        }
      } else if (errorData is Map) {
        for (final entry in errorData.entries) {
          if (entry.value is List) {
            for (final error in entry.value as List) {
              buffer.writeln('- ${entry.key}: $error');
            }
          } else {
            buffer.writeln('- ${entry.key}: ${entry.value}');
          }
        }
      }
    }

    // Handle nested errors structure (like in your second example)
    if (errors.keys.any((key) => key.startsWith('item_'))) {
      for (final entry in errors.entries) {
        if (entry.value is Map) {
          addErrors(entry.value);
        }
      }
    } else {
      addErrors(errors);
    }

    return buffer.toString();
  }
}
