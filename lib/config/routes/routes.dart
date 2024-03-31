part of 'app_routes.dart';

final _routes = <RouteBase>[
  //! Home Route --root -> need '/'
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
        path: SearchPage.routeName, // '/home/search'
        name: SearchPage.routeName, // search
        builder: (context, state) {
          final String keywords = state.extra as String;
          return SearchPage(keywords: keywords);
        },
      ),
      GoRoute(
        path: CartPage.routeName, // '/home/cart'
        name: CartPage.routeName,
        builder: (context, state) {
          return const CartPage();
        },
        routes: [
          GoRoute(
            path: CheckoutPage.routeName, // '/home/cart/checkout'
            name: CheckoutPage.routeName,
            builder: (context, state) {
              final order = state.extra as OrderEntity;
              final String? type = state.uri.queryParameters['isCreateWithCart'];
              //! Default if isCreateWithCart null then isCreateWithCart is true
              final bool isCreateWithCart = type == null ? true : type == 'true';
              return CheckoutPage(order: order, isCreateWithCart: isCreateWithCart);
            },
          ),
        ],
      ),
    ],
  ),
  //! User Route
  GoRoute(
    path: '/${UserPage.routeName}', // '/user'
    name: UserPage.routeName, // 'user'
    builder: (BuildContext context, GoRouterState state) {
      return const UserPage(); // contain login page
    },
    routes: [
      GoRoute(
          path: LoginPage.routeName, // '/user/login'
          name: LoginPage.routeName, // login
          builder: (context, state) => const LoginPage(),
          routes: [
            GoRoute(
              path: ForgotPasswordPage.routeName, // '/user/login/forgot-password'
              name: ForgotPasswordPage.routeName, // forgot-password
              builder: (context, state) => const ForgotPasswordPage(),
            ),
          ]),
      GoRoute(
        path: RegisterPage.routeName, // '/user/register'
        name: RegisterPage.routeName, // register
        builder: (context, state) => const RegisterPage(),
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
        path: VoucherPage.routeName, // '/user/voucher'
        name: VoucherPage.routeName, // voucher
        builder: (context, state) => const VoucherPage(),
      ),
      GoRoute(
        path: PurchasePage.routeName, // '/user/purchase'
        name: PurchasePage.routeName, // purchase
        builder: (context, state) => const PurchasePage(),
        routes: [
          GoRoute(
            path: OrderDetailPage.routeName, // '/user/purchase/order-detail'
            name: OrderDetailPage.routeName, // order-detail
            builder: (context, state) {
              final OrderEntity order = state.extra as OrderEntity;
              return OrderDetailPage(order: order);
            },
          ),
        ],
      ),
      //! Setting
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
          GoRoute(
            path: AddressPage.routeName, // 'user/settings/address'
            name: AddressPage.routeName,
            builder: (context, state) {
              return const AddressPage();
            },
            routes: [
              GoRoute(
                path: AddAddressPage.routeName, // 'user/settings/address/add-address'
                name: AddAddressPage.routeName,
                builder: (context, state) {
                  return const AddAddressPage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
