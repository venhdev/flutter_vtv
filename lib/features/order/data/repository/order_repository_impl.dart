import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';
import 'package:flutter_vtv/features/cart/domain/dto/order_resp.dart';
import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';
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
  FRespData<OrderResp> createUpdateWithCart(PlaceOrderParam param) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.createUpdateWithCart(param));
  }

  @override
  FRespData<OrderResp> placeOrder(PlaceOrderParam params) async {
    return handleDataResponseFromDataSource(dataCallback: () => _orderDataSource.placeOrder(params));
  }

  @override
  FRespData<List<VoucherEntity>> voucherListAll() async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.listAll());
  }
}
