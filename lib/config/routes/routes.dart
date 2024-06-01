import 'package:flutter/material.dart';
import 'package:flutter_vtv/app_state.dart';
import 'package:flutter_vtv/config/routes/extra_codec.dart';
import 'package:flutter_vtv/features/order/presentation/pages/checkout_multiple_order_page.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/dev.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/order.dart';

import '../../core/constants/global_variables.dart';
import '../../core/presentation/pages/intro_page.dart';
import '../../features/auth/presentation/customer_change_password_page.dart';
import '../../features/auth/presentation/customer_forgot_password_page.dart';
import '../../features/auth/presentation/customer_login_page.dart';
import '../../features/auth/presentation/customer_register_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/chat/presentation/pages/customer_chat_page.dart';
import '../../features/chat/presentation/pages/customer_chat_room_page.dart';
import '../../features/home/presentation/pages/category_page.dart';
import '../../features/home/presentation/pages/favorite_products_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/product_detail_page.dart';
import '../../features/home/presentation/pages/product_reviews_page.dart';
import '../../features/home/presentation/pages/review_detail_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/home/presentation/pages/shop_page.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../../features/order/domain/dto/webview_payment_param.dart';
import '../../features/order/presentation/pages/add_review_page.dart';
import '../../features/order/presentation/pages/checkout_page.dart';
import '../../features/order/presentation/pages/customer_order_detail_page.dart';
import '../../features/order/presentation/pages/customer_order_purchase_page.dart';
import '../../features/order/presentation/pages/order_reviews_page.dart';
import '../../features/order/presentation/pages/vnpay_webview.dart';
import '../../features/order/presentation/pages/voucher_collection_page.dart';
import '../../features/order/presentation/pages/voucher_page.dart';
import '../../features/profile/presentation/components/logged_widget.dart';
import '../../features/profile/presentation/pages/address_page.dart';
import '../../features/profile/presentation/pages/customer_wallet_history_page.dart';
import '../../features/profile/presentation/pages/followed_shop_page.dart';
import '../../features/profile/presentation/pages/loyalty_point_history_page.dart';
import '../../features/profile/presentation/pages/my_voucher_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/user_detail_page.dart';
import '../../features/profile/presentation/pages/user_page.dart';
import '../../service_locator.dart';
import 'scaffold_with_navbar.dart';

//! config bottom navigation bar in '/lib/config/routes/scaffold_with_navbar.dart'

// final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalVariables.navigatorState;
final GlobalKey<NavigatorState> _sectionHomeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionHomeNav');
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  //! if want to hide bottom navigation bar >> add: parentNavigatorKey: _rootNavigatorKey,
  static GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE: dev
    navigatorKey: _rootNavigatorKey,
    extraCodec: const MyExtraCodec(),
    initialLocation: '/home',
    // log the new route
    observers: [
      CustomRouteObserver(
        onRouteChanged: (newRoute, previousRoute) {
          GlobalVariables.currentRoute = newRoute?.settings.name;
        },
      )
    ],
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          // Return the widget that implements the custom shell (in this case
          // using a BottomNavigationBar). The StatefulNavigationShell is passed
          // to be able access the state of the shell and to navigate to other
          // branches in a stateful way.
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          //! Home Route
          _homeRoutes(),
          //! Notification Route
          _notificationRoutes(),
          //! User Route
          _userRoutes(),
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
        path: '/dev', // DevPage.routeName, // '/dev'
        builder: (context, state) => DevPage(sl: sl, onBackPressed: () => context.go('/home')),
      ),
      GoRoute(
        path: '/dev-string', // DevPage.routeName, // '/dev'
        builder: (context, state) => DevPageWithString(
          string: state.extra as String?,
        ),
      ),
      GoRoute(
        path: '/:any',
        // builder: (context, state) => Container(color: AppColors.pageBackground),
        redirect: (context, state) {
          // Unsupported path, we redirect it to /, which redirects it to /line
          return '/';
        },
      ),
    ],
  );

  static StatefulShellBranch _userRoutes() {
    return StatefulShellBranch(
      routes: <RouteBase>[
        GoRoute(
          path: UserPage.routeRoot, // '/user'
          name: UserPage.routeName, // 'user'
          builder: (BuildContext context, GoRouterState state) {
            return const UserPage(); // contain login page
          },
          routes: [
            // chat room
            GoRoute(
                path: CustomerChatRoomPage.routeName, // '/user/chat-room'
                name: CustomerChatRoomPage.routeName, // chat-room
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const CustomerChatRoomPage(),
                routes: [
                  GoRoute(
                    path: CustomerChatPage.routeName, // '/user/chat-room/chat' ?roomChatId=...&receiverUsername=...
                    name: CustomerChatPage.routeName, // chat
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final room = state.extra as ChatRoomEntity;
                      return CustomerChatPage(room: room);
                    },
                  ),
                ]),

            // login
            GoRoute(
                // path: LoginPage.routeName, // '/user/login'
                // name: LoginPage.routeName, // login
                path: CustomerLoginPage.routeName,
                name: CustomerLoginPage.routeName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const CustomerLoginPage(),
                routes: [
                  GoRoute(
                    path: CustomerForgotPasswordPage.routeName, // '/user/login/forgot-password'
                    name: CustomerForgotPasswordPage.routeName, // forgot-password
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CustomerForgotPasswordPage(),
                  ),
                ]),
            // register
            GoRoute(
              path: CustomerRegisterPage.routeName, // '/user/register'
              name: CustomerRegisterPage.routeName, // register
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const CustomerRegisterPage(),
            ),
            // user detail
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
            // loyalty point history
            GoRoute(
              path: LoyaltyPointHistoryPage.routeName, // '/user/loyalty-point-history'
              name: LoyaltyPointHistoryPage.routeName, // loyalty-point-history
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final loyaltyPointId = state.extra as int;
                return LoyaltyPointHistoryPage(loyaltyPointId: loyaltyPointId);
              },
            ),
            // followed shop
            GoRoute(
              // get extra from state
              path: FollowedShopPage.routeName, // '/user/followed'
              name: FollowedShopPage.routeName, // followed
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                return const FollowedShopPage();
              },
            ),

            // wallet history
            GoRoute(
              path: CustomerWalletHistoryPage.routeName, // '/user/transaction-history'
              name: CustomerWalletHistoryPage.routeName, // transaction-history
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const CustomerWalletHistoryPage(),
            ),
            // voucher
            GoRoute(
              path: VoucherPage.routeName, // '/user/voucher'
              name: VoucherPage.routeName, // voucher
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const VoucherPage(),
            ),
            GoRoute(
              path: MyVoucherPage.routeName, // '/user/voucher-collection';
              name: MyVoucherPage.routeName, // voucher-collection
              builder: (context, state) {
                return const MyVoucherPage();
              },
            ),
            // favorite product
            GoRoute(
              path: FavoriteProductsPage.routeName, // '/user/favorite-product'
              name: FavoriteProductsPage.routeName, // voucher
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const FavoriteProductsPage(),
            ),
            // customer purchase order
            GoRoute(
              path: OrderPurchasePage.routeName, // '/user/purchase'
              name: OrderPurchasePage.routeName, // purchase
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const CustomerOrderPurchasePage(),
              routes: [
                GoRoute(
                  path: CustomerOrderDetailPage.routeName, // '/user/purchase/order-detail'
                  name: CustomerOrderDetailPage.routeName, // order-detail
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final OrderDetailEntity orderDetail = state.extra as OrderDetailEntity;
                    return CustomerOrderDetailPage(orderDetail: orderDetail);
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
                      path: OrderReviewsPage.routeName, // '/user/purchase/order-detail/order-review'
                      name: OrderReviewsPage.routeName, // order-review
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final orderItemId = state.extra as OrderEntity;
                        return OrderReviewsPage(order: orderItemId);
                      },
                    ),
                  ],
                ),
              ],
            ),

            //# Setting
            GoRoute(
              path: SettingsPage.routeName, // '/user/settings'
              name: SettingsPage.routeName, // settings
              builder: (context, state) => const SettingsPage(),
              routes: [
                GoRoute(
                  path: CustomerChangePasswordPage.routeName, // '/user/settings/change-password'
                  name: CustomerChangePasswordPage.routeName, // change-password
                  builder: (context, state) => const CustomerChangePasswordPage(),
                ),
                GoRoute(
                  path: AddressPage.routeName, // 'user/settings/address'
                  name: AddressPage.routeName,
                  builder: (context, state) {
                    final bool? willPopOnChanged = state.extra as bool?;
                    return AddressPage(willPopOnChanged: willPopOnChanged ?? true);
                  },
                  // routes: [
                  //   GoRoute(
                  //     path: AddOrUpdateAddressPage.routeNameAdd, // 'user/settings/address/add-address'
                  //     name: AddOrUpdateAddressPage.routeNameAdd,
                  //     builder: (context, state) {
                  //       return const AddOrUpdateAddressPage();
                  //     },
                  //   ),
                  //   GoRoute(
                  //     path: AddOrUpdateAddressPage.routeNameUpdate, // 'user/settings/address/update-address'
                  //     name: AddOrUpdateAddressPage.routeNameUpdate,
                  //     builder: (context, state) {
                  //       final address = state.extra as AddressEntity;
                  //       return AddOrUpdateAddressPage(address: address);
                  //     },
                  //   ),
                  // ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static StatefulShellBranch _notificationRoutes() {
    return StatefulShellBranch(
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
    );
  }

  static StatefulShellBranch _homeRoutes() => StatefulShellBranch(
        navigatorKey: _sectionHomeNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: HomePage.routeRoot, // '/home'
            name: HomePage.routeName, // home
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
            routes: [
              //# category
              GoRoute(
                path: '${CategoryPage.routeName}/:categoryId', // '/home/category/:categoryId'
                name: CategoryPage.routeName, // category
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final categoryId = state.pathParameters['categoryId']!;
                  final title = state.extra as String;
                  return CategoryPage(categoryId: int.parse(categoryId), title: title);
                },
              ),
              //# product
              GoRoute(
                path: ProductDetailPage.routeName, // '/home/product'
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
                routes: [
                  GoRoute(
                    path: ProductReviewsPage.routeName, // '/home/product/review'
                    name: ProductReviewsPage.routeName, // review
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final productId = state.extra as int;
                      return ProductReviewsPage(productId: productId);
                    },
                    routes: [
                      GoRoute(
                        // '/home/product/review/review-detail/:reviewId'
                        path: '${ReviewDetailPage.routeName}/:reviewId',
                        name: ReviewDetailPage.routeName, // review-detail
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          // final reviewId = state.extra as String;
                          final reviewId = state.pathParameters['reviewId']!;
                          // final comments = state.extra as List<CommentEntity>?;
                          final review = state.extra as ReviewEntity?;
                          return ReviewDetailPage(reviewId: reviewId, review: review);
                        },
                      ),
                    ],
                  )
                ],
              ),
              //# shop
              GoRoute(
                path: '${ShopPage.routeName}/:shopId', // '/home/shop/:shopId'
                name: ShopPage.routeName, // search
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  // final String keywords = state.extra as String;
                  final shopId = state.pathParameters['shopId'];
                  if (shopId != null) {
                    return ShopPage(shopId: int.parse(shopId));
                  } else {
                    return MessageScreen.error('Không tìm thấy cửa hàng');
                  }
                },
              ),
              //# search
              GoRoute(
                path: SearchPage.routeName, // '/home/search' ?q=keywords
                name: SearchPage.routeName, // search
                builder: (context, state) {
                  // final String keywords = state.extra as String;
                  final String keywords = state.uri.queryParameters['q'] ?? '';
                  return SearchPage(keywords: keywords);
                },
              ),
              //# voucher
              GoRoute(
                path: VoucherCollectionPage.routeName, // '/home/voucher-collection';
                name: VoucherCollectionPage.routeName, // voucher-collection
                builder: (context, state) {
                  return const VoucherCollectionPage();
                },
              ),

              //# cart
              GoRoute(
                path: CartPage.routeName, // '/home/cart'
                name: CartPage.routeName,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  return const CartPage();
                },
                routes: [
                  GoRoute(
                    path: CheckoutMultipleOrderPage.routeName, // '/home/cart/multi-checkout'
                    name: CheckoutMultipleOrderPage.routeName,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final multiOrder = state.extra as MultipleOrderResp;
                      return CheckoutMultipleOrderPage(multiOrderResp: multiOrder);
                    },
                    routes: [
                      GoRoute(
                        path: VNPayWebView.routeName, // '/home/cart/multi-checkout/payment-vnpay'
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra as WebViewPaymentExtra;
                          return VNPayWebView(extra: extra);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: CheckoutPage.routeName, // '/home/cart/checkout' ?isCreateWithCart=true|false
                    name: CheckoutPage.routeName,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final orderDetail = state.extra as OrderDetailEntity;
                      final String? type = state.uri.queryParameters['isCreateWithCart'];
                      //! if isCreateWithCart is null => true
                      final bool isCreateWithCart = type == null ? true : type == 'true';
                      return CheckoutPage(orderDetail: orderDetail, isCreateWithCart: isCreateWithCart);
                    },
                    routes: [
                      GoRoute(
                        path: VNPayWebView.routeName, // '/home/cart/checkout/payment-vnpay'
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra as WebViewPaymentExtra;
                          return VNPayWebView(extra: extra);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
