import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cart_bloc.dart';
import '../components/address_summary.dart';
import '../components/carts_by_shop.dart';
import 'address_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const routeName = 'cart';
  static const route = '/home/cart';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text('Giỏ hàng (${state.cart.count})'),
                  floating: true,
                  backgroundColor: Colors.transparent,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddressSummary(
                        onTap: () => GoRouter.of(context).go(AddressPage.route),
                        address: 'Hà Nội, Việt Nam Hà Nội, Việt NamHà Nội, Việt Nam vHà Nội, Việt Nam',
                        receiver: 'Nguyễn Văn A',
                        phone: '8172468364',
                        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              displacement: 18,
              onRefresh: () async {
                context.read<CartBloc>().add(FetchCart());
              },
              child: state.cart.cartByShopDTOs.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
                      itemCount: state.cart.cartByShopDTOs.length,
                      itemBuilder: (context, shopIndex) {
                        return CartsByShop(
                          state.cart.cartByShopDTOs[shopIndex],
                          onUpdateCartCallback: (cartId, quantity, cartIndex) {
                            context.read<CartBloc>().add(UpdateCart(
                                  cartId: cartId,
                                  quantity: quantity,
                                  cartIndex: cartIndex,
                                  shopIndex: shopIndex,
                                ));
                          },
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // icon empty cart
                          const Icon(
                            Icons.remove_shopping_cart_rounded,
                            size: 50,
                          ),
                          const Text('Giỏ hàng trống'),
                          // button continue shopping
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context).go('/home');
                            },
                            child: const Text('Tiếp tục mua sắm', style: TextStyle(decoration: TextDecoration.underline)),
                          )
                        ],
                      ),
                    ),
            ),
          );
        } else if (state is CartLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CartError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
