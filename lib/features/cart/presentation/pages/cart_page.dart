import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/presentation/components/custom_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../service_locator.dart';
import '../../../profile/domain/repository/profile_repository.dart';
import '../../../profile/presentation/screens/address_page.dart';
import '../../domain/repository/cart_repository.dart';
import '../bloc/cart_bloc.dart';
import '../components/address_summary.dart';
import '../components/carts_by_shop.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const routeName = 'cart';
  static const path = '/home/cart';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.selectedCartIds.isEmpty) {
              return const SizedBox();
            }
            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: FutureBuilder(
                future: sl<CartRepository>().createOrderByCartIds(state.selectedCartIds),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final respEither = snapshot.data!;
                    return respEither.fold(
                      (error) {
                        return MessageScreen.error(error.message.toString());
                      },
                      (ok) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Tổng cộng: '),
                          ),
                          Text(
                            formatCurrency(ok.data.order.totalPrice),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                GoRouter.of(context).go('/home/cart/checkout');
                              },
                              child: const Text('Thanh toán'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      body: BlocBuilder<CartBloc, CartState>(
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
                            // onSelected: (cartId) {
                            //   setState(() {});
                            // },
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
                              child: const Text(
                                'Tiếp tục mua sắm',
                                style: TextStyle(decoration: TextDecoration.underline),
                              ),
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
      ),
    );
  }

  PreferredSize _buildAddress(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: sl<ProfileRepository>().getAllAddress(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // find the default address has "status": "ACTIVE",
                final respEither = snapshot.data!;
                return respEither.fold(
                  (error) => MessageScreen.error(error.toString()),
                  (ok) {
                    final defaultAddress =
                        ok.data.firstWhere((element) => element.status == 'ACTIVE');
                    return AddressSummary(
                      onTap: () {
                        // GoRouter.of(context).go(AddressPage.path);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddressPage(),
                          ),
                        );
                      },
                      address:
                          '${defaultAddress.fullAddress}, ${defaultAddress.wardFullName}, ${defaultAddress.districtFullName}, ${defaultAddress.provinceFullName}',
                      receiver: defaultAddress.fullName,
                      phone: defaultAddress.phone,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                    );
                  },
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
