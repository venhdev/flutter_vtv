import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../app_state.dart';
import '../../../../../core/constants/typedef.dart';
import '../../../domain/dto/product_detail_resp.dart';
import '../../../domain/dto/product_page_resp.dart';
import '../../pages/product_detail_page.dart';
import 'best_selling_product_list.dart';
import 'page_number.dart';
import 'product_item.dart';

class ProductDetailListBuilder extends StatelessWidget {
  const ProductDetailListBuilder({
    super.key,
    this.crossAxisCount = 2,
    required this.productDetails,
  }) : assert(crossAxisCount > 0);

  final List<ProductDetailResp> productDetails;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (productDetails.isEmpty) {
          return const SizedBox.shrink();
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GridView.count(
            reverse: true,
            scrollDirection: Axis.horizontal,
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: productDetails
                .map(
                  (p) => BestSellingProductItem(
                    title: p.product.name,
                    image: p.product.image,
                    onTap: () async {
                      // context.go(ProductDetailPage.path, extra: p.product);
                      Provider.of<AppState>(context, listen: false).setBottomNavigationVisibility(false);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductDetailPage(product: p.product);
                          },
                        ),
                      ).then((_) => Provider.of<AppState>(context, listen: false).setBottomNavigationVisibility(true));
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class ProductListBuilder extends StatelessWidget {
  /// A builder that builds a list of products from a future
  ///
  /// When {showPageNumber} is true, it must have {currentPage} and {onPageChanged} as well
  const ProductListBuilder({
    super.key,
    required this.future,
    this.crossAxisCount = 2,
    this.showPageNumber = false,
    this.currentPage,
    this.onPageChanged,
    this.keywords,
  })  : assert(crossAxisCount > 0),
        assert(showPageNumber == false || (currentPage != null && onPageChanged != null));

  final Future<RespData<ProductPageResp>> future;
  final String? keywords; // for search page
  final int crossAxisCount;

  // for showing page number component at the bottom
  final bool showPageNumber;
  final int? currentPage;
  final void Function(int page)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RespData<ProductPageResp>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return snapshot.data!.fold(
            (errorResp) => Center(
              child: Text('Error: ${errorResp.message}', style: const TextStyle(color: Colors.red)),
            ),
            (dataResp) => Builder(builder: (context) {
              if (dataResp.data.products.isEmpty) {
                return const Center(
                  child: Text(
                    'Không tìm thấy sản phẩm phù hợp',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              return Column(
                children: [
                  GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: dataResp.data.products
                        .map(
                          (product) => ProductItem(product: product),
                        )
                        .toList(),
                  ),

                  // Show page number component at the bottom
                  if (showPageNumber) ...[
                    PageNumber(
                      currentPage: currentPage ?? 1,
                      totalPages: dataResp.data.totalPage,
                      onPageChanged: (page) {
                        onPageChanged?.call(page);
                      },
                    ),
                  ],
                ],
              );
            }),
          );
        }

        return Center(
          child: Text('Error: ${snapshot.error.toString()}'),
        );
      },
    );
  }
}
