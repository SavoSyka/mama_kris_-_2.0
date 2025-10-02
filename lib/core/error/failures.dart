import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error']);
}

class ApiException extends Equatable implements Exception {
  const ApiException({required String? message, required this.statusCode})
    : message = message ?? 'API error';

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Parsing error']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}
