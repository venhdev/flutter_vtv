import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../../service_locator.dart';
import '../../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../../order/domain/repository/order_repository.dart';
import '../../../../order/presentation/pages/checkout_page.dart';

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
  final Map<String, String> _selectedAttributes = {};

  String priceString() {
    if (_variant != null) {
      return StringHelper.formatCurrency(_variant!.price);
    }
    if (widget.product.cheapestPrice == widget.product.mostExpensivePrice) {
      return StringHelper.formatCurrency(widget.product.cheapestPrice);
    }
    return '${StringHelper.formatCurrency(widget.product.cheapestPrice)} - ${StringHelper.formatCurrency(widget.product.mostExpensivePrice)}';
  }

  void handlePressedAddToCartOrBuyNow() async {
    // check if variant is selected
    if (_variant != null) {
      // ? create temp order and navigate to checkout page || else just add to cart
      if (widget.isBuyNow) {
        final respEither = await sl<OrderRepository>().createByProductVariant({_variant!.productVariantId: _quantity});

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
            context.pop(); // pop out the bottom sheet
            context.push(
              Uri(path: CheckoutPage.path, queryParameters: {'isCreateWithCart': 'false'}).toString(),
              extra: ok.data!,
            );
          },
        );
      } else {
        context.read<CartBloc>().add(AddToCart(_variant!.productVariantId, _quantity));
        context.pop();
      }
    }
  }

  bool isValidVariant(ProductVariantEntity variant) {
    for (var selectedAttributeName in _selectedAttributes.keys) {
      final needCheck = variant.attributes.firstWhere((attribute) => attribute.name == selectedAttributeName);
      if (needCheck.value != _selectedAttributes[selectedAttributeName]) {
        return false;
      }
    }
    return true;
  }

  /// get current valid variants
  List<ProductVariantEntity> getValidVariants() {
    final validVariants = <ProductVariantEntity>[];

    //: check if all selected attributes are matched with the variant's attributes
    if (_selectedAttributes.isEmpty) {
      //> there is no selected attribute > return all variants where status is ACTIVE & quantity > 0
      return widget.product.productVariants
          .where((variant) => (variant.status == Status.ACTIVE.name && variant.quantity > 0))
          .toList();
    } else {
      final activeVariants = widget.product.productVariants
          .where((variant) => (variant.status == Status.ACTIVE.name && variant.quantity > 0))
          .toList();

      for (var variant in activeVariants) {
        if (isValidVariant(variant)) {
          // && !validVariants.contains(variant)
          validVariants.add(variant);
        }
      }
    }

    return validVariants;
  }

  bool isValidAttribute(String attributeName, String valueName) {
    for (var validVariant in getValidVariants()) {
      for (var validAttribute in validVariant.attributes) {
        if (validAttribute.name == attributeName && validAttribute.value == valueName) {
          return true;
        }
      }
    }
    return false;
  }

  void Function(bool)? handleSelectAttribute(String attribute, String value) {
    //? this return a function that will be assigned to the onSelected property of the ChoiceChip
    // if valid > the function will not null >> make UI available to select/deselect
    // else the function will be null and the UI will be disabled

    if (isValidAttribute(attribute, value)) {
      return (selected) {
        if (!selected) {
          setState(() {
            _selectedAttributes.remove(attribute);
            checkCurrentVariant();
          });
        } else {
          setState(() {
            _selectedAttributes[attribute] = value;
            checkCurrentVariant();
          });
        }
      };
    } else {
      return null;
    }
  }

  void checkCurrentVariant() {
    final validVariants = getValidVariants();
    log('has ${validVariants.length} validVariants: ${validVariants.map((e) => e.sku).toList()}');

    // when there is only one valid variant
    if (validVariants.length == 1) {
      // check if all variant's attributes are matched with the selected attributes
      //> e.g. if there are only 1 valid variant with 3 attributes, but only 2 attributes are selected >> not valid
      if (validVariants.first.attributes.length == _selectedAttributes.length) {
        _variant = validVariants.first;
        _quantity = 1;
      } else {
        _variant = null;
        _quantity = 0;
      }
    } else {
      _variant = null;
      _quantity = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //# Image, price, quantity
            _buildSummaryInfo(context),
            const Divider(color: Colors.grey),

            //# variant & attribute
            const Text('Phân loại', style: TextStyle(fontWeight: FontWeight.bold)),
            widget.product.hasAttribute ? _buildSelectableAttributes() : _buildSelectableVariants(),
            const Divider(color: Colors.grey),

            //# quantity selector
            _buildEditQuantityBtn(),

            // Add to cart button
            _buildAddToCartOrBuyNowBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartOrBuyNowBtn() {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state.message != null) {
          Fluttertoast.showToast(msg: state.message!);
        }
      },
      child: ElevatedButton(
        // change backgroundColor
        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryContainer),
        // onPressed: handlePressedAddToCartOrBuyNow,
        onPressed: (_variant != null && (_variant!.quantity > 0)) ? handlePressedAddToCartOrBuyNow : null,
        child: Text(widget.isBuyNow ? 'Mua ngay' : 'Thêm vào giỏ'),
      ),
    );
  }

  Widget _buildEditQuantityBtn() {
    final canEditQuantity = _variant != null && _variant!.quantity > 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: canEditQuantity && _quantity > 1
              ? () {
                  setState(() {
                    _quantity--;
                  });
                }
              : null,
          icon: const Icon(Icons.remove),
        ),
        Text(
          'Số lượng: ${(_variant != null && _variant!.quantity > 0) ? _quantity : 0}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: canEditQuantity && _quantity < _variant!.quantity
              ? () {
                  setState(() {
                    _quantity++;
                  });
                }
              : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildSelectableAttributes() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var attribute in widget.product.getAllVariantAttributes.keys)
          ListTile(
            title: Text(attribute),
            subtitle: Wrap(
              spacing: 4,
              children: [
                for (var value in widget.product.getAllVariantAttributes[attribute]!.keys)
                  ChoiceChip(
                    label: Text(value),
                    selected: _selectedAttributes[attribute] == value,
                    onSelected: handleSelectAttribute(attribute, value),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSelectableVariants() {
    return Wrap(
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
    );
  }

  Widget _buildSummaryInfo(BuildContext context) {
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
            // Variant name
            if (_variant != null)
              Text(
                _variant!.sku,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

            if (!widget.product.inStock)
              const Text(
                'Hết hàng',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

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
