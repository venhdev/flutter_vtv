import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/repository/search_product_repository.dart';
import '../components/product_components/product_list_builder.dart';
import '../components/search_components/btn_filter.dart';
import '../components/search_components/search_bar.dart';

class SearchProductsPage extends StatefulWidget {
  static const String routeName = 'search';
  static const String route = '/home/$routeName';

  final String keywords;

  const SearchProductsPage({super.key, required this.keywords});

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  final TextEditingController searchController = TextEditingController();

  // search & filter & sort
  late String currentSearchText;
  String currentSortType = 'newest'; // Default sort type
  int currentPage = 1; // Track the current page
  // filter
  bool isFiltering = false;
  int minPrice = 0;
  int maxPrice = 10000000; // 10tr

  @override
  void initState() {
    super.initState();
    currentSearchText = widget.keywords;
    searchController.text = widget.keywords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VTV",
          style: GoogleFonts.ribeye(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SearchBarComponent(
              controller: searchController,
              onSubmitted: (text) => {
                // context.go(SearchProductsPage.route, extra: text),
                setState(() {
                  currentSearchText = text;
                  currentPage = 1; // Reset to the first page when search text changes
                }),
              },
            ),
          ),
        ],
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
                      isFiltering: isFiltering,
                      minPrice: minPrice,
                      maxPrice: maxPrice,
                      sortType: currentSortType,
                      onFilterChanged: (filterParams) {
                        if (filterParams != null) {
                          setState(() {
                            isFiltering = filterParams.isFiltering;
                            minPrice = filterParams.minPrice;
                            maxPrice = filterParams.maxPrice;
                            currentSortType = filterParams.sortType;
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
            future: isFiltering
                ? sl<ProductRepository>().getProductFilterByPriceRange(
                    currentPage,
                    4,
                    minPrice,
                    maxPrice,
                    currentSortType,
                  )
                : sl<SearchProductRepository>().searchPageProductBySort(
                    currentPage,
                    4,
                    currentSearchText,
                    currentSortType,
                  ),
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
}
