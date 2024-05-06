import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Future<void> onPageFinished(BuildContext context, String url) async {
    log('onPageFinished: $url');
    // if (url.contains('$_serverHost:$kPORT/api/vnpay/return')) {
    if (url.contains('/api/vnpay/return')) {
      // log('here url: $url');
      //> if payment success
      if (extra.orderIds.length == 1) {
        final respEither = await sl<OrderRepository>().getOrderDetail(extra.orderIds.first);
        log('here: single order: ${extra.orderIds.first} -isRight(): ${respEither.isRight()}');
        respEither.fold(
          (error) {
            Fluttertoast.showToast(msg: error.message ?? 'Xảy ra lỗi khi lấy thông tin đơn hàng');
            context.go(OrderPurchasePage.path);
          },
          (ok) async {
            if (ok.data!.order.status == OrderStatus.PENDING) {
              log('here: OrderStatus == PENDING');
              log('here after show dialog success payment: mounted=${context.mounted}');
              // await showDialogToAlert(context, title: const Text('Thanh toán thành công'), children: [
              //   Text('Đơn hàng ${ok.data!.order.orderId} đã được thanh toán thành công'),
              // ]);
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FullScreenDialog(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            const Text('Thanh toán thành công', style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 20),
                            Text('Đơn hàng ${ok.data!.order.orderId} đã được thanh toán thành công'),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                context.go(CustomerOrderDetailPage.path, extra: ok.data!);
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
              // if (context.mounted) context.go(CustomerOrderDetailPage.path, extra: ok.data!);
            }
          },
        );
      } else {
        //> if payment success for multi orders
        log('here: multi orders');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return FullScreenDialog(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text('Thanh toán thành công', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      Text('${extra.orderIds.length} Đơn hàng của bạn đã được thanh toán thành công'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.go(OrderPurchasePage.path);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // enable javascript
      ..setBackgroundColor(const Color(0x00000000)) // transparent background
      ..loadRequest(Uri.parse(extra.uri));

    final NavigationDelegate navigationDelegate = NavigationDelegate(
      onPageFinished: (String url) async => await onPageFinished(context, url),
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

    return Scaffold(
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}
