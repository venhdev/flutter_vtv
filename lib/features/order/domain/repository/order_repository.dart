import 'package:flutter_vtv/features/order/domain/dto/place_order_param.dart';

import '../../../../core/constants/typedef.dart';
import '../dto/order_detail_entity.dart';
import '../dto/place_order_with_variant_param.dart';
import '../entities/multi_order_entity.dart';
import '../entities/voucher_entity.dart';

abstract class OrderRepository {
  //! Create Temp Order
  //* With Cart
  FRespData<OrderDetailEntity> createOrderByCartIds(List<String> cartIds);
  FRespData<OrderDetailEntity> createUpdateWithCart(PlaceOrderWithCartParam params); // Use to change order status (in checkout page)
  //* With Product Variant
  FRespData<OrderDetailEntity> createByProductVariant(int productVariantId, int quantity);
  FRespData<OrderDetailEntity> createUpdateWithVariant(PlaceOrderWithVariantParam params);

  //! Place Order
  FRespData<OrderDetailEntity> placeOrderWithCart(PlaceOrderWithCartParam params);
  FRespData<OrderDetailEntity> placeOrderWithVariant(PlaceOrderWithVariantParam params);

  //! Voucher
  FRespData<List<VoucherEntity>> voucherListAll();

  //! Purchase - Manage orders
  /// Get all orders
  FRespData<MultiOrderEntity> getListOrders();
  /// Get orders by status
  /// - [status] is enum OrderStatus string name (e.g. 'PENDING')
  FRespData<MultiOrderEntity> getListOrdersByStatus(String status);
}
