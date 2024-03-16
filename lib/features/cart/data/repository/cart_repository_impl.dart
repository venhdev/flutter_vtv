import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';
import 'package:flutter_vtv/features/cart/domain/repository/cart_repository.dart';
import 'package:flutter_vtv/features/cart/domain/response/cart_resp.dart';

import '../data_sources/cart_data_source.dart';

class CartRepositoryImpl extends CartRepository {
  CartRepositoryImpl(this.cartDataSource);

  final CartDataSource cartDataSource;

  @override
  FRespData<CartResp> getCarts() async {
    return handleDataResponseFromDataSource(
      dataCallback: () => cartDataSource.getCarts(),
    );
  }

  @override
  FResp addToCart(int productVariantId, int quantity) {
    return handleSuccessResponseFromDataSource(
      noDataCallback: () => cartDataSource.addToCart(productVariantId, quantity),
    );
  }

  @override
  FResp deleteCart(String cartId) async {
    return handleSuccessResponseFromDataSource(
      noDataCallback: () => cartDataSource.deleteToCart(cartId),
    );
  }

  @override
  FResp deleteCartByShopId(String cartId) async {
    return handleSuccessResponseFromDataSource(
      noDataCallback: () => cartDataSource.deleteToCartByShopId(cartId),
    );
  }
}
