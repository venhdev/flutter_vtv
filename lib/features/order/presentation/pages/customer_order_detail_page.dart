import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../../service_locator.dart';
import '../../../home/presentation/pages/product_detail_page.dart';
import '../../domain/repository/order_repository.dart';
import '../components/btn/review_btn.dart';
import 'checkout_page.dart';

class CustomerOrderDetailPage extends StatefulWidget {
  const CustomerOrderDetailPage({super.key, required this.orderDetail});

  final OrderDetailEntity orderDetail;

  static const String routeName = 'order-detail';
  static const String path = '/user/purchase/order-detail';

  @override
  State<CustomerOrderDetailPage> createState() => _CustomerOrderDetailPageState();
}

class _CustomerOrderDetailPageState extends State<CustomerOrderDetailPage> {
  late OrderDetailEntity _orderDetail;

  @override
  void initState() {
    super.initState();
    _orderDetail = widget.orderDetail;
  }

  void fetchOrderDetail() async {
    final respEither = await showDialogToPerform(
      context,
      dataCallback: () => sl<OrderRepository>().getOrderDetail(_orderDetail.order.orderId!),
      closeBy: (context, result) => context.pop(result),
    );

    respEither?.fold(
      (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi tải thông tin đơn hàng!'),
      (ok) => setState(() => _orderDetail = ok.data!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrderDetailPage.customer(
      orderDetail: _orderDetail,
      onBack: () => context.pop(),
      onPayPressed: (orderId) => CustomerHandler.processSingleOrderPaymentByVNPay(context, orderId),
      onRePurchasePressed: (orderItems) => _rePurchaseOrder(context, orderItems),
      onCancelOrderPressed: (orderId) => _cancelOrder(context, orderId),
      onCompleteOrderPressed: (orderId) async {
        final respEither = await completeOrder(context, orderId);
        respEither?.fold(
          (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra khi hoàn tất đơn hàng!'),
          // (ok) => context.go(CustomerOrderDetailPage.path, extra: ok.data!),
          (ok) => setState(() => _orderDetail = ok.data!),
        );
      },
      onChatPressed: () async => await CustomerHandler.navigateToChatPageViaShopId(context, _orderDetail.order.shop.shopId),
      customerReviewBtn: (order) => CustomerReviewButton(order: order),
      onOrderItemPressed: (orderItem) => context.push(
        ProductDetailPage.path,
        extra: orderItem.productVariant.productId,
      ),
      onRefresh: () async => fetchOrderDetail(),
    );
  }
}

//*-------------------------------------------------completeOrder---------------------------------------------------*//
/// - in [OrderDetailPage] >> pop with [OrderDetailEntity] means order is completed >> then update by [onReceived]
/// - in [OrderPurchasePage] >> update & navigate to [OrderDetailPage] by [onReceived]
Future<RespData<OrderDetailEntity>?> completeOrder(
  BuildContext context,
  String orderId,
  // bool inOrderDetailPage = false,
  // required VoidCallback? onRefresh,
  // void Function(OrderDetailEntity)? onReceived,
) async {
  // assert(inOrderDetailPage || (onReceived != null && !inOrderDetailPage),
  //     'When in [OrderPurchasePage], [onReceived] must be provided!');

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

  if ((isConfirm ?? false) && context.mounted) {
    return await showDialogToPerform(
      context,
      dataCallback: () => sl<OrderRepository>().completeOrder(orderId),
      closeBy: (context, result) => context.pop(result),
    );
  }
  return null;
  // final respEither = await sl<OrderRepository>().completeOrder(orderId);
  // respEither.fold(
  //   (error) {
  //     Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra');
  //   },
  //   (ok) {
  //     if (inOrderDetailPage) {
  //       // navigate to [OrderDetailPage] with new [OrderDetailEntity]
  //       context.go(CustomerOrderDetailPage.path, extra: ok.data!);
  //     } else {
  //       // [onReceived]: this call back defined in [OrderPurchasePage]
  //       // - 1. update order list in [OrderPurchasePage]
  //       // - 2. navigate to [OrderDetailPage] with new [OrderDetailEntity]
  //       onReceived?.call(ok.data!);
  //     }
  //   },
  // );

  // if (respEither == null) return;
  // respEither.fold(
  //   (error) {
  //     showDialogToAlert(context, title: Text(error.message ?? 'Có lỗi xảy ra'));
  //   },
  //   (ok) {
  //     context.go(CustomerOrderDetailPage.path, extra: ok.data!);
  //     // if (inOrderDetailPage) {
  //     //   // navigate to [OrderDetailPage] with new [OrderDetailEntity]
  //     // } else {
  //     //   // [onReceived]: this call back defined in [OrderPurchasePage]
  //     //   // - 1. update order list in [OrderPurchasePage]
  //     //   // - 2. navigate to [OrderDetailPage] with new [OrderDetailEntity]
  //     //   onRefresh();
  //     // }
  //   },
  // );
}

//*-------------------------------------------------cancelOrder---------------------------------------------------*//
Future<void> _cancelOrder(BuildContext context, String orderId) async {
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
        context.go(CustomerOrderDetailPage.path, extra: ok.data!);
      },
    );
  }
}

//*-------------------------------------------------rePurchaseOrder---------------------------------------------------*//
Future<void> _rePurchaseOrder(BuildContext context, List<OrderItemEntity> orderItems) async {
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
        extra: ok.data!,
      );
    },
  );
}
