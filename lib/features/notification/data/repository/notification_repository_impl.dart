import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

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

  @override
  FRespData<NotificationResp> markAsRead(String id) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () => _dataSource.markAsRead(id),
    );
  }

  @override
  FRespData<NotificationResp> deleteNotification(String id) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () => _dataSource.deleteNotification(id),
    );
  }
}
