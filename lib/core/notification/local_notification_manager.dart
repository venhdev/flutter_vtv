import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String kDefaultNotificationChannelId = 'default_notification';

class LocalNotificationManager {
  LocalNotificationManager(this._flutterLocalNotificationsPlugin);

  // get instance of flutter_local_notifications
  FlutterLocalNotificationsPlugin get I => _flutterLocalNotificationsPlugin;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> init() async {
    InitializationSettings initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // iOS: DarwinInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  /// Default Notification Details >> single notification
  static const NotificationDetails defaultNotificationDetails = NotificationDetails(
    // androidPlatformChannelSpecifics
    android: AndroidNotificationDetails(
      kDefaultNotificationChannelId,
      'Default Notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    ),
  );

  // Display a default notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin
        .show(
          id,
          title,
          body,
          defaultNotificationDetails,
          payload: payload,
        )
        .onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }
}

// > Retrieving pending notification requests
// <https://pub.dev/packages/flutter_local_notifications#retrieving-pending-notification-requests>
// Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
//   return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
// }
// > Retrieving active notifications #
// <https://pub.dev/packages/flutter_local_notifications#retrieving-active-notifications>
// Future<List<ActiveNotification>> activeNotifications() async {
//   return await _flutterLocalNotificationsPlugin.getActiveNotifications();
// }
