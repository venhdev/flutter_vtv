import 'package:flutter/material.dart';

import '../../../../core/presentation/components/custom_buttons.dart';
import '../../domain/response/cart_by_shop_dto.dart';
import 'cart_item.dart';

class CartsByShop extends StatelessWidget {
  const CartsByShop(
    this.cartByShop, {
    super.key,
    required this.onUpdateCartCallback,
  });

  final CartByShopDTO cartByShop;
  final Function(String cartId, int quantity, int cartIndex) onUpdateCartCallback;

  @override
  Widget build(BuildContext context) {
    debugPrint('[CartsByShop] render length: ${cartByShop.carts.length}');
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
      itemCount: cartByShop.carts.length,
      itemBuilder: (context, cartIndex) {
        return CartItem(
          cartByShop.carts[cartIndex],
          onUpdateCartCallback: (cartId, quantity) {
            // context.read<CartBloc>().add(UpdateCart(cartId, quantity));
            onUpdateCartCallback(cartId, quantity, cartIndex);
          },
        );
      },
    );
  }

  // Navigator.of(context).push(
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
          text: cartByShop.shopName,
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
