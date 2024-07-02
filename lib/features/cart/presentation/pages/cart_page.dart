import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/features/order/presentation/pages/checkout_multiple_order_page.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

import '../../../../service_locator.dart';
import '../../../order/domain/repository/order_repository.dart';
import '../../../profile/domain/repository/profile_repository.dart';
import '../../../profile/presentation/pages/address_page.dart';
import '../bloc/cart_bloc.dart';
import '../components/carts_by_shop.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const routeName = 'cart';
  static const path = '/home/cart';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  AddressEntity? _defaultAddress;

  void fetchDefaultAddress() {
    sl<ProfileRepository>().getAllAddress().then((respEither) {
      setState(() {
        _defaultAddress = respEither.fold(
          (_) => null,
          (ok) => ok.data!.firstWhere((element) => element.status == 'ACTIVE'),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDefaultAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _buildBottomSummaryCheckout(),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  _buildAppBarAddress(state, context),
                ];
              },
              body: RefreshIndicator(
                displacement: 18,
                onRefresh: () async {
                  setState(() {
                    context.read<CartBloc>().add(const FetchCart());
                    fetchDefaultAddress();
                  });
                },
                child: state.cart.cartByShopDTOs.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.only(bottom: 60),
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
                    : _buildEmptyCart(context),
              ),
            );
          } else if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CartError) {
            return Center(
              child: Text('Lỗi: ${state.message}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBarAddress(CartLoaded state, BuildContext context) {
    return SliverAppBar(
        title: Text('Giỏ hàng (${state.cart.count})'),
        floating: true,
        backgroundColor: Colors.transparent,
        // bottom: _buildAddress(context), fixed_BUG: rebuild Address when scroll
        bottom: _defaultAddress == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DeliveryAddress(
                    address: _defaultAddress!,
                    onTap: () async {
                      final isChangeSuccess = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (context) => const AddressPage(willPopOnChanged: true),
                        ),
                      );
                  
                      if (isChangeSuccess ?? false) {
                        setState(() {
                          fetchDefaultAddress();
                        });
                      }
                    },
                    prefixIcon: Icons.location_on,
                    padding: const EdgeInsets.all(8),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ));
  }

  Center _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon empty cart
          const Icon(
            Icons.shopping_cart_outlined,
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
    );
  }

  Widget? _buildBottomSummaryCheckout() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          if (state.selectedCartIds.isEmpty || _defaultAddress == null) {
            return const SizedBox();
          }

          return Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5.0)],
            ),
            child: _multiShopOrderSummary(state),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _multiShopOrderSummary(CartLoaded state) {
    return FutureBuilder(
      future: sl<OrderRepository>().createMultiOrderByCartIds(state.selectedCartIds),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final respEither = snapshot.data!;
          return respEither.fold(
            (error) {
              return SingleChildScrollView(child: MessageScreen.error(error.message));
            },
            (ok) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Tổng cộng:'),
                ),
                Text(
                  ConversionUtils.formatCurrency(ok.data!.totalPayment),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    onPressed: () {
                      GoRouter.of(context).go(CheckoutMultipleOrderPage.path, extra: ok.data!);
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
    );
  }

  // FutureBuilder<RespData<OrderDetailEntity>> _singleShop(CartLoaded state) {
  //   return FutureBuilder(
  //     future: sl<OrderRepository>().createOrderByCartIds(state.selectedCartIds),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         final respEither = snapshot.data!;
  //         return respEither.fold(
  //           (error) {
  //             return SingleChildScrollView(child: MessageScreen.error(error.message));
  //           },
  //           (ok) => Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: Text('Tổng cộng:'),
  //               ),
  //               Text(
  //                 ConversionUtils.formatCurrency(ok.data!.order.totalPrice),
  //                 style: const TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  //                   ),
  //                   onPressed: () {
  //                     GoRouter.of(context).go(CheckoutPage.path, extra: ok.data!.order);
  //                   },
  //                   child: const Text('Thanh toán'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );
  // }

  // PreferredSize? _buildAddress(BuildContext context) {
  //   return PreferredSize(
  //     preferredSize: const Size.fromHeight(120),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: FutureBuilder(
  //           future: sl<ProfileRepository>().getAllAddress(),
  //           builder: (context, snapshot) {
  //             if (snapshot.hasData) {
  //               final respEither = snapshot.data!;
  //               return respEither.fold(
  //                 (error) => MessageScreen.error(error.toString()),
  //                 (ok) {
  //                   if (ok.data!.isEmpty) {
  //                     return SizedBox(
  //                       height: 120,
  //                       child: Center(
  //                         child: Text.rich(
  //                           textAlign: TextAlign.center,
  //                           TextSpan(
  //                             text: 'Chưa có địa chỉ giao hàng\n',
  //                             style: const TextStyle(fontWeight: FontWeight.bold),
  //                             children: [
  //                               TextSpan(
  //                                 text: 'Thêm địa chỉ',
  //                                 style: const TextStyle(color: Colors.blue),
  //                                 recognizer: TapGestureRecognizer()
  //                                   ..onTap = () async {
  //                                     await Navigator.of(context).push(MaterialPageRoute(
  //                                       builder: (context) => const AddressPage(willPopOnChanged: true),
  //                                     ));
  //                                   },
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   }
  //                   final defaultAddress = ok.data!.firstWhere((element) => element.status == 'ACTIVE');
  //                   return Address(
  //                     address: defaultAddress,
  //                     onTap: () async {
  //                       final isChangeSuccess = await Navigator.of(context).push<bool>(
  //                         MaterialPageRoute(
  //                           builder: (context) => const AddressPage(willPopOnChanged: true),
  //                         ),
  //                       );

  //                       if (isChangeSuccess ?? false) {
  //                         setState(() {
  //                           fetchDefaultAddress();
  //                         });
  //                       }
  //                     },
  //                     prefixIcon: Icons.location_on,
  //                     padding: const EdgeInsets.all(8),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   );
  //                 },
  //               );
  //             }
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }),
  //     ),
  //   );
  // }
}
