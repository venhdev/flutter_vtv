import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../dto/multiple_order_request_param.dart';

abstract class OrderRepository {
  //! -------------order-controller-------------
  //* Create Temp Order With Cart
  FRespData<OrderDetailEntity> createOrderByCartIds(List<String> cartIds);
  FRespData<OrderDetailEntity> createUpdateWithCart(OrderRequestWithCartParam params);
  //* Create Temp Order With Product Variant
  FRespData<OrderDetailEntity> createByProductVariant(Map<int, int> mapParam); //int productVariantId, int quantity
  FRespData<OrderDetailEntity> createUpdateWithVariant(OrderRequestWithVariantParam params);

  //# Place Order
  FRespData<OrderDetailEntity> placeOrderWithCart(OrderRequestWithCartParam params);
  FRespData<OrderDetailEntity> placeOrderWithVariant(OrderRequestWithVariantParam params);

  //# Multi Order
  FRespData<MultipleOrderResp> createMultiOrderByCartIds(List<String> cartIds);
  FRespData<MultipleOrderResp> createMultiOrderByRequest(MultipleOrderRequestParam params);
  FRespData<MultipleOrderResp> placeMultiOrderByRequest(MultipleOrderRequestParam params);

  //# Purchase - Manage orders
  /// Get all orders
  FRespData<MultiOrderEntity> getListOrders();

  /// Get orders by status
  /// - [status] is enum OrderStatus string name (e.g. 'PENDING')
  FRespData<MultiOrderEntity> getListOrdersByStatus(String status);
  //custom status PROCESSING + PICKUP_PENDING
  FRespData<MultiOrderEntity> getListOrdersByStatusProcessingAndPickupPending();
  FRespData<MultiOrderEntity> getListOrdersByMultiStatus(List<OrderStatus> statuses);

  /// Get order detail by orderId
  FRespData<OrderDetailEntity> getOrderDetail(String orderId);
  FRespData<OrderDetailEntity> cancelOrder(String orderId);
  FRespData<OrderDetailEntity> completeOrder(String orderId);

  // custom to check order status (multi order) when process payment
  FRespData<List<OrderDetailEntity>> getMultiOrderDetailForCheckPayment(List<String> orderIds);
  //! -------------order-controller-------------

  //*-------------------------------------------------vn-pay-controller---------------------------------------------------*//
  //# vn-pay-controller
  FRespData<String> createPaymentForSingleOrder(String orderId);
  FRespData<String> createPaymentForMultiOrder(List<String> orderIds);

  //! Voucher
  FRespData<List<VoucherEntity>> voucherListAll();
}
