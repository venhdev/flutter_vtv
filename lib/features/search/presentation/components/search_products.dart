import 'package:flutter/material.dart';
import 'package:flutter_vtv/features/search/domain/repository/search_product_repository.dart';
import 'package:flutter_vtv/features/search/presentation/components/page_number_component.dart';

import '../../../../service_locator.dart';
import '../../../home/presentation/components/product_item.dart';
import '../components/sort_component.dart';

class SearchProducts extends StatefulWidget {
  final String? keywords;

  const SearchProducts({super.key, required this.keywords});

  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  String selectedSortType = 'newest'; // Default sort type
  late int currentPage = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    currentPage = 1; // Initialize current page
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),

        const Text(
          'Danh sách sản phẩm tìm kiếm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SortComponent(
                onSortChanged: (sortType) {
                  setState(() {
                    selectedSortType = sortType;
                    currentPage = 1; // Reset to the first page when sorting changes
                  });
                  _searchProducts(1);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (widget.keywords != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Từ khóa tìm kiếm: ${widget.keywords}'),
          ),
        FutureBuilder(
          future: sl<SearchProductRepository>().searchPageProductBySort(
            currentPage,
            4,
            widget.keywords ?? '',
            selectedSortType,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              return snapshot.data!.fold(
                    (errorResp) => Center(
                  child: Text(
                    'Error: $errorResp',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                    (productDTOResp) => Column(
                  children: [
                    if (productDTOResp.data.products.isEmpty)
                    // Show message if no products found
                      Center(
                        child: Text(
                          'Không tìm thấy sản phẩm nào cho từ khóa:  "${widget.keywords}"',
                        ),
                      ),
                    if (productDTOResp.data.products.isNotEmpty)
                    // Show grid view with products
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: productDTOResp.data.products
                            .map((product) => ProductItem(product: product))
                            .toList(),
                      ),
                    const SizedBox(height: 16),
                    PageNumberComponent(
                      currentPage: currentPage,
                      totalPages: productDTOResp.data.totalPage,
                      onPageChanged: (page) {
                        // Handle page change, fetch data for the new page
                        _searchProducts(page);
                      },
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          },
        ),
      ],
    );
  }

  void _searchProducts(int page) {
    sl<SearchProductRepository>().searchPageProductBySort(
      page,
      4,
      widget.keywords ?? '',
      selectedSortType,
    ).then((result) {
      // Handle the result if needed
      setState(() {
        currentPage = page; // Update the current page after fetching data
      });
    });
  }
}