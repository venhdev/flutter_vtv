import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../features/home/domain/repository/product_repository.dart';
import '../../features/order/domain/repository/order_repository.dart';
import '../../features/order/presentation/pages/checkout_page.dart';
import '../../features/order/presentation/pages/order_detail_page.dart';
import '../../service_locator.dart';

/// Quick Handler for customer actions
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

  //# Auth

  static Future<bool> sendCodeForResetPassword(String username) async {
    return sl<AuthRepository>().sendOTPForResetPassword(username).then((resultEither) {
      return resultEither.fold(
        (error) => false,
        (ok) => true,
      );
    });
  }

  static Future<bool> resetPassword(String username, String otp, String newPass) async {
    return sl<AuthRepository>().resetPasswordViaOTP(username, otp, newPass).then((resultEither) {
      return resultEither.fold(
        (error) => false,
        (ok) => true,
      );
    });
  }

  static Future<bool> registerCustomer(RegisterParams params) async {
    return sl<AuthRepository>().register(params).then((resultEither) {
      return resultEither.fold(
        (error) => false,
        (ok) => true,
      );
    });
  }

  static Future<bool> changePassword(String oldPass, String newPass) async {
    return sl<AuthRepository>().changePassword(oldPass, newPass).then((resultEither) {
      return resultEither.fold(
        (error) => false,
        (ok) => true,
      );
    });
  }

  //# Order

  /// - in [OrderDetailPage] >> pop with [OrderDetailEntity] means order is completed >> then update by [onReceived]
  /// - in [OrderPurchasePage] >> update & navigate to [OrderDetailPage] by [onReceived]
  static Future<OrderDetailEntity?> completeOrder(
    BuildContext context,
    String orderId, {
    bool popWithData = false,
  }) async {
    final isConfirm = await showDialogToConfirm<bool?>(
      context: context,
      title: 'Bạn đã nhận được hàng?',
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      content:
          'Hành động này không thể hoàn tác. Sau khi xác nhận, bạn sẽ không thể yêu cầu hoàn trả tiền hoặc đổi trả hàng. Và chúng tôi sẽ chuyển tiền cho người bán.',
      confirmText: 'Xác nhận',
      confirmBackgroundColor: Colors.green.shade300,
      dismissText: 'Thoát',
    );

    if (isConfirm ?? false) {
      final respEither = await sl<OrderRepository>().completeOrder(orderId);
      return respEither.fold(
        (error) {
          Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra');
          return null;
        },
        (ok) {
          if (!popWithData) {
            return ok.data;
          } else {
            // in [OrderDetailPage] pop with [OrderDetailEntity] data
            context.pop<OrderDetailEntity>(ok.data!); // pop out [OrderDetailEntity]
            return null;
          }
        },
      );
    }
    return null;
  }

  static Future<void> cancelOrder(BuildContext context, String orderId) async {
    final isConfirm = await showDialogToConfirm<bool?>(
      context: context,
      title: 'Bạn muốn hủy đơn hàng?',
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      content:
          'Hành động này không thể hoàn tác. Sau khi hủy đơn hàng, bạn sẽ không được hoàn trả phiếu giảm giá và số điểm tích lũy đã sử dụng (nếu có).',
      confirmText: 'Hủy đơn hàng',
      confirmBackgroundColor: Colors.red.shade300,
      dismissText: 'Thoát',
    );

    if (isConfirm ?? false) {
      final respEither = await sl<OrderRepository>().cancelOrder(orderId);
      respEither.fold(
        (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi hủy đơn hàng!'),
        (ok) {
          showDialogToAlert(context, title: const Text('Hủy đơn hàng thành công!'));
          context.go(OrderDetailPage.path, extra: ok.data!);
        },
      );
    }
  }

  static Future<void> rePurchaseOrder(BuildContext context, List<OrderItemEntity> orderItems) async {
    final Map<int, int> rePurchaseItems = {}; // cre a list to store productVariantId and quantity for re-purchase

    for (var item in orderItems) {
      rePurchaseItems.addAll({item.productVariant.productVariantId: item.quantity});
    }

    final respEither = await sl<OrderRepository>().createByProductVariant(rePurchaseItems);

    respEither.fold(
      (error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error.message!),
            ),
          );
      },
      (ok) {
        context.push(
          Uri(path: CheckoutPage.path, queryParameters: {'isCreateWithCart': 'false'}).toString(),
          extra: ok.data!.order,
        );
      },
    );
  }
}
