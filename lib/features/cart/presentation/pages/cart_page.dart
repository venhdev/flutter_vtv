import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/features/cart/domain/dto/address_dto.dart';
import 'package:go_router/go_router.dart';

import '../../../../service_locator.dart';
import '../../data/data_sources/cart_data_source.dart';
import '../bloc/cart_bloc.dart';
import '../components/address_summary.dart';
import '../components/carts_by_shop.dart';
import 'address_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const routeName = 'cart';
  static const pathName = 'cart';
  static const path = '/home/cart';

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
                  bottom: _buildAddress(context),
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

  PreferredSize _buildAddress(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: sl<CartDataSource>().getAllAddress(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // find the default address has "status": "ACTIVE",
                final defaultAddress = snapshot.data!.data.firstWhere((element) => element.status == 'ACTIVE');
                return AddressSummary(
                  onTap: () => GoRouter.of(context).go(AddressPage.path),
                  address:
                      '${defaultAddress.fullAddress!}, ${defaultAddress.wardFullName!}, ${defaultAddress.districtFullName!}, ${defaultAddress.provinceFullName!}',
                  receiver: defaultAddress.fullName!,
                  phone: defaultAddress.phone!,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
