part of 'app_routes.dart';

final _routes = <RouteBase>[
  // Home Route --root -> need '/'
  GoRoute(
    path: '/${HomePage.routeName}', // '/home'
    name: HomePage.routeName, // 'home'
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
    routes: [
      GoRoute(
        path: ProductDetailPage.routeName, // 'home/product-detail'
        name: ProductDetailPage.routeName, // product-detail
        builder: (context, state) {
          final ProductEntity product = state.extra as ProductEntity;
          return ProductDetailPage(product: product);
        },
      ),
      GoRoute(
        path: SearchPage.routeName, // 'home/search'
        name: SearchPage.routeName, // search
        builder: (context, state) {
          final String keywords = state.extra as String;
          return SearchPage(keywords: keywords);
        },
      ),
      GoRoute(
        path: CartPage.routeName, // 'home/cart'
        name: CartPage.routeName,
        builder: (context, state) {
          return const CartPage();
        },
        routes: [
          GoRoute(
            path: AddressPage.routeName, // 'home/cart/address'
            name: AddressPage.routeName,
            builder: (context, state) {
              return const AddressPage();
            },
            routes: [
              GoRoute(
                path: AddAddressPage.routeName, // 'home/cart/address/add'
                name: AddAddressPage.routeName,
                builder: (context, state) {
                  return const AddAddressPage();
                },
              ),
            ],
          ),
          GoRoute(
            path: CheckoutPage.routeName, // 'home/cart/checkout'
            name: CheckoutPage.routeName,
            builder: (context, state) {
              final List<String> cartIds = state.extra as List<String>;
              return CheckoutPage(cartIds: cartIds);
            },
          ),
        ],
      ),
    ],
  ),
  // User Route
  GoRoute(
    path: '/${UserHomePage.routeName}', // '/user'
    name: UserHomePage.routeName, // 'user'
    builder: (BuildContext context, GoRouterState state) {
      return const UserHomePage(); // contain login page
    },
    routes: [
      GoRoute(
        path: LoginPage.routeName, // '/user/login'
        name: LoginPage.routeName, // login
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.routeName, // '/user/register'
        name: RegisterPage.routeName, // register
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: ForgotPasswordPage.routeName, // '/user/forgot-password'
        name: ForgotPasswordPage.routeName, // forgot-password
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        // get extra from state
        path: UserDetailPage.routeName, // '/user/detail'
        name: UserDetailPage.routeName, // user-detail
        builder: (context, state) {
          final userInfo = state.extra as UserInfoEntity;
          return UserDetailPage(userInfo: userInfo);
        },
      ),
      GoRoute(
        path: SettingsPage.routeName, // '/user/settings'
        name: SettingsPage.routeName, // settings
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: ChangePasswordPage.routeName, // '/user/settings/change-password'
            name: ChangePasswordPage.routeName, // change-password
            builder: (context, state) => const ChangePasswordPage(),
          ),
        ],
      ),
    ],
  ),
];
