import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //> return error if status code is 400
    if (err.response?.statusCode == 400 && err.type == DioExceptionType.badResponse) {
      return handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          data: err.response?.data,
          statusCode: err.response?.statusCode,
          statusMessage: err.response?.statusMessage,
        ),
      );
    } else if (err.response?.statusCode != 200) {
      return handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          data: err.response?.data,
          statusCode: err.response?.statusCode,
          statusMessage: err.response?.statusMessage,
        ),
      );
    } else {
      return handler.next(err);
    }
  }
}
