
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../pages/product_detail_page.dart';
import '../product/product_item.dart';

class ProductShopList extends StatefulWidget {
  const ProductShopList({
    super.key,
    required this.lazyController,
  });

  final LazyController<ProductEntity> lazyController;

  @override
  State<ProductShopList> createState() => _ProductShopListState();
}

class _ProductShopListState extends State<ProductShopList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LazyLoadBuilder<ProductEntity>(
            lazyController: widget.lazyController,
            itemBuilder: (context, index, data) => ProductItem(
              product: data,
              onPressed: () {
                GoRouter.of(context).push(ProductDetailPage.path, extra: data.productId);
              },
            ),
          ),
        ),
      ],
    );
  }
}
