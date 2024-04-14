import 'package:dio/dio.dart';
import 'package:vtv_common/vtv_common.dart';

abstract class NotificationDataSource {
  Future<DataResponse<NotificationResp>> getPageNotifications(int page, int size);
  Future<DataResponse<NotificationResp>> markAsRead(String id);
  Future<DataResponse<NotificationResp>> deleteNotification(String id);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  NotificationDataSourceImpl(
    this._secureStorage,
    this._dio,
  );

  final Dio _dio;
  final SecureStorageHelper _secureStorage;

  @override
  Future<DataResponse<NotificationResp>> getPageNotifications(int page, int size) async {
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

    return handleDioResponseWithData<NotificationResp>(
      response,
      url,
      (dataMap) => NotificationResp.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<NotificationResp>> markAsRead(String id) async {
    final url = baseUri(
      path: '$kAPINotificationReadURL/$id',
    );

    final Response response = await _dio.putUri(
      url,
      options: Options(
        headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken),
      ),
    );

    return handleDioResponseWithData(
      response,
      url,
      (dataMap) => NotificationResp.fromMap(dataMap),
    );
  }

  @override
  Future<DataResponse<NotificationResp>> deleteNotification(String id) async {
    final url = baseUri(
      path: '$kAPINotificationDeleteURL/$id',
    );

    final Response response = await _dio.deleteUri(
      url,
      options: Options(
        headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken),
      ),
    );

    return handleDioResponseWithData(
      response,
      url,
      (dataMap) => NotificationResp.fromMap(dataMap),
    );
  }
}
