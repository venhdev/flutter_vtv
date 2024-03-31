import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';

import '../../../../core/constants/typedef.dart';
import '../../../cart/domain/dto/order_resp.dart';
import '../dto/place_order_with_variant_param.dart';
import '../entities/voucher_entity.dart';

abstract class OrderRepository {
  //! Create Temp Order
  //* With Cart
  FRespData<OrderResp> createOrderByCartIds(List<String> cartIds);
  FRespData<OrderResp> createUpdateWithCart(PlaceOrderWithCartParam params); // Use to change order status (in checkout page)
  //* With Product Variant
  FRespData<OrderResp> createByProductVariant(int productVariantId, int quantity);
  FRespData<OrderResp> createUpdateWithVariant(PlaceOrderWithVariantParam params);

  //! Place Order
  FRespData<OrderResp> placeOrderWithCart(PlaceOrderWithCartParam params);
  FRespData<OrderResp> placeOrderWithVariant(PlaceOrderWithVariantParam params);

  //! Voucher
  FRespData<List<VoucherEntity>> voucherListAll();

  //! Purchase - Manage orders
  /// Get all orders
  FRespData<OrdersResp> getListOrders();
  /// Get orders by status
  /// - [status] is enum OrderStatus string name (e.g. 'PENDING')
  FRespData<OrdersResp> getListOrdersByStatus(String status);
}
