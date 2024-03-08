import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/components/custom_buttons.dart';
import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/repository/search_product_repository.dart';
import '../components/product_list_builder.dart';
import '../components/search_bar_component.dart';
import '../components/search_components/bottom_sheet_filter.dart';

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
                    BtnFilterWithBottomSheet(
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

class BtnFilterWithBottomSheet extends StatelessWidget {
  const BtnFilterWithBottomSheet(
    this.context, {
    super.key,
    required this.isFiltering,
    required this.minPrice,
    required this.maxPrice,
    required this.sortType,
    required this.onFilterChanged,
  });

  final BuildContext context;
  final bool isFiltering;
  final int minPrice;
  final int maxPrice;
  final String sortType;

  /// will be null if user cancels the filter by tapping outside the bottom sheet
  final void Function(FilterParams?) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      icon: Icons.filter_alt_outlined,
      text: 'Lọc',
      backgroundColor: isFiltering ? Colors.blue[300] : null,
      onPressed: () async => await handleBottomSheetFilter(),
    );
  }

  Future<void> handleBottomSheetFilter() async {
    //{int min, int max}
    final filterResult = await showModalBottomSheet<FilterParams>(
      context: context,
      builder: (context) => BottomSheetFilter(
        context: context,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortType: sortType,
      ),
    );

    onFilterChanged(filterResult);

    // if (filterResult != null) {
    //   onFilterChanged(filterResult);
    //   setState(() {
    //     isFiltering = true;
    //     minPrice = filterResult.min;
    //     maxPrice = filterResult.max;
    //     currentPage = 1;
    //   });
    // } else {
    //   setState(() {
    //     isFiltering = false;
    //     currentPage = 1;
    //   });
    // }
  }
}

class FilterParams {
  FilterParams({
    required this.isFiltering,
    required this.minPrice,
    required this.maxPrice,
    required this.sortType,
  });

  final bool isFiltering;
  final int minPrice;
  final int maxPrice;
  final String sortType;
}
