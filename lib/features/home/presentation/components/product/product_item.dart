import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../../service_locator.dart';
import '../../../domain/repository/product_repository.dart';
import '../../pages/product_detail_page.dart';

//! Best height & width is equal
class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    this.product,
    this.productId,
    required this.onPressed,
    this.fontSizeName,
    this.fontSizePrice,
    this.height = 200.0,
    this.width = 200.0,
    this.scaleBottom = 1.0,
    this.margin,
    this.padding,
  });

  final ProductEntity? product;
  final int? productId;
  final void Function() onPressed;

  final double? fontSizeName;
  final double? fontSizePrice;

  final double height;
  final double width;
  final double scaleBottom;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isLoading = true;
  late ProductEntity _product;

  void fetchProductById(int id) async {
    final respEither = await sl<ProductRepository>().getProductDetailById(id);
    final product = respEither.fold<ProductEntity?>(
      (error) => null,
      (ok) => ok.data!.product,
    );
    setState(() {
      if (mounted && product != null && _isLoading) {
        _product = product;
        _isLoading = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _product = widget.product!;
      _isLoading = false;
    } else {
      fetchProductById(widget.productId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!_isLoading) {
          widget.onPressed();
        } else {
          context.go(ProductDetailPage.path, extra: _product.productId);
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: widget.padding ?? const EdgeInsets.all(4.0),
        margin: widget.margin,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: !_isLoading
            ? _buildContent()
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //# Image
        Expanded(
          child: ImageCacheable(
            _product.image,
            fit: BoxFit.cover,
          ),
        ),
        //# Name
        Text(
          _product.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSizeName,
          ),
        ),
        //# Price & Rating & Sold
        SizedBox(
          height: widget.height * 0.2,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      ConversionUtils.formatCurrency(_product.cheapestPrice),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSizePrice,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: (widget.width / 4) / widget.scaleBottom),
                    // Rating & Sold
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // rating
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(_product.rating, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        // sold
                        Text('Đã bán ${_product.sold}', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
