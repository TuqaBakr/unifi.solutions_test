import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// A failure that occurs due to network issues (e.g., no internet connection).
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No Internet Connection'});
}

/// A failure that occurs on the server side (e.g., 404, 500 status codes).
class ServerFailure extends Failure {
  const ServerFailure({required super.message, required int super.statusCode});
}

/// A failure specifically for authentication or validation issues (e.g., 401 Unauthorized, 422 Unprocessable Entity, Duplicate Email).
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, required int super.statusCode});
}

/// A general failure for unknown errors.
class LocalFailure extends Failure {
  const LocalFailure({super.message = 'An unknown local error occurred'});
}
