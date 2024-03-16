import 'package:flutter/material.dart';

import '../../../../../core/constants/typedef.dart';
import '../../../domain/dto/product_dto.dart';
import 'page_number.dart';
import 'product_item.dart';

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

  final Future<RespData<ProductDTO>> future;
  final String? keywords; // for search page
  final int crossAxisCount;

  // for showing page number component at the bottom
  final bool showPageNumber;
  final int? currentPage;
  final void Function(int page)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RespData<ProductDTO>>(
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
              child: Text('[ProductListBuilder] Error: $errorResp', style: const TextStyle(color: Colors.red)), // NOTE: debug
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
