import '../../../../core/constants/typedef.dart';
import '../entities/notification_resp.dart';

abstract class NotificationRepository {
  FRespData<NotificationResp> getPageNotifications(int page, int size);
}
