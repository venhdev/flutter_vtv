import 'package:equatable/equatable.dart';

enum Code { unknown, unauthorized, unauthenticated, notFound }

// General failure message
const String failureMessage = 'Something went wrong !!!';
const String serverFailureFailureMessage = 'Server Failure';
const String clientFailureFailureMessage = 'Client Failure';
const String connectionFailureMessage = 'Connection Failure';

class Failure extends Equatable {
  const Failure({
    this.code,
    this.message = failureMessage,
  });

  final int? code;
  final String message;

  @override
  List<Object?> get props => [code, message];
}

// General failure message
class ClientFailure extends Failure {
  const ClientFailure({
    super.code,
    super.message = clientFailureFailureMessage,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.code,
    super.message = serverFailureFailureMessage,
  });
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({
    super.message = connectionFailureMessage,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = failureMessage,
  });
}
