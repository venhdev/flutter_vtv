import 'package:flutter_vtv/core/helpers/secure_storage_helper.dart';
import 'package:flutter_vtv/core/network/base_response.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api.dart';
import '../../domain/entities/notification_resp.dart';

abstract class NotificationDataSource {
  Future<DataResponse<NotificationResp>> getPageNotifications(int page, int size);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  NotificationDataSourceImpl(this._client, this._secureStorage);

  final http.Client _client;
  final SecureStorageHelper _secureStorage;

  @override
  Future<DataResponse<NotificationResp>> getPageNotifications(int page, int size) async {
    final response = await _client.get(
      baseUri(
        path: kAPINotificationGetPageURL,
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      ),
      headers: baseHttpHeaders(accessToken: await _secureStorage.accessToken),
    );

    return handleResponseWithData<NotificationResp>(
      response,
      kAPINotificationGetPageURL,
      (dataMap) => NotificationResp.fromMap(dataMap),
    );
  }
}
