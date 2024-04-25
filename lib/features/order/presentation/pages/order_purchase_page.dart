import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/order_repository.dart';
import '../components/purchase_order_item.dart';
import 'order_detail_page.dart';

const int _totalTab = 7;

class OrderPurchasePage extends StatefulWidget {
  const OrderPurchasePage({super.key});

  static const String routeName = 'purchase';
  static const String path = '/user/purchase';

  @override
  State<OrderPurchasePage> createState() => _OrderPurchasePageState();
}

class _OrderPurchasePageState extends State<OrderPurchasePage> {
  Future<List<RespData<MultiOrderEntity>>> _futureDataOrders() async {
    return Future.wait(
      List.generate(_totalTab, (index) async {
        return await _callFuture(_statusFromIndex(index));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _totalTab,
      child: FutureBuilder<List<RespData<MultiOrderEntity>>>(
          future: _futureDataOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final listMultiOrder = snapshot.data!;

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Đơn mua hàng'),
                  bottom: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: List.generate(
                        _totalTab,
                        (index) => _buildTapButton(
                          StringHelper.getOrderStatusName(_statusFromIndex(index)),
                          listMultiOrder[index].fold(
                            (error) => 0,
                            (ok) => ok.data!.orders.length,
                          ),
                          backgroundColor: ColorHelper.getOrderStatusBackgroundColor(_statusFromIndex(index)),
                        ),
                      )),
                ),
                body: TabBarView(
                  children: List.generate(
                    _totalTab,
                    // _buildTabBarView,
                    (index) => RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: _buildTabBarViewWithData(
                        index: index,
                        //? [orders] is empty, so it will show empty message
                        //? if [orders] is not empty, it will show the list of orders with the corresponding status
                        orders: listMultiOrder[index].fold(
                          (error) => [],
                          (ok) => ok.data!.orders,
                        ),
                        onReceived: (completedOrder) {
                          // after received order >> navigate to OrderDetailPage
                          setState(() {});
                          context.go(OrderDetailPage.path, extra: completedOrder);
                        },
                      ),
                    ),
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _buildTapButton(String text, int total, {Color? backgroundColor}) {
    return Badge(
      label: Text(total.toString()),
      backgroundColor: backgroundColor,
      isLabelVisible: total > 0,
      offset: const Offset(12, 0),
      child: Tab(text: text),
    );
  }

  /// position of each tab
  OrderStatus? _statusFromIndex(int index) {
    switch (index) {
      case 0:
        return null;
      case 1:
        return OrderStatus.PENDING;
      case 2:
        return OrderStatus.PROCESSING;
      case 3:
        return OrderStatus.SHIPPING;
      case 4:
        return OrderStatus.DELIVERED;
      case 5:
        return OrderStatus.COMPLETED;
      case 6:
        return OrderStatus.CANCEL;
      default:
        throw Exception('Invalid index');
    }
  }

  String _getEmptyMessage(OrderStatus? status) {
    switch (status) {
      case OrderStatus.WAITING:
        return 'Không có đơn hàng chờ xác nhận nào!';
      case OrderStatus.PENDING:
        return 'Không có đơn hàng chờ xác nhận nào!';
      case OrderStatus.SHIPPING:
        return 'Không có đơn hàng đang giao nào!';
      case OrderStatus.COMPLETED:
        return 'Không có đơn hàng đã giao nào!';
      case OrderStatus.CANCEL:
        return 'Không có đơn hàng đã hủy nào!';
      default:
        return 'Không có đơn hàng nào!';
    }
  }

  Icon _getIcon(OrderStatus? status) {
    switch (status) {
      case OrderStatus.WAITING:
        return const Icon(Icons.pending_actions_rounded);
      case OrderStatus.PENDING:
        return const Icon(Icons.pending_actions_rounded);
      case OrderStatus.SHIPPING:
        return const Icon(Icons.delivery_dining);
      case OrderStatus.COMPLETED:
        return const Icon(Icons.check_circle_rounded);
      case OrderStatus.CANCEL:
        return const Icon(Icons.cancel_rounded);
      default:
        return const Icon(Icons.remove_shopping_cart_rounded);
    }
  }

  Widget _buildTabBarViewWithData({
    required int index,
    required List<OrderEntity> orders,
    required void Function(OrderDetailEntity completedOrder) onReceived,
  }) {
    if (orders.isEmpty) {
      return MessageScreen.error(
        _getEmptyMessage(_statusFromIndex(index)),
        _getIcon(_statusFromIndex(index)),
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return PurchaseOrderItem(
          order: orders[index],
          onReceived: onReceived,
          onPressed: () async {
            final respEither = await sl<OrderRepository>().getOrderDetail(orders[index].orderId!);
            respEither.fold(
              (error) => Fluttertoast.showToast(msg: error.message ?? 'Có lỗi xảy ra'),
              (ok) async {
                final completedOrder = await context.push<OrderDetailEntity>(OrderDetailPage.path, extra: ok.data);
                if (completedOrder != null) onReceived(completedOrder);
              },
            );
          },
        );
      },
    );
  }

  FRespData<MultiOrderEntity> _callFuture(OrderStatus? status) {
    if (status == null) {
      return sl<OrderRepository>().getListOrders();
    } else if (status == OrderStatus.PROCESSING) {
      // combine 2 lists of orders with status PROCESSING and PICKUP_PENDING
      return sl<OrderRepository>().getListOrdersByStatusProcessingAndPickupPending();
    }
    return sl<OrderRepository>().getListOrdersByStatus(status.name);
  }
}
