import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vtv/core/helpers/helpers.dart';

import '../../../../core/presentation/components/custom_buttons.dart';
import '../../../../core/presentation/components/custom_dialogs.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/response/cart_by_shop_dto.dart';
import '../bloc/cart_bloc.dart';

class CartsByShop extends StatefulWidget {
  const CartsByShop(
    this.cartByShop, {
    super.key,
  });

  final CartByShopDTO cartByShop;

  @override
  State<CartsByShop> createState() => _CartsByShopState();
}

class _CartsByShopState extends State<CartsByShop> {
  void _handleDeleteSingleCart(String cartId) {
    context.read<CartBloc>().add(DeleteCart(cartId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        // bottom border
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // shop info
          _buildShopInfo(context),
          // carts in shop
          _buildListOfCarts(),
        ],
      ),
    );
  }

  ListView _buildListOfCarts() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.cartByShop.carts.length,
      itemBuilder: (context, cartIndex) {
        return Slidable(
          // The start action pane is the one at the left or the top side.
          endActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.share,
                label: 'Share',
              ),
              SlidableAction(
                onPressed: (context) async {
                  // show dialog to confirm delete
                  // context.read<CartBloc>().add(DeleteCart(cartByShop.carts[cartIndex].cartId));
                  final isConfirm = await showMyDialogToConfirm(
                    context: context,
                    title: 'Xóa khỏi giỏ hàng',
                    content: 'Bạn có chắc chắn muốn xóa?',
                  );
                  if (isConfirm) {
                    _handleDeleteSingleCart(widget.cartByShop.carts[cartIndex].cartId);
                  }
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Xóa',
              ),
            ],
          ),
          child: CartItem(widget.cartByShop.carts[cartIndex]),
        );
      },
    );
  }
  // Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) {
  //             return Scaffold(
  //               appBar: AppBar(
  //                 title: Text(widget.cartByShop.shopName),
  //               ),
  //               body: const Center(
  //                 child: Text('Shop detail'),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  // context.read<CartBloc>().add(DeleteCartByShopId(widget.cartByShop.shopId.toString()));

  Widget _buildShopInfo(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // checkbox
        Checkbox(
          value: false,
          onChanged: (value) {},
        ),
        IconTextButton(
          icon: Icons.storefront_sharp,
          text: widget.cartByShop.shopName,
          onPressed: () {
            // navigate to shop detail
          },
        ),
      ],
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Text(
    //       widget.cartByShop.shopName,
    //       style: const TextStyle(
    //         fontSize: 18,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     IconButton(
    //       icon: const Icon(Icons.delete),
    //       onPressed: () {
    //         context.read<CartBloc>().add(DeleteCartByShopId(widget.cartByShop.shopId.toString()));
    //       },
    //     ),
    //   ],
    // );
  }
}

class CartItem extends StatelessWidget {
  const CartItem(
    this.cart, {
    super.key,
  });

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // checkbox
              Checkbox(
                value: false,
                onChanged: (value) {},
              ),
              // product info (image, name, price, quantity, total price, delete button)
              Image.network(
                cart.productImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(formatCurrency(cart.productVariant.price),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    )),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {},
                    ),
                    Text(cart.quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return ListTile(
    //   title: Text(widget.cartByShop.carts[cartIndex].productName),
    //   subtitle: Text(widget.cartByShop.carts[cartIndex].quantity.toString()),
    //   trailing: IconButton(
    //     icon: const Icon(Icons.delete),
    //     onPressed: () {},
    //   ),
    // );
  }
}
