import 'package:equatable/equatable.dart';

import '../network/base_response.dart';

enum Code { unknown, unauthorized, unauthenticated, notFound }

// General failure message
const String failureMessage = 'Something went wrong !!!';
const String connectionFailureMessage = 'Connection Failure';
const String cacheFailureMessage = 'Cache Failure';

class Failure extends Equatable {
  factory Failure.fromResp(ErrorResponse resp) {
    return Failure(message: resp.message ?? 'Lỗi không xác định từ server');
  }
  const Failure({
    this.message = failureMessage,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}

// General failure message
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = failureMessage,
  });
}

// No code failure
class ConnectionFailure extends Failure {
  const ConnectionFailure({
    super.message = connectionFailureMessage,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = cacheFailureMessage,
  });
}
