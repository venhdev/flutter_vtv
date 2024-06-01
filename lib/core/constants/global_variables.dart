import 'package:flutter/widgets.dart';

/// Global Variables
class GlobalVariables {
  /// This global key is used in material app for navigation through firebase cloud messaging
  static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>(debugLabel: 'root');

  /// This global variable is used to store the current route name
  static String? currentRoute;

  /// This global variable is used to store the current opened chat room id
  static String? currentChatRoomId;
}
