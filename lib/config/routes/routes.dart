part of 'app_routes.dart';

final _routes = <RouteBase>[
  // Home Route
  GoRoute(
    path: '/${HomePage.routeName}', // '/home'
    builder: (BuildContext context, GoRouterState state) {
      return HomePage();
    },
    routes: [
      GoRoute(
        path: ProductDetailPage.routeName, // '/home/product-detail'
        builder: (context, state) {
          final product = state.extra as ProductEntity;
          return ProductDetailPage(product: product);
        },
      ),
      GoRoute(
        path: SearchProductsPage.routeName,  // 'home/search'
        builder: (context, state) {
          final String keywords = state.extra as String;

          return SearchProductsPage(
            keywords: keywords,
          );
        },
        routes: [
          GoRoute(
            path: ProductDetailPage.routeName, // 'home/search-product/product-detail'
            builder: (context, state) {
              final product = state.extra as ProductEntity;
              return ProductDetailPage(product: product);
            },
          ),
        ],
      ),

    ],
  ),
  // User Route
  GoRoute(
    path: '/${UserHome.routeName}', // '/user'
    builder: (BuildContext context, GoRouterState state) {
      return const UserHome(); // contain login page
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
