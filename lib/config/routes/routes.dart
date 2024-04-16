import 'package:flutter/material.dart';
import 'package:flutter_vtv/config/routes/extra_codec.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../core/presentation/pages/dev_page.dart';
import '../../core/presentation/pages/intro_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/pages/favorite_product_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/product_detail_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../../features/order/presentation/pages/checkout_page.dart';
import '../../features/order/presentation/pages/order_detail_page.dart';
import '../../features/order/presentation/pages/purchase_page.dart';
import '../../features/order/presentation/pages/review_add_page.dart';
import '../../features/order/presentation/pages/review_details_by_order_page.dart';
import '../../features/order/presentation/pages/voucher_page.dart';
import '../../features/profile/presentation/pages/add_address_page.dart';
import '../../features/profile/presentation/pages/address_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/user_detail_page.dart';
import '../../features/profile/presentation/pages/user_page.dart';
import 'scaffold_with_navbar.dart';

// config bottom navigation bar in 'lib\core\presentation\pages\main_page.dart'

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionHomeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionHomeNav');
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  // static GoRouter router = GoRouter(
  //   debugLogDiagnostics: true, // NOTE: dev
  //   navigatorKey: _rootNavigatorKey,
  //   initialLocation: '/home',
  //   extraCodec: const MyExtraCodec(),
  //   routes: <RouteBase>[
  //     GoRoute(
  //       path: '/',
  //       redirect: (context, state) => '/home',
  //     ),
  //     // Application Shell
  //     ShellRoute(
  //       navigatorKey: _shellNavigatorKey,
  //       builder: (BuildContext context, GoRouterState state, Widget child) {
  //         return ScaffoldWithNavBar(child: child);
  //       },
  //       routes: _routes,
  //     ),
  //     // Other Route not in Shell (not in bottom navigation bar)
  //     GoRoute(
  //       path: '/intro',
  //       builder: (BuildContext context, GoRouterState state) {
  //         return const IntroPage();
  //       },
  //     ),
  //     GoRoute(
  //       path: DevPage.routeName, // '/dev'
  //       builder: (context, state) => const DevPage(),
  //     ),
  //   ],
  // );

  //! if want to hide bottom navigation bar >> add: parentNavigatorKey: _rootNavigatorKey,
  static GoRouter router2 = GoRouter(
    debugLogDiagnostics: true, // NOTE: dev
    navigatorKey: _rootNavigatorKey,
    extraCodec: const MyExtraCodec(),
    initialLocation: '/home',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          // Return the widget that implements the custom shell (in this case
          // using a BottomNavigationBar). The StatefulNavigationShell is passed
          // to be able access the state of the shell and to navigate to other
          // branches in a stateful way.
          return ScaffoldWithNavBar2(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          //! Home Route
          // The route branch for the first tab of the bottom navigation bar.
          StatefulShellBranch(
            navigatorKey: _sectionHomeNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: HomePage.routeRoot, // '/home'
                name: HomePage.routeName, // home
                builder: (BuildContext context, GoRouterState state) {
                  return const HomePage();
                },
                routes: [
                  GoRoute(
                    path: ProductDetailPage.routeName, // 'home/product'
                    name: ProductDetailPage.routeName, // product
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final extraData = state.extra;
                      if (extraData is ProductDetailResp) {
                        return ProductDetailPage(productDetail: extraData);
                      } else {
                        return ProductDetailPage(productId: extraData as int);
                      }
                    },
                  ),
                  GoRoute(
                    path: SearchPage.routeName, // '/home/search' ?q=keywords
                    name: SearchPage.routeName, // search
                    builder: (context, state) {
                      // final String keywords = state.extra as String;
                      final String keywords = state.uri.queryParameters['q'] ?? '';
                      return SearchPage(keywords: keywords);
                    },
                  ),
                  GoRoute(
                    path: CartPage.routeName, // '/home/cart'
                    name: CartPage.routeName,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      return const CartPage();
                    },
                    routes: [
                      GoRoute(
                        path: CheckoutPage.routeName, // '/home/cart/checkout' ?isCreateWithCart=true|false
                        name: CheckoutPage.routeName,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final order = state.extra as OrderEntity;
                          final String? type = state.uri.queryParameters['isCreateWithCart'];
                          //! if isCreateWithCart is null => true
                          final bool isCreateWithCart = type == null ? true : type == 'true';
                          return CheckoutPage(order: order, isCreateWithCart: isCreateWithCart);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          //! Notification Route
          // The route branch for the second tab of the bottom navigation bar.
          StatefulShellBranch(
            // It's not necessary to provide a navigatorKey if it isn't also
            // needed elsewhere. If not provided, a default key will be used.
            routes: <RouteBase>[
              GoRoute(
                path: NotificationPage.routeRoot, // '/notification'
                name: NotificationPage.routeName, // 'notification'
                builder: (BuildContext context, GoRouterState state) {
                  return const NotificationPage();
                },
              ),
            ],
          ),
          //! User Route
          // The route branch for the third tab of the bottom navigation bar.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: UserPage.routeRoot, // '/user'
                name: UserPage.routeName, // 'user'
                builder: (BuildContext context, GoRouterState state) {
                  return const UserPage(); // contain login page
                },
                routes: [
                  GoRoute(
                      path: LoginPage.routeName, // '/user/login'
                      name: LoginPage.routeName, // login
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) => const LoginPage(),
                      routes: [
                        GoRoute(
                          path: ForgotPasswordPage.routeName, // '/user/login/forgot-password'
                          parentNavigatorKey: _rootNavigatorKey,
                          name: ForgotPasswordPage.routeName, // forgot-password
                          builder: (context, state) => const ForgotPasswordPage(),
                        ),
                      ]),
                  GoRoute(
                    path: RegisterPage.routeName, // '/user/register'
                    name: RegisterPage.routeName, // register
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const RegisterPage(),
                  ),

                  GoRoute(
                    // get extra from state
                    path: UserDetailPage.routeName, // '/user/detail'
                    name: UserDetailPage.routeName, // user-detail
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final userInfo = state.extra as UserInfoEntity;
                      return UserDetailPage(userInfo: userInfo);
                    },
                  ),
                  GoRoute(
                    path: VoucherPage.routeName, // '/user/voucher'
                    name: VoucherPage.routeName, // voucher
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const VoucherPage(),
                  ),
                  GoRoute(
                    path: FavoriteProductPage.routeName, // '/user/favorite-product'
                    name: FavoriteProductPage.routeName, // voucher
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const FavoriteProductPage(),
                  ),
                  GoRoute(
                    path: PurchasePage.routeName, // '/user/purchase'
                    name: PurchasePage.routeName, // purchase
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const PurchasePage(),
                    routes: [
                      GoRoute(
                        path: OrderDetailPage.routeName, // '/user/purchase/order-detail'
                        name: OrderDetailPage.routeName, // order-detail
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final OrderDetailEntity order = state.extra as OrderDetailEntity;
                          return OrderDetailPage(orderDetail: order);
                        },
                        routes: [
                          GoRoute(
                            path: ReviewAddPage.routeName, // '/user/purchase/order-detail/review-add'
                            name: ReviewAddPage.routeName, // review-add
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) {
                              final orderItemId = state.extra as OrderEntity;
                              return ReviewAddPage(order: orderItemId);
                            },
                          ),
                          GoRoute(
                            path: ReviewDetailsByOrderPage.routeName, // '/user/purchase/order-detail/review-detail'
                            name: ReviewDetailsByOrderPage.routeName, // review-detail
                            parentNavigatorKey: _rootNavigatorKey,
                            builder: (context, state) {
                              final orderItemId = state.extra as OrderEntity;
                              return ReviewDetailsByOrderPage(order: orderItemId);
                            },
                          ),
                        ],
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
                          final bool? willPopOnChanged = state.extra as bool?;
                          return AddressPage(willPopOnChanged: willPopOnChanged ?? true);
                        },
                        routes: [
                          GoRoute(
                            path: AddOrUpdateAddressPage.routeNameAdd, // 'user/settings/address/add-address'
                            name: AddOrUpdateAddressPage.routeNameAdd,
                            builder: (context, state) {
                              return const AddOrUpdateAddressPage();
                            },
                          ),
                          GoRoute(
                            path: AddOrUpdateAddressPage.routeNameUpdate, // 'user/settings/address/update-address'
                            name: AddOrUpdateAddressPage.routeNameUpdate,
                            builder: (context, state) {
                              final address = state.extra as AddressEntity;
                              return AddOrUpdateAddressPage(address: address);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Other Route not in Shell (not appear in bottom navigation bar)
      GoRoute(
        path: '/intro',
        builder: (BuildContext context, GoRouterState state) {
          return const IntroPage();
        },
      ),
      GoRoute(
        path: DevPage.routeName, // '/dev'
        builder: (context, state) => const DevPage(),
      ),
    ],
  );
}

// final _routes = <RouteBase>[
//   //! Home Route --root -> need '/'
//   GoRoute(
//     path: HomePage.routeRoot, // '/home'
//     name: HomePage.routeName, // home
//     parentNavigatorKey: _shellNavigatorKey,
//     builder: (BuildContext context, GoRouterState state) {
//       return const HomePage();
//     },
//     routes: [
//       GoRoute(
//         path: ProductDetailPage.routeName, // 'home/product'
//         name: ProductDetailPage.routeName, // product
//         parentNavigatorKey: _shellNavigatorKey,
//         builder: (context, state) {
//           final extraData = state.extra;
//           if (extraData is ProductDetailResp) {
//             return ProductDetailPage(productDetail: extraData);
//           } else {
//             return ProductDetailPage(productId: extraData as int);
//           }
//         },
//       ),
//       GoRoute(
//         path: SearchPage.routeName, // '/home/search' ?q=keywords
//         name: SearchPage.routeName, // search
//         builder: (context, state) {
//           // final String keywords = state.extra as String;
//           final String keywords = state.uri.queryParameters['q'] ?? '';
//           return SearchPage(keywords: keywords);
//         },
//       ),
//       GoRoute(
//         path: CartPage.routeName, // '/home/cart'
//         name: CartPage.routeName,
//         builder: (context, state) {
//           return const CartPage();
//         },
//         routes: [
//           GoRoute(
//             path: CheckoutPage.routeName, // '/home/cart/checkout' ?isCreateWithCart=true|false
//             name: CheckoutPage.routeName,
//             builder: (context, state) {
//               final order = state.extra as OrderEntity;
//               final String? type = state.uri.queryParameters['isCreateWithCart'];
//               //! if isCreateWithCart is null => true
//               final bool isCreateWithCart = type == null ? true : type == 'true';
//               return CheckoutPage(order: order, isCreateWithCart: isCreateWithCart);
//             },
//           ),
//         ],
//       ),
//     ],
//   ),
//   //! Notification Route
//   GoRoute(
//     path: NotificationPage.routeRoot, // '/notification'
//     name: NotificationPage.routeName, // 'notification'
//     builder: (BuildContext context, GoRouterState state) {
//       return const NotificationPage();
//     },
//   ),
//   //! User Route
//   GoRoute(
//     path: UserPage.routeRoot, // '/user'
//     name: UserPage.routeName, // 'user'
//     builder: (BuildContext context, GoRouterState state) {
//       return const UserPage(); // contain login page
//     },
//     routes: [
//       GoRoute(
//           path: LoginPage.routeName, // '/user/login'
//           name: LoginPage.routeName, // login
//           builder: (context, state) => const LoginPage(),
//           routes: [
//             GoRoute(
//               path: ForgotPasswordPage.routeName, // '/user/login/forgot-password'
//               name: ForgotPasswordPage.routeName, // forgot-password
//               builder: (context, state) => const ForgotPasswordPage(),
//             ),
//           ]),
//       GoRoute(
//         path: RegisterPage.routeName, // '/user/register'
//         name: RegisterPage.routeName, // register
//         builder: (context, state) => const RegisterPage(),
//       ),

//       GoRoute(
//         // get extra from state
//         path: UserDetailPage.routeName, // '/user/detail'
//         name: UserDetailPage.routeName, // user-detail
//         builder: (context, state) {
//           final userInfo = state.extra as UserInfoEntity;
//           return UserDetailPage(userInfo: userInfo);
//         },
//       ),
//       GoRoute(
//         path: VoucherPage.routeName, // '/user/voucher'
//         name: VoucherPage.routeName, // voucher
//         builder: (context, state) => const VoucherPage(),
//       ),
//       GoRoute(
//         path: PurchasePage.routeName, // '/user/purchase'
//         name: PurchasePage.routeName, // purchase
//         builder: (context, state) => const PurchasePage(),
//         routes: [
//           GoRoute(
//             path: OrderDetailPage.routeName, // '/user/purchase/order-detail'
//             name: OrderDetailPage.routeName, // order-detail
//             builder: (context, state) {
//               final OrderDetailEntity order = state.extra as OrderDetailEntity;
//               return OrderDetailPage(orderDetail: order);
//             },
//           ),
//         ],
//       ),
//       //! Setting
//       GoRoute(
//         path: SettingsPage.routeName, // '/user/settings'
//         name: SettingsPage.routeName, // settings
//         builder: (context, state) => const SettingsPage(),
//         routes: [
//           GoRoute(
//             path: ChangePasswordPage.routeName, // '/user/settings/change-password'
//             name: ChangePasswordPage.routeName, // change-password
//             builder: (context, state) => const ChangePasswordPage(),
//           ),
//           GoRoute(
//             path: AddressPage.routeName, // 'user/settings/address'
//             name: AddressPage.routeName,
//             builder: (context, state) {
//               return const AddressPage();
//             },
//             routes: [
//               GoRoute(
//                 path: AddAddressPage.routeName, // 'user/settings/address/add-address'
//                 name: AddAddressPage.routeName,
//                 builder: (context, state) {
//                   return const AddAddressPage();
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   ),
// ];
