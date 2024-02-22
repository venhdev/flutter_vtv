part of 'base_response.dart';

class SuccessResponse extends BaseHttpResponse {
  const SuccessResponse({
    super.code,
    super.message,
    super.status,
  });
}

class DataResponse<T> extends SuccessResponse {
  const DataResponse(
    this.data, {
    super.code,
    super.message,
    super.status,
  });

  final T data;

  @override
  List<Object?> get props => [
        code,
        message,
        status,
        data,
      ];
}
