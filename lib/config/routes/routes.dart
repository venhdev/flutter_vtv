import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/config/routes/extra_codec.dart';
import 'package:flutter_vtv/features/order/presentation/pages/checkout_multiple_order_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/order.dart';

import '../../core/handler/customer_handler.dart';
import '../../core/presentation/pages/dev_page.dart';
import '../../core/presentation/pages/intro_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/pages/category_page.dart';
import '../../features/home/presentation/pages/favorite_products_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/product_detail_page.dart';
import '../../features/home/presentation/pages/product_reviews_page.dart';
import '../../features/home/presentation/pages/review_detail_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/home/presentation/pages/shop_page.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../../features/order/domain/entities/multiple_order_resp.dart';
import '../../features/order/presentation/components/btn/review_btn.dart';
import '../../features/order/presentation/pages/add_review_page.dart';
import '../../features/order/presentation/pages/checkout_page.dart';
import '../../features/order/presentation/pages/order_reviews_page.dart';
import '../../features/order/presentation/pages/voucher_page.dart';
import '../../features/profile/presentation/pages/address_page.dart';
import '../../features/profile/presentation/pages/followed_shop_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/user_detail_page.dart';
import '../../features/profile/presentation/pages/user_page.dart';
import 'scaffold_with_navbar.dart';

//! config bottom navigation bar in '/lib/config/routes/scaffold_with_navbar.dart'

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionHomeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionHomeNav');
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  //! if want to hide bottom navigation bar >> add: parentNavigatorKey: _rootNavigatorKey,
  static GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE: dev
    navigatorKey: _rootNavigatorKey,
    extraCodec: const MyExtraCodec(),
    initialLocation: '/home',
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
        path: DevPage.routeName, // '/dev'
        builder: (context, state) => const DevPage(),
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
            GoRoute(
                // path: LoginPage.routeName, // '/user/login'
                // name: LoginPage.routeName, // login
                path: 'login',
                name: 'login',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => LoginPage(
                      onLoginPressed: (username, password) async {
                        await context
                            .read<AuthCubit>()
                            .loginWithUsernameAndPassword(username: username, password: password);
                      },
                      onNavRegister: () => context.go(RegisterPage.path),
                      onNavForgotPassword: () => context.go(ForgotPasswordPage.path),
                    ),
                routes: [
                  GoRoute(
                    path: ForgotPasswordPage.routeName, // '/user/login/forgot-password'
                    parentNavigatorKey: _rootNavigatorKey,
                    name: ForgotPasswordPage.routeName, // forgot-password
                    builder: (context, state) => const ForgotPasswordPage(
                      onSendCode: CustomerHandler.sendCodeForResetPassword,
                      handleResetPassword: CustomerHandler.resetPassword,
                    ),
                  ),
                ]),
            GoRoute(
              path: RegisterPage.routeName, // '/user/register'
              name: RegisterPage.routeName, // register
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => RegisterPage(
                onRegister: CustomerHandler.registerCustomer,
                onNavLogin: () => context.go('/user/login'),
              ),
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
              // get extra from state
              path: FollowedShopPage.routeName, // '/user/followed'
              name: FollowedShopPage.routeName, // followed
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                return const FollowedShopPage();
              },
            ),
            GoRoute(
              path: VoucherPage.routeName, // '/user/voucher'
              name: VoucherPage.routeName, // voucher
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const VoucherPage(),
            ),
            GoRoute(
              path: FavoriteProductsPage.routeName, // '/user/favorite-product'
              name: FavoriteProductsPage.routeName, // voucher
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const FavoriteProductsPage(),
            ),
            GoRoute(
              path: OrderPurchasePage.routeName, // '/user/purchase'
              name: OrderPurchasePage.routeName, // purchase
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => OrderPurchasePage(
                dataCallBack: CustomerHandler.dataCallOrderPurchasePage,
                itemBuilder: (order, onReceivedCallback) => OrderPurchaseItem(
                  order: order,
                  onReceivedPressed: () => CustomerHandler.completeOrder(
                    context,
                    order.orderId!,
                    inOrderDetailPage: false,
                    onReceived: onReceivedCallback,
                  ),
                  onPressed: () => CustomerHandler.navigateToOrderDetailPage(context, order, onReceivedCallback),
                  onShopPressed: () => context.push('${ShopPage.path}/${order.shop.shopId}'),
                  buildOnCompleted: ReviewBtn(order: order),
                ),
              ),
              routes: [
                GoRoute(
                  path: OrderDetailPage.routeName, // '/user/purchase/order-detail'
                  name: OrderDetailPage.routeName, // order-detail
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final OrderDetailEntity orderDetail = state.extra as OrderDetailEntity;
                    return OrderDetailPage(
                      orderDetail: orderDetail,
                      onRePurchasePressed: (orderItems) => CustomerHandler.rePurchaseOrder(context, orderItems),
                      onCancelOrderPressed: (orderId) => CustomerHandler.cancelOrder(context, orderId),
                      onCompleteOrderPressed: (orderId) => CustomerHandler.completeOrder(
                        context,
                        orderId,
                        inOrderDetailPage: true,
                      ),
                      customerReviewBtn: (order) => ReviewBtn(order: order),
                      onOrderItemPressed: (orderItem) =>
                          context.push(ProductDetailPage.path, extra: orderItem.productVariant.productId),
                    );
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
            //! Setting
            GoRoute(
              path: SettingsPage.routeName, // '/user/settings'
              name: SettingsPage.routeName, // settings
              builder: (context, state) => const SettingsPage(),
              routes: [
                GoRoute(
                  path: ChangePasswordPage.routeName, // '/user/settings/change-password'
                  name: ChangePasswordPage.routeName, // change-password
                  builder: (context, state) => ChangePasswordPage(
                    onChangePassword: (old, newPass) {
                      CustomerHandler.changePassword(old, newPass).then((value) {
                        if (value) {
                          Fluttertoast.showToast(msg: 'Đổi mật khẩu thành công');
                        } else {
                          Fluttertoast.showToast(msg: 'Đổi mật khẩu thất bại');
                        }
                      });
                    },
                  ),
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
                  ),
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
      );
}
