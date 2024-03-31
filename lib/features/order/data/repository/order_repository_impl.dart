import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';
import 'package:flutter_vtv/features/cart/domain/dto/order_resp.dart';
import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';
import 'package:flutter_vtv/features/order/domain/dto/place_order_with_variant_param.dart';
import 'package:flutter_vtv/features/order/domain/entities/voucher_entity.dart';

import '../../domain/repository/order_repository.dart';
import '../data_sources/order_data_source.dart';
import '../data_sources/voucher_data_source.dart';

class OrderRepositoryImpl extends OrderRepository {
  OrderRepositoryImpl(this._orderDataSource, this._voucherDataSource);

  final OrderDataSource _orderDataSource;
  final VoucherDataSource _voucherDataSource;

  @override
  FRespData<OrderResp> createOrderByCartIds(List<String> cartIds) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createByCartIds(cartIds));
  }

  @override
  FRespData<OrderResp> createUpdateWithCart(PlaceOrderWithCartParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createUpdateWithCart(params));
  }

  @override
  FRespData<OrderResp> placeOrderWithCart(PlaceOrderWithCartParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.placeOrderWithCart(params));
  }

  @override
  FRespData<List<VoucherEntity>> voucherListAll() async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.listAll());
  }

  @override
  FRespData<OrdersResp> getListOrders() async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.getListOrders());
  }

  @override
  FRespData<OrdersResp> getListOrdersByStatus(String status) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _orderDataSource.getListOrdersByStatus(status),
    );
  }

  @override
  FRespData<OrderResp> createByProductVariant(int productVariantId, int quantity) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _orderDataSource.createByProductVariant(productVariantId, quantity),
    );
  }

  @override
  FRespData<OrderResp> createUpdateWithVariant(PlaceOrderWithVariantParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createUpdateWithVariant(params));
  }

  @override
  FRespData<OrderResp> placeOrderWithVariant(PlaceOrderWithVariantParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.placeOrderWithVariant(params));
  }
}
