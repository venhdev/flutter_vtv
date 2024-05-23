import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../service_locator.dart';
import '../../domain/dto/webview_payment_param.dart';
import '../../domain/repository/order_repository.dart';
import 'customer_order_detail_page.dart';

const String _serverConfigHost = '192.168.233.1';

class VNPayWebView extends StatelessWidget {
  const VNPayWebView({super.key, required this.extra});

  static const String routeName = 'payment-vnpay';
  static const String pathSingleOrder = '/home/cart/checkout/payment-vnpay';
  static const String pathMultiOrder = '/home/cart/multi-checkout/payment-vnpay';

  final WebViewPaymentExtra extra;

  //! OrderStatus.PENDING means payment success (prev status is UNPAID)
  Future<void> handleRedirectOnReturnUrl(BuildContext context) async {
    //! if payment success for multi orders
    log('{handleRedirectOnReturnUrl} START');

    //> show dialog to inform user that order is being processed
    _showFullScreenDialog(context, const Text('Đơn hàng đang được xử lý', textAlign: TextAlign.center), []);

    await Future.delayed(const Duration(seconds: 1)); //> await for server to update order status
    //> use custom repository method to get multi order detail from ids
    final respEither = await sl<OrderRepository>().getMultiOrderDetailForCheckPayment(extra.orderIds);

    respEither.fold(
      (error) async => await _showFullScreenDialog(context, const Text('Lỗi lấy thông tin đơn hàng'), [
        const Text('Bạn có thể xem chi tiết đơn hàng trong lịch sử đơn hàng', textAlign: TextAlign.center),
        _backToOrderPurchasePageBtn(context),
      ]),
      (ok) async {
        final isAllSuccess = ok.data!.every((element) => element.order.status == OrderStatus.PENDING);
        await _showFullScreenDialog(
          context,
          const Text('Chi tiết thanh toán', style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
          [
            if (isAllSuccess) ...[
              const Icon(Icons.check_circle, color: Colors.green, size: 50), // icon check
              Text('${extra.orderIds.length} Đơn hàng của bạn đã được thanh toán thành công'),
            ] else ...[
              const Icon(Icons.access_time, color: Colors.orangeAccent, size: 50), // icon time
              const Text('Đơn hàng của bạn đang được xử lý'),
            ],
            const SizedBox(height: 20),

            //# list of row with 2 columns (order id and status)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mã đơn hàng', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            ...ok.data!.map((orderDetail) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${orderDetail.order.orderId}'),
                  Text(
                    orderDetail.order.status == OrderStatus.PENDING ? 'Thành công' : 'Đang xử lý',
                    style: TextStyle(
                      color: orderDetail.order.status == OrderStatus.PENDING ? Colors.green : Colors.orangeAccent,
                    ),
                  ),
                ],
              );
            }),

            _backToOrderPurchasePageBtn(context),
          ],
        );
      },
    );
  }

  Future<void> showProgressingSingleOrder(BuildContext context, String? orderId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return FullScreenDialog(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text('Đang xử lý thanh toán', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  const Text('Đơn thanh toán của bạn đang được xử lý'),
                  const SizedBox(height: 20),
                  if (orderId != null)
                    ElevatedButton(
                      onPressed: () async {
                        final respEither = await sl<OrderRepository>().getOrderDetail(orderId);
                        respEither.fold(
                          // (error) => _showFullScreenDialog(context, error.message ?? 'Lỗi lấy thông tin đơn hàng', []),
                          (error) => _showFullScreenDialog(context, const Text('Lỗi lấy thông tin đơn hàng'), []),
                          (ok) {
                            context.go(CustomerOrderDetailPage.path, extra: ok.data!);
                          },
                        );
                      },
                      child: const Text('Xem chi tiết đơn hàng'),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // enable javascript
      ..setBackgroundColor(const Color(0x00000000)) // transparent background
      ..loadRequest(Uri.parse(extra.uri));

    final NavigationDelegate navigationDelegate = NavigationDelegate(
      onPageFinished: (String url) async {
        log('onPageFinished: $url');
        //> if payment success, the webview will redirect to this url
        if (url.contains('/api/vnpay/return')) {
          await handleRedirectOnReturnUrl(context);
        }
      },
      onWebResourceError: (WebResourceError error) {
        log('WebResourceError: ${error.errorCode} - ${error.description}');
        context.pop();
      },
      onNavigationRequest: (NavigationRequest request) {
        log('onNavigationRequest: ${request.url}');
        // if (request.url.contains('$_serverHost:$kPORT/api/vnpay/return')) {
        if (request.url.contains('/api/vnpay/return')) {
          // change localhost to real host
          final String realHostUrl;
          if (request.url.contains('localhost')) {
            realHostUrl = request.url.replaceFirst('localhost', host);
          } else if (request.url.contains(_serverConfigHost)) {
            realHostUrl = request.url.replaceFirst(_serverConfigHost, host);
          } else {
            realHostUrl = request.url;
          }

          webViewController.loadRequest(Uri.parse(realHostUrl));
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );

    webViewController.setNavigationDelegate(navigationDelegate);

    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(
          controller: webViewController,
        ),
      ),
    );
  }
}

Future<void> _showFullScreenDialog(BuildContext context, Widget title, List<Widget>? children) async {
  return showDialog(
    context: context,
    builder: (context) {
      return FullScreenDialog(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title,
                if (children?.isNotEmpty ?? false) ...children!,
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _backToOrderPurchasePageBtn(BuildContext context, {String btnLabel = 'Đơn hàng của bạn'}) {
  return ElevatedButton(
    onPressed: () {
      context.go(OrderPurchasePage.path);
    },
    child: Text(btnLabel),
  );
}


// final respEither = await sl<OrderRepository>().getOrderDetail(extra.orderIds.first);
      // respEither.fold(
      //   (error) {
      //     Fluttertoast.showToast(msg: error.message ?? 'Xảy ra lỗi khi lấy thông tin đơn hàng');
      //     context.go(OrderPurchasePage.path);
      //   },
      //   (ok) async {
      //     if (ok.data!.order.status == OrderStatus.PENDING) {
      //       log('OrderStatus == PENDING, mounted=${context.mounted}');
      //       await _showFullScreenDialog(
      //         context,
      //         const Text('Thanh toán thành công', style: TextStyle(fontSize: 20)),
      //         [
      //           const SizedBox(height: 20),
      //           ElevatedButton(
      //             onPressed: () {
      //               context.go(CustomerOrderDetailPage.path, extra: ok.data!);
      //             },
      //             child: const Text('Xem chi tiết đơn hàng'),
      //           ),
      //           const SizedBox(height: 20),
      //         ],
      //       );
      //     } else {
      //       log('here: OrderStatus != PENDING');
      //       _showFullScreenDialog(context, const Text('Đơn hàng đang được xử lý', textAlign: TextAlign.center), []);
      //     }
      //   },
      // );

      // log('handleRedirectOnReturnUrl: multi orders');

      // final respEither = await sl<OrderRepository>().getOrderDetail(extra.orderIds.first);

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return FullScreenDialog(
      //         body: Center(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               const SizedBox(height: 20),
      //               const Text('Thanh toán thành công', style: TextStyle(fontSize: 20)),
      //               const SizedBox(height: 20),
      //               Text('${extra.orderIds.length} Đơn hàng của bạn đã được thanh toán thành công'),
      //               const SizedBox(height: 20),
      //               ElevatedButton(
      //                 onPressed: () {
      //                   context.go(OrderPurchasePage.path);
      //                 },
      //                 child: const Text('Xem chi tiết đơn hàng'),
      //               ),
      //               const SizedBox(height: 20),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // );



      // =========
      
    // if (extra.orderIds.length == 1) {
    //   log('handleRedirectOnReturnUrl: single order');
    //   //> show dialog to inform user that order is being processed
    //   _showFullScreenDialog(context, const Text('Đơn hàng đang được xử lý', textAlign: TextAlign.center), []);

    //   await Future.delayed(const Duration(seconds: 1)); //> await for server to update order status
    //   final respEither = await sl<OrderRepository>().getOrderDetail(extra.orderIds.first);
    //   respEither.fold(
    //     (error) {
    //       Fluttertoast.showToast(msg: error.message ?? 'Xảy ra lỗi khi lấy thông tin đơn hàng');
    //       context.go(OrderPurchasePage.path);
    //     },
    //     (ok) async {
    //       if (ok.data!.order.status == OrderStatus.PENDING) {
    //         log('OrderStatus == PENDING, mounted=${context.mounted}');
    //         await _showFullScreenDialog(
    //           context,
    //           const Text('Thanh toán thành công', style: TextStyle(fontSize: 20)),
    //           [
    //             const SizedBox(height: 20),
    //             ElevatedButton(
    //               onPressed: () {
    //                 context.go(CustomerOrderDetailPage.path, extra: ok.data!);
    //               },
    //               child: const Text('Xem chi tiết đơn hàng'),
    //             ),
    //             const SizedBox(height: 20),
    //           ],
    //         );
    //       } else {
    //         log('here: OrderStatus != PENDING');
    //         _showFullScreenDialog(context, const Text('Đơn hàng đang được xử lý', textAlign: TextAlign.center), []);
    //       }
    //     },
    //   );
    // } else {}