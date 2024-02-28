part of 'app_routes.dart';

final _routes = <RouteBase>[
  // Home Route
  GoRoute(
    path: '/${ShopPage.routeName}',
    builder: (BuildContext context, GoRouterState state) {
      return const ShopPage();
    },
  ),
  // User Route
  GoRoute(
    path: '/${UserHome.routeName}',
    builder: (BuildContext context, GoRouterState state) {
      return const UserHome(); // contain login page
    },
    routes: [
      GoRoute(
        path: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.routeName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: ChangePasswordPage.routeName,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: ForgotPasswordPage.routeName,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: SettingsPage.routeName,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  ),
];
