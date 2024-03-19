import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/presentation/components/image_cacheable.dart';
import '../../../../../core/presentation/pages/photo_view.dart';
import '../../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/product_variant_entity.dart';

class BottomSheetAddToCart extends StatefulWidget {
  const BottomSheetAddToCart({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  State<BottomSheetAddToCart> createState() => _BottomSheetAddToCartState();
}

class _BottomSheetAddToCartState extends State<BottomSheetAddToCart> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                  Text('Còn lại: ${_variant?.quantity ?? 0}'),
                ],
              )
            ],
          ),
          const Divider(color: Colors.grey),
          const Text('Phân loại'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: widget.product.productVariant
                    .map(
                      (variant) => ChoiceChip(
                        labelPadding: EdgeInsets.zero,
                        padding: const EdgeInsets.all(4),
                        showCheckmark: false,
                        selected: _variant == variant,
                        onSelected: (selected) {
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
                    )
                    .toList(),
              ),
            ),
          ),
          const Divider(color: Colors.grey),

          // attribute
          // Text(_variant!.attributes.toString()),

          // quantity
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
          ElevatedButton(
            // change backgroundColor
            style: ElevatedButton.styleFrom(
              backgroundColor: _variant != null ? Colors.orange[300] : Colors.grey[300],
            ),
            onPressed: () {
              if (_variant != null) {
                context.read<CartBloc>().add(AddToCart(_variant!.productVariantId, _quantity));
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm vào giỏ'),
          ),
        ],
      ),
    );
  }
}
