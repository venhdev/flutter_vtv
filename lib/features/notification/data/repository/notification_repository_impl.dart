import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

import '../../domain/repository/notification_repository.dart';
import '../data_sources/notification_data_source.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  NotificationRepositoryImpl(this._dataSource);

  final NotificationDataSource _dataSource;

  @override
  FRespData<NotificationPageResp> getPageNotifications(int page, int size) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () => _dataSource.getPageNotifications(page, size),
    );
  }

  @override
  FRespData<NotificationPageResp> markAsRead(String id) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () => _dataSource.markAsRead(id),
    );
  }

  @override
  FRespData<NotificationPageResp> deleteNotification(String id) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () => _dataSource.deleteNotification(id),
    );
  }
}
