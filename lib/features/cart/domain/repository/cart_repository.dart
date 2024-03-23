import '../../../../core/constants/typedef.dart';
import '../dto/cart_resp.dart';
import '../dto/order_resp.dart';

abstract class CartRepository {
  FRespData<CartResp> getCarts();
  FRespEither addToCart(int productVariantId, int quantity);
  FRespEither updateCart(String cartId, int quantity);
  FRespEither deleteCart(String cartId);
  FRespEither deleteCartByShopId(String cartId);

  // Order
  FRespData<OrderResp> createOrderByCartIds(List<String> cartIds);
}
