import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../components/carts_by_shop.dart';

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
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Text('Giỏ hàng (${state.cart.count})'),
                    floating: true,
                    backgroundColor: Colors.transparent,
                  ),
                ];
              },
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.cart.cartByShopDTOs.length,
                      itemBuilder: (context, shopIndex) {
                        return CartsByShop(state.cart.cartByShopDTOs[shopIndex]);
                      },
                    ),
                  ),
                  // total price
                  Container(
                    color: Colors.yellow,
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
