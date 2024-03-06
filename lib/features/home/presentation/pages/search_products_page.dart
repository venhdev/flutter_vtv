import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../service_locator.dart';
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

  // data send to server
  String selectedSortType = 'newest'; // Default sort type
  int currentPage = 1; // Track the current page
  late String currentSearchText;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Từ khóa tìm kiếm: $currentSearchText',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SortTypesComponent(
                  onSortChanged: (sortType) {
                    setState(() {
                      selectedSortType = sortType;
                      currentPage = 1; // Reset to the first page when sorting changes
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // _buildSearchProducts(),
          ProductListBuilder(
            future: sl<SearchProductRepository>().searchPageProductBySort(
              currentPage,
              6,
              currentSearchText,
              selectedSortType,
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
