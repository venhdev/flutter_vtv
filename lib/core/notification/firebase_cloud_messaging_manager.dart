import 'dart:developer';
import 'dart:math' show Random;

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../service_locator.dart';
import 'local_notification_manager.dart';

// foreground message handler
void _foregroundMessageHandler(RemoteMessage message) {
  try {
    log('Got a message whilst in the foreground!');

    if (message.notification != null) {
      handleShowPushNotification(message);
    }
  } catch (e) {
    log('_foregroundMessageHandler Exception: type: ${e.runtimeType.toString()} -- ${e.toString()}');
  }
}

/// There are a few things to keep in mind about your background message handler:
/// 1. It must not be an anonymous function.
/// 2. It must be a top-level function (e.g. not a class method which requires initialization).
/// 3. When using Flutter version 3.3.0 or higher, the message handler must be annotated with @pragma('vm:entry-point') right above the function declaration (otherwise it may be removed during tree shaking for release mode).
/// see: https://firebase.google.com/docs/cloud-messaging/flutter/receive
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  log('Got a message whilst in the background!');
  handleShowPushNotification(message);
}

class FirebaseCloudMessagingManager {
  FirebaseCloudMessagingManager(this._firebaseMessaging);

  final FirebaseMessaging _firebaseMessaging;
  get I => _firebaseMessaging;
  String? currentFCMToken;

  Future<void> init() async {
    // request permission from user (will show prompt dialog)

    // You may set the permission requests to "provisional" which allows the user to choose what type
    // of notifications they would like to receive once the user receives a notification.
    // https://firebase.flutter.dev/docs/messaging/permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('[FCM] User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('[FCM] User granted provisional permission');
    } else {
      log('[FCM] User declined or has not accepted permission');
    }

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    currentFCMToken = fCMToken;
    // debugPrint('FCM Token: $fCMToken');

    // foreground message handler
    FirebaseMessaging.onMessage.listen(_foregroundMessageHandler);
    // background message handler
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    log('[Firebase Messaging] init completed');
  }
}

void handleShowPushNotification(RemoteMessage message) {
  sl<LocalNotificationManager>().showNotification(
    id: Random().nextInt(1000),
    title: message.notification?.title ?? 'No title',
    body: message.notification?.body ?? 'No body',
    payload: message.data.toString(),
  );
}
