import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';

import '../../../../core/constants/typedef.dart';
import '../../../cart/domain/dto/order_resp.dart';
import '../entities/voucher_entity.dart';

abstract class OrderRepository {
  FRespData<OrderResp> createOrderByCartIds(List<String> cartIds);
  /// Use to change order status (in checkout page)
  FRespData<OrderResp> createUpdateWithCart(PlaceOrderParam param);

  // Place order
  FRespData<OrderResp> placeOrder(PlaceOrderParam params);

  //! Voucher
  FRespData<List<VoucherEntity>> voucherListAll();
}
