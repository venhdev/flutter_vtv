part of 'app_routes.dart';

final _routes = <RouteBase>[
  // Home Route
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
  ),
  // User Route
  GoRoute(
    path: '/user',
    builder: (BuildContext context, GoRouterState state) {
      return const UserPage();
    },
  ),
  // Other Route
  GoRoute(
    path: '/intro',
    builder: (BuildContext context, GoRouterState state) {
      return const IntroPage();
    },
  ),
];
