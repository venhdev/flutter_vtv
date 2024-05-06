import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/features/order/domain/dto/multiple_order_request_param.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../domain/repository/order_repository.dart';
import '../data_sources/order_data_source.dart';
import '../data_sources/payment_data_source.dart';
import '../data_sources/voucher_data_source.dart';

class OrderRepositoryImpl extends OrderRepository {
  OrderRepositoryImpl(this._orderDataSource, this._voucherDataSource, this._paymentDataSource);

  final OrderDataSource _orderDataSource;
  final VoucherDataSource _voucherDataSource;
  final PaymentDataSource _paymentDataSource;

  @override
  FRespData<OrderDetailEntity> createOrderByCartIds(List<String> cartIds) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createByCartIds(cartIds));
  }

  @override
  FRespData<OrderDetailEntity> createUpdateWithCart(OrderRequestWithCartParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createUpdateWithCart(params));
  }

  @override
  FRespData<OrderDetailEntity> placeOrderWithCart(OrderRequestWithCartParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.placeOrderWithCart(params));
  }

  @override
  FRespData<List<VoucherEntity>> voucherListAll() async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.listAll());
  }

  @override
  FRespData<MultiOrderEntity> getListOrders() async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.getListOrders());
  }

  @override
  FRespData<MultiOrderEntity> getListOrdersByStatus(String status) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _orderDataSource.getListOrdersByStatus(status),
    );
  }

  @override
  FRespData<OrderDetailEntity> createByProductVariant(Map<int, int> mapParam) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _orderDataSource.createByProductVariant(mapParam),
    );
  }

  @override
  FRespData<OrderDetailEntity> createUpdateWithVariant(OrderRequestWithVariantParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createUpdateWithVariant(params));
  }

  @override
  FRespData<OrderDetailEntity> placeOrderWithVariant(OrderRequestWithVariantParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.placeOrderWithVariant(params));
  }

  @override
  FRespData<OrderDetailEntity> getOrderDetail(String orderId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.getOrderDetail(orderId));
  }

  @override
  FRespData<OrderDetailEntity> cancelOrder(String orderId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.cancelOrder(orderId));
  }

  @override
  FRespData<MultiOrderEntity> getListOrdersByStatusProcessingAndPickupPending() async {
    //> Custom status PROCESSING + PICKUP_PENDING
    try {
      return Future.wait([
        _orderDataSource.getListOrdersByStatus(OrderStatus.PROCESSING.name),
        _orderDataSource.getListOrdersByStatus(OrderStatus.PICKUP_PENDING.name),
      ]).then((value) {
        final processing = value[0];
        final pickupPending = value[1];
        final MultiOrderEntity result = MultiOrderEntity(
          orders: processing.data!.orders + pickupPending.data!.orders,
          count: processing.data!.count + pickupPending.data!.count,
          totalPayment: processing.data!.totalPayment + pickupPending.data!.totalPayment,
          totalPrice: processing.data!.totalPrice + pickupPending.data!.totalPrice,
        );
        return Right(SuccessResponse<MultiOrderEntity>(data: result));
      });
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FRespData<OrderDetailEntity> completeOrder(String orderId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.completeOrder(orderId));
  }

  @override
  FRespData<MultipleOrderResp> createMultiOrderByCartIds(List<String> cartIds) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createMultiOrderByCartIds(cartIds));
  }

  @override
  FRespData<MultipleOrderResp> createMultiOrderByRequest(MultipleOrderRequestParam params) {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createMultiOrderByRequest(params));
  }

  @override
  FRespData<MultipleOrderResp> placeMultiOrderByRequest(MultipleOrderRequestParam params) {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.placeMultiOrderByRequest(params));
  }

  @override
  FRespData<MultiOrderEntity> getListOrdersByMultiStatus(List<OrderStatus> statuses) async {
    try {
      return Future.wait(statuses.map((status) => _orderDataSource.getListOrdersByStatus(status.name))).then((value) {
        final List<OrderEntity> orders = [];
        int count = 0;
        int totalPayment = 0;
        int totalPrice = 0;

        for (var multiOrder in value) {
          orders.addAll(multiOrder.data!.orders);
          count += multiOrder.data!.count;
          totalPayment += multiOrder.data!.totalPayment;
          totalPrice += multiOrder.data!.totalPrice;
        }

        final MultiOrderEntity result = MultiOrderEntity(
          orders: orders,
          count: count,
          totalPayment: totalPayment,
          totalPrice: totalPrice,
        );
        return Right(SuccessResponse<MultiOrderEntity>(data: result));
      });
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FRespData<String> createPaymentForMultiOrder(List<String> orderIds) async {
    return handleDataResponseFromDataSource(
        dataCallback: () => _paymentDataSource.createPaymentForMultiOrder(orderIds));
  }

  @override
  FRespData<String> createPaymentForSingleOrder(String orderId) async {
    return handleDataResponseFromDataSource(
        dataCallback: () => _paymentDataSource.createPaymentForSingleOrder(orderId));
  }
}
