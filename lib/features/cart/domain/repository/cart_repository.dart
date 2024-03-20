import '../../../../core/constants/typedef.dart';
import '../dto/cart_resp.dart';

abstract class CartRepository {
  FRespData<CartResp> getCarts();
  FResp addToCart(int productVariantId, int quantity);
  FResp updateCart(String cartId, int quantity);
  FResp deleteCart(String cartId);
  FResp deleteCartByShopId(String cartId);
}
