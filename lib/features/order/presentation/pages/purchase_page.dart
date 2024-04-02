import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../core/constants/enum.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/components/custom_widgets.dart';
import '../../../../service_locator.dart';
import '../../../cart/domain/dto/order_resp.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repository/order_repository.dart';
import '../components/purchase_order_item.dart';

const int _totalTab = 5;

OrderStatus? _statusFromIndex(int index) {
  switch (index) {
    case 0:
      return null;
    case 1:
      return OrderStatus.PENDING;
    case 2:
      return OrderStatus.SHIPPING;
    case 3:
      return OrderStatus.COMPLETED;
    case 4:
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

Widget _buildTabBarViewWithData({required int index, required List<OrderEntity> orders}) {
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
      );
    },
  );
}

FRespData<MultiOrderResp> _callFuture(OrderStatus? status) {
  switch (status) {
    case OrderStatus.WAITING:
      return sl<OrderRepository>().getListOrdersByStatus(OrderStatus.WAITING.name);
    case OrderStatus.PENDING:
      return sl<OrderRepository>().getListOrdersByStatus(OrderStatus.PENDING.name);
    case OrderStatus.SHIPPING:
      return sl<OrderRepository>().getListOrdersByStatus(OrderStatus.SHIPPING.name);
    case OrderStatus.COMPLETED:
      return sl<OrderRepository>().getListOrdersByStatus(OrderStatus.COMPLETED.name);
    case OrderStatus.CANCEL:
      return sl<OrderRepository>().getListOrdersByStatus(OrderStatus.CANCEL.name);
    default:
      return sl<OrderRepository>().getListOrders();
  }
}

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  static const String routeName = 'purchase';
  static const String path = '/user/purchase';

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  Future<List<RespData<MultiOrderResp>>> _futureDataOrders() async {
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
      child: FutureBuilder<List<RespData<MultiOrderResp>>>(
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
                          formatOrderStatusName(_statusFromIndex(index)),
                          listMultiOrder[index].fold(
                            (error) => 0,
                            (ok) => ok.data.orders.length,
                          ),
                          backgroundColor: getOrderStatusBackgroundColor(_statusFromIndex(index)),
                        ),
                      )
                      // _buildTapButton(_buttonText(0), _totalOrdersAt[0]),
                      // _buildTapButton(_buttonText(1), _totalOrdersAt[1]),
                      // _buildTapButton(_buttonText(2), _totalOrdersAt[2]),
                      // _buildTapButton(_buttonText(3), _totalOrdersAt[3]),
                      ),
                ),
                body: TabBarView(
                  children: List.generate(
                    _totalTab,
                    // _buildTabBarView,
                    (index) => RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      // child: _buildTabBarView(index: index),
                      // child: _buildTabBarViewWithData(index: index, orders: []),
                      child: _buildTabBarViewWithData(
                          index: index,
                          //? this [orders] is empty, so it will show empty message
                          //? if [orders] is not empty, it will show the list of orders with the corresponding status
                          orders: listMultiOrder[index].fold(
                            (error) => [],
                            (ok) => ok.data.orders,
                          )),
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
}

// Widget _buildTabBarView({required int index}) {
//   return FutureBuilder(
//     future: _callFuture(index),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         final respEither = snapshot.data!;

//         return respEither.fold(
//           (error) => MessageScreen.error(error.message),
//           (ok) {
//             if (ok.data.orders.isEmpty) {
//               return MessageScreen.error(
//                 _getEmptyMessage(index),
//                 const Icon(Icons.remove_shopping_cart_rounded),
//               );
//             }

//             return ListView.separated(
//               separatorBuilder: (context, index) => const Divider(),
//               itemCount: ok.data.orders.length,
//               itemBuilder: (context, index) {
//                 return PurchaseOrderItem(
//                   order: ok.data.orders[index],
//                 );
//               },
//             );
//           },
//         );
//       } else if (snapshot.hasError) {
//         return MessageScreen.error(snapshot.error.toString());
//       }
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     },
//   );
// }