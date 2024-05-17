import 'package:dio/dio.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../../../core/constants/customer_api.dart';

abstract class NotificationDataSource {
  Future<SuccessResponse<NotificationPageResp>> getPageNotifications(int page, int size);
  Future<SuccessResponse<NotificationPageResp>> markAsRead(String id);
  Future<SuccessResponse<NotificationPageResp>> deleteNotification(String id);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  NotificationDataSourceImpl(
    this._secureStorage,
    this._dio,
  );

  final Dio _dio;
  final SecureStorageHelper _secureStorage;

  @override
  Future<SuccessResponse<NotificationPageResp>> getPageNotifications(int page, int size) async {
    final url = baseUri(
      path: kAPINotificationGetPageURL,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
      },
    );

    final Response response = await _dio.getUri(
      url,
      options: Options(
        headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken),
      ),
    );

    return handleDioResponse<NotificationPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationPageResp.fromMap(dataMap),
    );
  }

  @override
  Future<SuccessResponse<NotificationPageResp>> markAsRead(String id) async {
    final url = baseUri(
      path: '$kAPINotificationReadURL/$id',
    );

    final Response response = await _dio.putUri(
      url,
      options: Options(
        headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken),
      ),
    );

    return handleDioResponse<NotificationPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationPageResp.fromMap(dataMap),
    );
  }

  @override
  Future<SuccessResponse<NotificationPageResp>> deleteNotification(String id) async {
    final url = baseUri(
      path: '$kAPINotificationDeleteURL/$id',
    );

    final Response response = await _dio.deleteUri(
      url,
      options: Options(
        headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken),
      ),
    );

    return handleDioResponse<NotificationPageResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationPageResp.fromMap(dataMap),
    );
  }
}
