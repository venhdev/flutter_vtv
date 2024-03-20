import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/constants/enum.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/features/home/domain/dto/product_resp.dart';

import '../../../../core/presentation/components/app_bar.dart';
import '../../../../service_locator.dart';
import '../../domain/repository/search_product_repository.dart';
import '../components/product_components/product_list_builder.dart';
import '../components/search_components/btn_filter.dart';

class SearchPage extends StatefulWidget {
  static const String pathName = 'search';
  static const String routeName = 'search';
  static const String path = '/home/search';

  final String keywords;

  const SearchPage({super.key, required this.keywords});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final pageSize = 6;

  // search & filter & sort
  late String currentSearchText;
  FilterParams currentFilter = FilterParams(
    isFiltering: false,
    minPrice: 0,
    maxPrice: 10000000,
    sortType: 'newest',
    filterPriceRange: true,
  );

  int currentPage = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    currentSearchText = widget.keywords;
    searchController.text = widget.keywords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "VTV",
      //     style: GoogleFonts.ribeye(
      //       fontSize: 36,
      //       fontWeight: FontWeight.w400,
      //       color: Colors.black87,
      //     ),
      //   ),
      //   actions: [
      //     SizedBox(
      //       width: MediaQuery.of(context).size.width * 0.7,
      //       child: SearchBarComponent(
      //         controller: searchController,
      //         onSubmitted: (text) => {
      //           // context.go(SearchProductsPage.route, extra: text),
      //           setState(() {
      //             currentSearchText = text;
      //             currentPage = 1; // Reset to the first page when search text changes
      //           }),
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      appBar: buildAppBar(
        context,
        searchController: searchController,
        onSubmittedCallback: (text) {
          setState(() {
            currentSearchText = text;
            currentPage = 1; // Reset to the first page when search text changes
          });
        },
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            // filter & sort
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BtnFilter(
                      context,
                      isFiltering: currentFilter.isFiltering,
                      minPrice: currentFilter.minPrice,
                      maxPrice: currentFilter.maxPrice,
                      sortType: currentFilter.sortType,
                      filterPriceRange: currentFilter.filterPriceRange,
                      onFilterChanged: (filterParams) {
                        if (filterParams != null) {
                          setState(() {
                            currentFilter = filterParams;
                            currentPage = 1;
                          });
                        }
                        // do nothing if filterResult is null (user cancels the filter by tapping outside the bottom sheet)
                      },
                    ),
                    // show search text
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Từ khóa tìm kiếm: $currentSearchText',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ProductListBuilder(
            future: searchMethod(),
            keywords: currentSearchText,
            crossAxisCount: 2,
            showPageNumber: true,
            currentPage: currentPage,
            onPageChanged: (page) {
              setState(() {
                currentPage = page;
              });
            },
          ),
        ],
      ),
    );
  }

  FRespData<ProductResp> searchMethod() {
    return currentFilter.isFiltering
        ? currentFilter.filterPriceRange
            ? sl<SearchProductRepository>().getSearchProductPriceRangeSort(
                currentPage,
                pageSize,
                currentSearchText,
                currentFilter.sortType,
                currentFilter.minPrice,
                currentFilter.maxPrice,
              )
            : sl<SearchProductRepository>().searchProductSort(
                currentPage,
                pageSize,
                currentSearchText,
                currentFilter.sortType,
              )
        : sl<SearchProductRepository>().searchProductSort(
            currentPage,
            pageSize,
            currentSearchText,
            SortTypes.random,
          );
  }
}
