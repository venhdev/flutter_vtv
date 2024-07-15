import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../pages/product_detail_page.dart';
import 'page_number.dart';
import 'product_item.dart';

class ProductDetailListBuilder extends StatelessWidget {
  const ProductDetailListBuilder({
    super.key,
    required this.productDetails,
    this.crossAxisCount = 2,
    this.itemHeight = 150,
    this.emptyMessage,
    this.scrollDirection = Axis.vertical,
    this.onTap,
  }) : assert(crossAxisCount > 0);

  final List<ProductDetailResp> productDetails;
  final int crossAxisCount;
  final String? emptyMessage;
  final double itemHeight;
  final Axis scrollDirection;

  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (productDetails.isEmpty) {
          // return const SizedBox();
          return Center(
            child: Text(
              emptyMessage ?? 'Không tìm thấy sản phẩm phù hợp',
              style: const TextStyle(fontSize: 12),
            ),
          );
        }
        return SizedBox(
          height: scrollDirection == Axis.vertical ? null : (itemHeight * crossAxisCount),
          child: GridView.count(
              //? the parent use column & SingleChildScrollView >> shrinkwrap = true
              scrollDirection: scrollDirection,
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: scrollDirection == Axis.vertical ? const NeverScrollableScrollPhysics() : null,
              children: [
                for (var i = 0; i < productDetails.length; i++)
                  ProductItem(
                    product: productDetails[i].product,
                    margin: const EdgeInsets.all(2.0),
                    scaleBottom: 1.5,
                    onPressed: () {
                      onTap?.call(i);
                      // context.go(ProductDetailPage.path, extra: productDetails[i].product);
                    },
                  ),
              ]

              // children: productDetails
              // .map(
              //   (p) => ProductItem(
              //     onPressed: () async {
              //       // Provider.of<AppState>(context, listen: false).setBottomNavigationVisibility(false);

              //       onTap?.call(index);

              //       // Navigator.of(context).push(
              //       //   MaterialPageRoute(
              //       //     builder: (context) {
              //       //       return ProductDetailPage(productDetail: p);
              //       //     },
              //       //   ),
              //       // );
              //       // .then((_) => Provider.of<AppState>(context, listen: false).setBottomNavigationVisibility(true));
              //     },
              //     product: p.product,
              //     margin: const EdgeInsets.only(right: 6.0),
              //   ),
              //   // (p) => BestSellingProductItem(
              //   //   title: p.product.name,
              //   //   image: p.product.image,
              //   //   onTap: () async {
              //   //     // context.go(ProductDetailPage.path, extra: p.product);
              //   //     Provider.of<AppState>(context, listen: false).setBottomNavigationVisibility(false);

              //   //     Navigator.of(context).push(
              //   //       MaterialPageRoute(
              //   //         builder: (context) {
              //   //           return ProductDetailPage(product: p.product);
              //   //         },
              //   //       ),
              //   //     ).then((_) => Provider.of<AppState>(context, listen: false).setBottomNavigationVisibility(true));
              //   //   },
              //   // ),
              // )
              // .toList(),
              ),
        );
      },
    );
  }
}

class ProductPageBuilder extends StatelessWidget {
  /// A builder that builds a list of products from a future
  ///
  /// When {showPageNumber} is true, it must have {currentPage} and {onPageChanged} as well
  const ProductPageBuilder({
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
            (dataResp) {
              final filteredProducts = dataResp.data!.items.where((p) => p.status == Status.ACTIVE.name).toList();

              return Builder(builder: (context) {
                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không tìm thấy sản phẩm phù hợp',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.count(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: filteredProducts
                            .map(
                              (product) => ProductItem(
                                product: product,
                                onPressed: () {
                                  context.push(
                                    ProductDetailPage.path,
                                    extra: product.productId,
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    // Show page number component at the bottom
                    if (showPageNumber) ...[
                      PageNumber(
                        currentPage: currentPage ?? 1,
                        totalPages: dataResp.data!.totalPage!,
                        onPageChanged: (page) {
                          onPageChanged?.call(page);
                        },
                      ),
                    ],
                  ],
                );
              });
            },
          );
        }

        return Center(
          child: Text('Error: ${snapshot.error.toString()}'),
        );
      },
    );
  }
}
