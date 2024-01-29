import 'package:flutter/material.dart';
import 'package:flutter_vtv/features/auth/presentation/pages/change_password_page.dart';
import 'package:go_router/go_router.dart';

import '../../core/pages/intro_page.dart';
import '../../core/pages/main_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/user_page.dart';
import '../../features/home/presentation/home_page.dart';

part 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  static GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE: Set to true for debugging
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
      // Application Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainPage(child: child);
        },
        routes: _routes, // config in routes.dart
      ),
      // Other Route
      GoRoute(
        path: '/intro',
        builder: (BuildContext context, GoRouterState state) {
          return const IntroPage();
        },
      ),
    ],
  );
}
