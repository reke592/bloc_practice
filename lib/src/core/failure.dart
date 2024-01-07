import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final int statusCode;

  String get failureMessage => '$statusCode: $message';

  @override
  List<Object?> get props => [message, statusCode];
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, required super.statusCode});
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});
}
