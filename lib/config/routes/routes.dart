part of 'app_routes.dart';

final _routes = <RouteBase>[
  // Home Route
  GoRoute(
    path: '/${HomePage.routeName}',
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
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
        path: ForgotPasswordPage.routeName,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        // get extra from state
        path: UserDetailPage.routeName,
        builder: (context, state) {
          final userInfo = state.extra as UserInfoEntity;
          return UserDetailPage(userInfo: userInfo);
        },
      ),
      GoRoute(
        path: SettingsPage.routeName,
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: ChangePasswordPage.routeName,
            builder: (context, state) => const ChangePasswordPage(),
          ),
        ],
      ),
    ],
  ),
  // Other routes not in bottom navigation
  GoRoute(
    path: DevPage.routeName,
    builder: (context, state) => const DevPage(),
  ),
];
