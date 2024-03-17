part of 'app_routes.dart';

final _routes = <RouteBase>[
  // Home Route
  GoRoute(
    path: '/${HomePage.routeName}', // '/home'
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
    routes: [
      GoRoute(
        path: ProductDetailPage.routeName, // 'home/product-detail'
        builder: (context, state) {
          final ProductEntity product = state.extra as ProductEntity;
          return ProductDetailPage(product: product);
        },
      ),
      GoRoute(
        path: SearchPage.routeName, // 'home/search'
        builder: (context, state) {
          final String keywords = state.extra as String;
          return SearchPage(keywords: keywords);
        },
      ),
      GoRoute(
        path: CartPage.routeName, // 'home/cart'
        builder: (context, state) {
          return const CartPage();
        },
      ),
    ],
  ),
  // User Route
  GoRoute(
    path: '/${UserHomePage.routeName}', // '/user'
    builder: (BuildContext context, GoRouterState state) {
      return const UserHomePage(); // contain login page
    },
    routes: [
      GoRoute(
        path: LoginPage.routeName, // '/user/login'
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.routeName, // '/user/register'
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: ForgotPasswordPage.routeName, // '/user/forgot-password'
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        // get extra from state
        path: UserDetailPage.routeName, // '/user/detail'
        builder: (context, state) {
          final userInfo = state.extra as UserInfoEntity;
          return UserDetailPage(userInfo: userInfo);
        },
      ),
      GoRoute(
        path: SettingsPage.routeName, // '/user/settings'
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
];
