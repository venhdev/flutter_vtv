part of 'base_response.dart';

const String errorResponseMessage = 'Fail';
const String serverErrorMessage = 'Server Error';
const String clientErrorMessage = 'Client Error';
const String unexpectedErrorMessage = 'Unexpected Error';

class ErrorResponse extends BaseHttpResponse {
  const ErrorResponse({
    super.code,
    super.message = errorResponseMessage,
    super.status,
  });
}

class UnexpectedError extends ErrorResponse {
  const UnexpectedError({
    super.message = unexpectedErrorMessage,
    super.code,
    super.status,
  });
}

class ClientError extends ErrorResponse {
  const ClientError({
    super.message = clientErrorMessage,
    super.code,
    super.status,
  });
}

class ServerError extends ErrorResponse {
  const ServerError({
    super.message = serverErrorMessage,
    super.code,
    super.status,
  });
}
