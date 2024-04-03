import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';

import 'package:flutter_vtv/features/notification/domain/entities/notification_resp.dart';

import '../../domain/repository/notification_repository.dart';
import '../data_sources/notification_data_source.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  NotificationRepositoryImpl(this._dataSource);

  final NotificationDataSource _dataSource;

  @override
  FRespData<NotificationResp> getPageNotifications(int page, int size) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () => _dataSource.getPageNotifications(page, size),
    );
  }
}
