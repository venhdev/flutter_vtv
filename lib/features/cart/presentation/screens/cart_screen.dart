import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const routeName = 'cart';
  static const route = '/home/cart';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   forceMaterialTransparency: true,
            //   title: Text('Giỏ hàng (${state.cart.count})'),
            // ),
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Text('Giỏ hàng (${state.cart.count})'),
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: Colors.transparent,
                  ),
                ];
              },
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.cart.cartByShopDTOs.length,
                      itemBuilder: (context, shopIndex) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(state.cart.cartByShopDTOs[shopIndex].shopName),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context
                                      .read<CartBloc>()
                                      .add(DeleteCartByShopId(state.cart.cartByShopDTOs[shopIndex].shopId.toString()));
                                },
                              ),
                            ],
                          ),
                          subtitle: Column(children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.cart.cartByShopDTOs[shopIndex].carts.length,
                              itemBuilder: (context, cartIndex) {
                                return ListTile(
                                  title: Text(state.cart.cartByShopDTOs[shopIndex].carts[cartIndex].productName),
                                  subtitle: Text(state.cart.cartByShopDTOs[shopIndex].carts[cartIndex].quantity.toString()),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      context
                                          .read<CartBloc>()
                                          .add(DeleteCart(state.cart.cartByShopDTOs[shopIndex].carts[cartIndex].cartId));
                                    },
                                  ),
                                );
                              },
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
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
