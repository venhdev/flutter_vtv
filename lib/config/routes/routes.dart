part of 'app_routes.dart';

final _routes = <RouteBase>[
  // Home Route --root -> need '/'
  GoRoute(
    path: '/${HomePage.pathName}', // '/home'
    name: HomePage.routeName, // 'home'
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
    routes: [
      GoRoute(
        path: ProductDetailPage.pathName, // 'home/product-detail'
        name: ProductDetailPage.routeName, // product-detail
        builder: (context, state) {
          final ProductEntity product = state.extra as ProductEntity;
          return ProductDetailPage(product: product);
        },
      ),
      GoRoute(
        path: SearchPage.pathName, // 'home/search'
        name: SearchPage.routeName, // search
        builder: (context, state) {
          final String keywords = state.extra as String;
          return SearchPage(keywords: keywords);
        },
      ),
      GoRoute(
        path: CartPage.pathName, // 'home/cart'
        name: CartPage.routeName,
        builder: (context, state) {
          return const CartPage();
        },
        routes: [
          GoRoute(
            path: AddressPage.pathName, // 'home/cart/address'
            name: AddressPage.pathName,
            builder: (context, state) {
              return const AddressPage();
            },
            routes: [
              GoRoute(
                path: AddAddressPage.pathName, // 'home/cart/address/add'
                name: AddAddressPage.routeName,
                builder: (context, state) {
                  return const AddAddressPage();
                },
              ),
            ],
          ),
          // GoRoute(
          //   path: PaymentPage.routeName, // 'home/cart/payment'
          //   builder: (context, state) {
          //     return const PaymentPage();
          //   },
          // ),
        ],
      ),
    ],
  ),
  // User Route
  GoRoute(
    path: '/${UserHomePage.pathName}', // '/user'
    name: UserHomePage.routeName, // 'user'
    builder: (BuildContext context, GoRouterState state) {
      return const UserHomePage(); // contain login page
    },
    routes: [
      GoRoute(
        path: LoginPage.pathName, // '/user/login'
        name: LoginPage.routeName, // login
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.pathName, // '/user/register'
        name: RegisterPage.routeName, // register
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: ForgotPasswordPage.pathName, // '/user/forgot-password'
        name: ForgotPasswordPage.routeName, // forgot-password
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        // get extra from state
        path: UserDetailPage.pathName, // '/user/detail'
        name: UserDetailPage.routeName, // user-detail
        builder: (context, state) {
          final userInfo = state.extra as UserInfoEntity;
          return UserDetailPage(userInfo: userInfo);
        },
      ),
      GoRoute(
        path: SettingsPage.pathName, // '/user/settings'
        name: SettingsPage.routeName, // settings
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path:
                ChangePasswordPage.pathName, // '/user/settings/change-password'
            name: ChangePasswordPage.routeName, // change-password
            builder: (context, state) => const ChangePasswordPage(),
          ),
        ],
      ),
    ],
  ),
];
