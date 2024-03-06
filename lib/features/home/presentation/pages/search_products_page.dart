import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/helpers/helpers.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/repository/search_product_repository.dart';
import '../components/product_list_builder.dart';
import '../components/search_bar_component.dart';
import '../components/sort_types_component.dart';

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
  int maxPrice = 1000000; // 1tr

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
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Danh sách sản phẩm tìm kiếm',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        // show bottomSheet
                        final result = await showModalBottomSheet<({int min, int max})>(
                          context: context,
                          builder: (context) => FilterModalSheet(
                            context: context,
                            isFiltering: isFiltering,
                            minPrice: minPrice,
                            maxPrice: maxPrice,
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            isFiltering = true;
                            minPrice = result.min;
                            maxPrice = result.max;
                            currentPage = 1; // Reset to the first page when filter changes
                          });
                        } else {
                          setState(() {
                            isFiltering = false;
                            currentPage = 1; // Reset to the first page when filter changes
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isFiltering ? Colors.blue[300] : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.filter_alt_outlined),
                            SizedBox(width: 5),
                            Text(
                              'Lọc',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SortTypesComponent(
                      onSortChanged: (sortType) {
                        setState(() {
                          currentSortType = sortType;
                          currentPage = 1; // Reset to the first page when sorting changes
                        });
                      },
                    ),
                  ],
                ),
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
          ),
          const SizedBox(height: 8),

          // _buildSearchProducts(),
          ProductListBuilder(
            future: isFiltering
                ? sl<ProductRepository>().getProductFilterByPriceRange(
                    currentPage,
                    6,
                    minPrice,
                    maxPrice,
                    currentSortType,
                  )
                : sl<SearchProductRepository>().searchPageProductBySort(
                    currentPage,
                    6,
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

class FilterModalSheet extends StatefulWidget {
  /// default range is 0 - 1tr
  const FilterModalSheet({
    super.key,
    required this.context,
    required this.isFiltering,
    required this.minPrice,
    required this.maxPrice,
    this.minRange = 0,
    this.maxRange = 1000000, // 1tr
    this.divisions = 100,
  });
  final BuildContext context;
  final bool isFiltering;

  final int minPrice;
  final int maxPrice;
  final double minRange;
  final double maxRange;
  final int divisions;

  @override
  State<FilterModalSheet> createState() => _FilterModalSheetState();
}

class _FilterModalSheetState extends State<FilterModalSheet> {
  late RangeValues _currentRangeValues;
  late double minRange;
  late double maxRange;

  @override
  void initState() {
    super.initState();
    if (widget.minPrice < widget.minRange) {
      minRange = widget.minPrice.toDouble();
    } else {
      minRange = widget.minRange;
    }

    if (widget.maxPrice > widget.maxRange) {
      maxRange = widget.maxPrice.toDouble();
    } else {
      maxRange = widget.maxRange;
    }

    _currentRangeValues = RangeValues(
      widget.minPrice.toDouble(),
      widget.maxPrice.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'Lọc theo giá',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Từ: ${formatCurrency(_currentRangeValues.start.round())}'),
              Text('Đến: ${formatCurrency(_currentRangeValues.end.round())}'),
            ],
          ),
          const SizedBox(height: 10),
          RangeSlider(
            values: _currentRangeValues,
            min: minRange,
            max: maxRange,
            divisions: widget.divisions,
            labels: RangeLabels(
              formatCurrency(_currentRangeValues.start.round()),
              formatCurrency(_currentRangeValues.end.round()),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
          const SizedBox(height: 10),
          // apply and cancel button
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: const Center(child: Text('Hủy bỏ')),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // apply filter
                      Navigator.pop(
                        context,
                        (min: _currentRangeValues.start.round(), max: _currentRangeValues.end.round()),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[300],
                      ),
                      child: const Center(child: Text('Áp dụng')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
