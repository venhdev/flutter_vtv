import 'package:vtv_common/vtv_common.dart';

abstract class CartRepository {
  FRespData<CartResp> getCarts();
  FRespEither addToCart(int productVariantId, int quantity);
  FRespEither updateCart(String cartId, int quantity);
  FRespEither deleteCart(String cartId);
  FRespEither deleteCartByShopId(String cartId);
}
