import 'package:dio/dio.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../core/constants/customer_apis.dart';

abstract class NotificationDataSource {
  Future<SuccessResponse<NotificationResp>> getPageNotifications(int page, int size);
  Future<SuccessResponse<NotificationResp>> markAsRead(String id);
  Future<SuccessResponse<NotificationResp>> deleteNotification(String id);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  NotificationDataSourceImpl(
    this._secureStorage,
    this._dio,
  );

  final Dio _dio;
  final SecureStorageHelper _secureStorage;

  @override
  Future<SuccessResponse<NotificationResp>> getPageNotifications(int page, int size) async {
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

    return handleDioResponse<NotificationResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationResp.fromMap(dataMap),
    );
  }

  @override
  Future<SuccessResponse<NotificationResp>> markAsRead(String id) async {
    final url = baseUri(
      path: '$kAPINotificationReadURL/$id',
    );

    final Response response = await _dio.putUri(
      url,
      options: Options(
        headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken),
      ),
    );

    return handleDioResponse<NotificationResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationResp.fromMap(dataMap),
    );
  }

  @override
  Future<SuccessResponse<NotificationResp>> deleteNotification(String id) async {
    final url = baseUri(
      path: '$kAPINotificationDeleteURL/$id',
    );

    final Response response = await _dio.deleteUri(
      url,
      options: Options(
        headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken),
      ),
    );

    return handleDioResponse<NotificationResp, Map<String, dynamic>>(
      response,
      url,
      parse: (dataMap) => NotificationResp.fromMap(dataMap),
    );
  }
}
