import 'package:vtv_common/vtv_common.dart';

abstract class NotificationRepository {
  FRespData<NotificationResp> getPageNotifications(int page, int size);
  FRespData<NotificationResp> markAsRead(String id);
  FRespData<NotificationResp> deleteNotification(String id);
}
