part of 'base_response.dart';

class SuccessResponse extends BaseHttpResponse {
  const SuccessResponse({
    super.code,
    super.message,
    super.status,
  });

  @override
  List<Object?> get props => [
        code,
        message,
        status,
      ];

  @override
  bool get stringify => true;
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

  @override
  bool get stringify => true;
}
