import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/enum.dart';
import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/presentation/components/image_cacheable.dart';
import '../../../../../core/presentation/pages/photo_view.dart';
import '../../../../../service_locator.dart';
import '../../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../../order/domain/repository/order_repository.dart';
import '../../../../order/presentation/pages/checkout_page.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/product_variant_entity.dart';

class SheetAddToCartOrBuyNow extends StatefulWidget {
  const SheetAddToCartOrBuyNow({
    super.key,
    required this.product,
    this.isBuyNow = false,
  });

  final ProductEntity product;
  final bool isBuyNow;

  @override
  State<SheetAddToCartOrBuyNow> createState() => _SheetAddToCartOrBuyNowState();
}

class _SheetAddToCartOrBuyNowState extends State<SheetAddToCartOrBuyNow> {
  ProductVariantEntity? _variant;
  int _quantity = 0;

  String priceString() {
    if (_variant != null) {
      return formatCurrency(_variant!.price);
    }
    if (widget.product.cheapestPrice == widget.product.mostExpensivePrice) {
      return formatCurrency(widget.product.cheapestPrice);
    }
    return '${formatCurrency(widget.product.cheapestPrice)} - ${formatCurrency(widget.product.mostExpensivePrice)}';
  }

  void handleTapAddToCartOrBuyNow() async {
    // check if variant is selected
    if (_variant != null) {
      // ? create temp order and navigate to checkout page || else just add to cart
      if (widget.isBuyNow) {
        final respEither = await sl<OrderRepository>().createByProductVariant(_variant!.productVariantId, _quantity);

        respEither.fold(
          (error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(error.message!),
                ),
              );
          },
          (ok) {
            // context.go('${CheckoutPage.path}?isCreateWithCart=false', extra: ok.data.order);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutPage(
                  isCreateWithCart: false,
                  order: ok.data.order,
                ),
              ),
            );
          },
        );
      } else {
        context.read<CartBloc>().add(AddToCart(_variant!.productVariantId, _quantity));
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //# Image, price, quantity
          _buildSummaryInfo(context),
          const Divider(color: Colors.grey),

          //# variant
          const Text('Phân loại', style: TextStyle(fontWeight: FontWeight.bold)),
          _buildSelectableVariants(context),
          const Divider(color: Colors.grey),

          //# attribute
          // TODO: Attribute selector => variant
          const Text('Thuộc tính', style: TextStyle(fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _variant?.attributes.length ?? 0,
            itemBuilder: (context, index) {
              final attribute = _variant!.attributes[index];
              return ListTile(
                title: Text(attribute.name),
                subtitle: Text(attribute.value),
              );
            },
          ),

          //# quantity selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  if (_quantity > 1) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              Text(
                'Số lượng: ${_variant != null ? _quantity : 0}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_variant != null) {
                    if (_quantity < _variant!.quantity) {
                      setState(() {
                        _quantity++;
                      });
                    }
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          // Add to cart button
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state.message != null) {
                Fluttertoast.showToast(msg: state.message!);
              }
            },
            child: ElevatedButton(
              // change backgroundColor
              style: ElevatedButton.styleFrom(
                backgroundColor: _variant != null ? Colors.orange[300] : Colors.grey[300],
              ),
              onPressed: handleTapAddToCartOrBuyNow,
              child: Text(widget.isBuyNow ? 'Mua ngay' : 'Thêm vào giỏ'),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildSelectableVariants(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: widget.product.productVariants
              .map(
                (variant) => Badge(
                  isLabelVisible: variant.quantity == 0 || variant.status != Status.ACTIVE.name,
                  label: Text(variant.status),
                  backgroundColor: Colors.red.shade700,
                  offset: const Offset(-24, -8),
                  child: ChoiceChip(
                    labelPadding: EdgeInsets.zero,
                    padding: const EdgeInsets.all(4),
                    showCheckmark: false,
                    selected: _variant == variant,
                    onSelected: (variant.quantity == 0 || variant.status != Status.ACTIVE.name)
                        ? null
                        : (selected) {
                            setState(() {
                              _variant = selected ? variant : null;
                              _quantity = 1;
                            });
                          },
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageCacheable(
                          variant.image.isNotEmpty ? variant.image : widget.product.image,
                          height: 38,
                          width: 38,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          variant.sku,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Row _buildSummaryInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewPage(
                  imageUrl: _variant?.image.isNotEmpty ?? false ? _variant!.image : widget.product.image,
                ),
              ),
            );
          },
          child: ImageCacheable(
            (_variant?.image.isNotEmpty ?? false) ? _variant!.image : widget.product.image,
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(text: 'Giá: '),
                  TextSpan(
                    text: priceString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            if (_variant?.quantity != null) Text('Còn lại: ${_variant?.quantity}'),
          ],
        )
      ],
    );
  }
}
