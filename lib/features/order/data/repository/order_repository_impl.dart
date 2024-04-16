import 'package:dartz/dartz.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../domain/repository/order_repository.dart';
import '../data_sources/order_data_source.dart';
import '../data_sources/voucher_data_source.dart';

class OrderRepositoryImpl extends OrderRepository {
  OrderRepositoryImpl(this._orderDataSource, this._voucherDataSource);

  final OrderDataSource _orderDataSource;
  final VoucherDataSource _voucherDataSource;

  @override
  FRespData<OrderDetailEntity> createOrderByCartIds(List<String> cartIds) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createByCartIds(cartIds));
  }

  @override
  FRespData<OrderDetailEntity> createUpdateWithCart(PlaceOrderWithCartParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createUpdateWithCart(params));
  }

  @override
  FRespData<OrderDetailEntity> placeOrderWithCart(PlaceOrderWithCartParam params) async {
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
  FRespData<OrderDetailEntity> createByProductVariant(Map<int,int> mapParam) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _orderDataSource.createByProductVariant(mapParam),
    );
  }

  @override
  FRespData<OrderDetailEntity> createUpdateWithVariant(PlaceOrderWithVariantParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createUpdateWithVariant(params));
  }

  @override
  FRespData<OrderDetailEntity> placeOrderWithVariant(PlaceOrderWithVariantParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.placeOrderWithVariant(params));
  }

  @override
  FRespData<OrderDetailEntity> getOrderDetail(String orderId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.getOrderDetail(orderId));
  }

  @override
  FRespData<OrderDetailEntity> getOrderCancel(String orderId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.getOrderCancel(orderId));
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
          orders: processing.data.orders + pickupPending.data.orders,
        );
        return Right(DataResponse<MultiOrderEntity>(result));
      });
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }
}
