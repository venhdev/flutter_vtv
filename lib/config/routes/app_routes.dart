import 'package:flutter/material.dart';
import 'package:flutter_vtv/page/intro_page.dart';
import 'package:go_router/go_router.dart';

import '../../page/home_page.dart';

class AppRoutes {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'intro',
            builder: (BuildContext context, GoRouterState state) {
              return const IntroPage();
            },
          ),
        ],
      ),
    ],
  );
}
