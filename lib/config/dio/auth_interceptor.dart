import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../service_locator.dart';

class AuthInterceptor extends QueuedInterceptor {
  final _innerDio = Dio();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    //> add accessToken if needed
    if (options.path.contains('/customer')) {
      final token = await sl<SecureStorageHelper>().accessToken;
      options.headers.addAll(baseHttpHeaders(accessToken: token));
    }

    return handler.next(options);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   log('onResponse: ${response.data}');
  //   handler.next(response);
  // }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //> handle expired token
    //? check if the response is 401 >> get new token - save - retry
    if (err.response?.statusCode == 401 && err.type == DioExceptionType.badResponse) {
      try {
        final refreshToken = await sl<SecureStorageHelper>().refreshToken;
        if (refreshToken == null) {
          if (err.response != null) return handler.resolve(err.response!);
          return handler.reject(err);
        } else {
          final newToken = await getNewAccessToken(refreshToken);
          sl<SecureStorageHelper>().saveOrUpdateAccessToken(newToken);
          err.requestOptions.headers.update('Authorization', (_) => 'Bearer $newToken');
          return handler.resolve(await _retry(err.requestOptions));
        }
      } catch (e) {
        // log('got error when _retry: $e');
        // rethrow;
        // handler.next(err);
        handler.reject(err);
      }
    } else {
      return handler.next(err);
    }
  }

  Future<Response<T>> _retry<T>(RequestOptions requestOptions) {
    return _innerDio.request<T>(
      requestOptions.baseUrl + requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        headers: requestOptions.headers,
        method: requestOptions.method,
      ),
    );
  }

  Future<String> getNewAccessToken(String refreshToken) async {
    final url = baseUri(path: kAPIAuthRefreshTokenURL);
    final resp = await _innerDio.postUri(
      url,
      options: Options(
        headers: baseHttpHeaders(refreshToken: refreshToken),
      ),
    );
    if (resp.statusCode == 200) {
      return resp.data['accessToken'];
    } else {
      throw DioException(
        requestOptions: RequestOptions(path: url.path),
        response: Response(
          statusCode: resp.statusCode,
          data: resp.data,
          requestOptions: RequestOptions(path: url.path),
        ),
      );
    }
  }
}
