import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/pages/intro_page.dart';
import '../../core/pages/main_page.dart';
import '../../features/auth/presentation/screens/user_page.dart';
import '../../features/home/presentation/home_page.dart';

part 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  static GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE: Set to true for debugging
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: <RouteBase>[
      // Application Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainPage(child: child);
        },
        routes: _routes,
      ),
    ],
  );
}
