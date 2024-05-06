import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';

import '../../features/home/domain/repository/product_repository.dart';
import '../../features/order/domain/dto/webview_payment_param.dart';
import '../../features/order/domain/repository/order_repository.dart';
import '../../features/order/presentation/pages/vnpay_webview.dart';
import '../../service_locator.dart';

/// Quick Handler for customer actions (common use function in multi page)
class CustomerHandler {
  //# Follow Shop
  static Future<int?> handleFollowShop(int shopId) async {
    final rsEither = await sl<ProductRepository>().followedShopAdd(shopId);

    return rsEither.fold(
      (error) => null,
      (ok) => ok.data?.followedShopId,
    );
  }

  static Future<int?> handleUnFollowShop(int followedShopId) async {
    final rsEither = await sl<ProductRepository>().followedShopDelete(followedShopId);

    return rsEither.fold(
      (error) => followedShopId, // if delete failed, return the same id
      (ok) => null,
    );
  }

  //# Payment
  static Future<void> processSingleOrderPaymentByVNPay(BuildContext context, String orderId) async {
    final String? uriPayment = await sl<OrderRepository>().createPaymentForSingleOrder(orderId).then(
          (respEither) => respEither.fold((error) => null, (ok) => ok.data),
        );

    if (uriPayment != null && context.mounted) {
      await showDialogToAlert(
        context,
        confirmText: 'Đồng ý',
        title: const Text('Tạo đơn thanh toán thành công', textAlign: TextAlign.center),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        children: [Text('Bạn sẽ được chuyển đến trang thanh toán để hoàn tất đơn hàng $orderId')],
      );

      if (context.mounted) {
        await context.push(
          VNPayWebView.pathSingleOrder,
          extra: WebViewPaymentExtra([orderId], uriPayment),
        );
      }
    } else if (uriPayment == null && context.mounted) {
      showDialogToAlert(
        context,
        title: const Text('Tạo đơn thanh toán thất bại', textAlign: TextAlign.center),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
        children: [const Text('Có lỗi xảy ra khi tạo đơn thanh toán. Vui lòng thử lại sau.')],
      );
    }
  }

  //# Auth

  // static Future<bool> sendCodeForResetPassword(String username) async {
  //   return sl<AuthRepository>().sendOTPForResetPassword(username).then((resultEither) {
  //     return resultEither.fold(
  //       (error) => false,
  //       (ok) => true,
  //     );
  //   });
  // }

  // static Future<bool> resetPassword(String username, String otp, String newPass) async {
  //   return sl<AuthRepository>().resetPasswordViaOTP(username, otp, newPass).then((resultEither) {
  //     return resultEither.fold(
  //       (error) => false,
  //       (ok) => true,
  //     );
  //   });
  // }

  // static Future<bool> registerCustomer(RegisterParams params) async {
  //   return sl<AuthRepository>().register(params).then((resultEither) {
  //     return resultEither.fold(
  //       (error) {
  //         Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi đăng ký tài khoản!');
  //         return false;
  //       },
  //       (ok) {
  //         Fluttertoast.showToast(msg: ok.message ?? 'Đăng ký tài khoản thành công!');
  //         return true;
  //       },
  //     );
  //   });
  // }

  // static Future<bool> changePassword(String oldPass, String newPass) async {
  //   return sl<AuthRepository>().changePassword(oldPass, newPass).then((resultEither) {
  //     return resultEither.fold(
  //       (error) => false,
  //       (ok) => true,
  //     );
  //   });
  // }

  //# Order

  /// - in [OrderDetailPage] >> pop with [OrderDetailEntity] means order is completed >> then update by [onReceived]
  /// - in [OrderPurchasePage] >> update & navigate to [OrderDetailPage] by [onReceived]
  // static Future<void> completeOrder(
  //   BuildContext context,
  //   String orderId, {
  //   bool inOrderDetailPage = false,
  //   void Function(OrderDetailEntity)? onReceived,
  // }) async {
  //   assert(inOrderDetailPage || (onReceived != null && !inOrderDetailPage),
  //       'When in [OrderPurchasePage], [onReceived] must be provided!');

  //   final isConfirm = await showDialogToConfirm<bool?>(
  //     context: context,
  //     title: 'Bạn đã nhận được hàng?',
  //     titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //     content:
  //         'Hành động này không thể hoàn tác. Sau khi xác nhận, bạn sẽ không thể yêu cầu hoàn trả tiền hoặc đổi trả hàng. Và chúng tôi sẽ chuyển tiền cho người bán.',
  //     confirmText: 'Xác nhận',
  //     confirmBackgroundColor: Colors.green.shade300,
  //     dismissText: 'Thoát',
  //   );

  //   if (isConfirm ?? false) {
  //     final respEither = await sl<OrderRepository>().completeOrder(orderId);
  //     respEither.fold(
  //       (error) {
  //         Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra');
  //       },
  //       (ok) {
  //         if (inOrderDetailPage) {
  //           // navigate to [OrderDetailPage] with new [OrderDetailEntity]
  //           context.go(CustomerOrderDetailPage.path, extra: ok.data!);
  //         } else {
  //           // [onReceived]:
  //           // - 1. update order list in [OrderPurchasePage]
  //           // - 2. navigate to [OrderDetailPage] with new [OrderDetailEntity]
  //           onReceived?.call(ok.data!);
  //         }
  //       },
  //     );
  //   }
  // }

  // static Future<void> cancelOrder(BuildContext context, String orderId) async {
  //   final isConfirm = await showDialogToConfirm<bool?>(
  //     context: context,
  //     title: 'Bạn muốn hủy đơn hàng?',
  //     titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //     content:
  //         'Hành động này không thể hoàn tác. Sau khi hủy đơn hàng, bạn sẽ không được hoàn trả phiếu giảm giá và số điểm tích lũy đã sử dụng (nếu có).',
  //     confirmText: 'Hủy đơn hàng',
  //     confirmBackgroundColor: Colors.red.shade300,
  //     dismissText: 'Thoát',
  //   );

  //   if (isConfirm ?? false) {
  //     final respEither = await sl<OrderRepository>().cancelOrder(orderId);
  //     respEither.fold(
  //       (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi hủy đơn hàng!'),
  //       (ok) {
  //         showDialogToAlert(context, title: const Text('Hủy đơn hàng thành công!'));
  //         context.go(CustomerOrderDetailPage.path, extra: ok.data!);
  //       },
  //     );
  //   }
  // }

  // static Future<void> rePurchaseOrder(BuildContext context, List<OrderItemEntity> orderItems) async {
  //   final Map<int, int> rePurchaseItems = {}; // cre a list to store productVariantId and quantity for re-purchase

  //   for (var item in orderItems) {
  //     rePurchaseItems.addAll({item.productVariant.productVariantId: item.quantity});
  //   }

  //   final respEither = await sl<OrderRepository>().createByProductVariant(rePurchaseItems);

  //   respEither.fold(
  //     (error) {
  //       ScaffoldMessenger.of(context)
  //         ..hideCurrentSnackBar()
  //         ..showSnackBar(
  //           SnackBar(
  //             content: Text(error.message!),
  //           ),
  //         );
  //     },
  //     (ok) {
  //       context.push(
  //         Uri(path: CheckoutPage.path, queryParameters: {'isCreateWithCart': 'false'}).toString(),
  //         extra: ok.data!,
  //       );
  //     },
  //   );
  // }

  // static FutureOr<void> placeOrder(
  //   BuildContext context,
  //   FRespData<OrderDetailEntity> Function() placeOrderFunc,
  //   // bool isCreateWithCart, {
  //   // OrderRequestWithCartParam? placeOrderWithCartParam,
  //   // OrderRequestWithVariantParam? placeOrderWithVariantParam,
  //   // }
  // ) async {
  //   Future<T?> showConfirmationDialog<T>() async {
  //     return await showDialogToConfirm(
  //       context: context,
  //       title: 'Xác nhận đặt hàng',
  //       content: 'Bạn có chắc chắn muốn đặt hàng?',
  //       titleTextStyle: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 20,
  //       ),
  //       confirmText: 'Xác nhận',
  //       dismissText: 'Hủy',
  //       confirmBackgroundColor: Colors.green.shade200,
  //       dismissBackgroundColor: Colors.grey.shade400,
  //     );
  //   }

  //   final isConfirmed = await showConfirmationDialog<bool>();

  //   if (isConfirmed ?? false) {
  //     final respEither = await placeOrderFunc();
  //     // final respEither = isCreateWithCart
  //     //     ? await sl<OrderRepository>().placeOrderWithCart(placeOrderWithCartParam!)
  //     //     : await sl<OrderRepository>().placeOrderWithVariant(placeOrderWithVariantParam!);

  //     respEither.fold(
  //       (error) {
  //         // Fluttertoast.showToast(msg: 'Đặt hàng thất bại. Lỗi: ${error.message}');
  //         showDialogToAlert(
  //           context,
  //           title: const Text('Đặt hàng thất bại', textAlign: TextAlign.center),
  //           titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
  //           children: [
  //             Text(error.message ?? 'Đã có lỗi xảy ra'),
  //           ],
  //         );
  //       },
  //       (ok) {
  //         // FetchCart to BLoC to update cart
  //         context.read<CartBloc>().add(const FetchCart()); //OK_TODO this make show unwanted toast

  //         // navigate to order detail page
  //         context.go(CustomerOrderDetailPage.path, extra: ok.data);
  //       },
  //     );
  //   }
  // }

  // static Widget buildOrderStatusAction(
  //   BuildContext context, {
  //   required OrderEntity order,
  //   required Function(OrderDetailEntity completedOrder) onReceivedPressed,
  // }) {
  //   if (order.status == OrderStatus.DELIVERED) {
  //     return OrderPurchaseItemAction(
  //       label: 'Bạn đã nhận được hàng chưa?',
  //       buttonLabel: 'Đã nhận',
  //       onPressed: () {
  //         completeOrder(context, order.orderId!, inOrderDetailPage: false, onReceived: onReceivedPressed);
  //       },
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }
  //! Navigation & Data Involved (OrderPurchasePage)

  // static FRespData<MultiOrderEntity> dataCallOrderPurchasePage(OrderStatus? status) {
  //   if (status == null) {
  //     return sl<OrderRepository>().getListOrders();
  //   } else if (status == OrderStatus.PROCESSING) {
  //     // combine 2 lists of orders with status PROCESSING and PICKUP_PENDING
  //     return sl<OrderRepository>().getListOrdersByStatusProcessingAndPickupPending();
  //   }
  //   return sl<OrderRepository>().getListOrdersByStatus(status.name);
  // }

  // static Future<void> navigateToOrderDetailPage(
  //   BuildContext context,
  //   OrderEntity order,
  //   void Function(OrderDetailEntity) onReceivedCallback, //use when user tap completed order in OrderDetailPage
  // ) async {
  //   final respEither = await sl<OrderRepository>().getOrderDetail(order.orderId!);
  //   respEither.fold(
  //     (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
  //     (ok) async {
  //       final completedOrder = await context.push<OrderDetailEntity>(CustomerOrderDetailPage.path, extra: ok.data);
  //       if (completedOrder != null) onReceivedCallback(completedOrder);
  //     },
  //   );
  // }
}
