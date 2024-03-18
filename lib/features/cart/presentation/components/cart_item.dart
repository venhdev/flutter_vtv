import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/helpers/helpers.dart';
import '../../domain/entities/cart_entity.dart';
import '../bloc/cart_bloc.dart';

class CartItem extends StatefulWidget {
  const CartItem(
    this.cart, {
    super.key,
  });

  final CartEntity cart;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void _handleDeleteSingleCart(String cartId) {
    context.read<CartBloc>().add(DeleteCart(cartId));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Slidable(
        endActionPane: _slideEnd(),
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
                  widget.cart.productImage!,
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
                    widget.cart.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(formatCurrency(widget.cart.productVariant.price),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      )),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          context.read<CartBloc>().add(UpdateCart(widget.cart.cartId, -1));
                          // sl<CartRepository>().updateCart(
                          //   widget.cart.cartId,
                          //   -1,
                          // );
                        },
                      ),
                      Text(widget.cart.quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          context.read<CartBloc>().add(UpdateCart(widget.cart.cartId, 1));
                          // sl<CartRepository>().updateCart(
                          //   widget.cart.cartId,
                          //   1,
                          // );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

  ActionPane _slideEnd() {
    return ActionPane(
      // A motion is a widget used to control how the pane animates.
      motion: const ScrollMotion(),

      // All actions are defined in the children parameter.
      children: [
        // A SlidableAction can have an icon and/or a label.
        // SlidableAction(
        //   onPressed: (context) {},
        //   backgroundColor: const Color(0xFF21B7CA),
        //   foregroundColor: Colors.white,
        //   icon: Icons.share,
        //   label: 'Share',
        // ),
        SlidableAction(
          onPressed: (context) async {
            // show dialog to confirm delete
            // context.read<CartBloc>().add(DeleteCart(cartByShop.carts[cartIndex].cartId));
            // final isConfirm = await showMyDialogToConfirm(
            //   context: context,
            //   title: 'Xóa khỏi giỏ hàng',
            //   content: 'Bạn có chắc chắn muốn xóa?',
            // );
            _handleDeleteSingleCart(widget.cart.cartId);
            // if (isConfirm) {
            // }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Xóa',
        ),
      ],
    );
  }
}
