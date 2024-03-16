import '../../../../core/constants/typedef.dart';
import '../response/cart_resp.dart';

abstract class CartRepository {
  FRespData<CartResp> getCarts();
  FResp addToCart(int productVariantId, int quantity);
  FResp deleteCart(String cartId);
  FResp deleteCartByShopId(String cartId);
}
