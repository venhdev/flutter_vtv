import 'package:vtv_common/core.dart';
import 'package:vtv_common/notification.dart';

abstract class NotificationRepository {
  FRespData<NotificationResp> getPageNotifications(int page, int size);
  FRespData<NotificationResp> markAsRead(String id);
  FRespData<NotificationResp> deleteNotification(String id);
}
