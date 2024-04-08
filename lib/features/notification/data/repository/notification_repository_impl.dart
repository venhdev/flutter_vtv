
import 'package:vtv_common/vtv_common.dart';

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
