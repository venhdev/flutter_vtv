part of 'app_routes.dart';

final _routes = <RouteBase>[
  // Home Route
  GoRoute(
    path: '/home',
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
  ),
  // User Route
  GoRoute(
    path: '/user',
    builder: (BuildContext context, GoRouterState state) {
      return const UserHome(); // contain login page
    },
    routes: [
      GoRoute(
        path: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: 'change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
    ],
  ),
];
