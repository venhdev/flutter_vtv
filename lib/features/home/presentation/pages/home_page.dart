import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../components/best_selling_product_list.dart';
import '../components/category_list.dart';
import '../components/product_components/lazy_product_list_builder.dart';
import '../components/search_components/search_bar.dart';
import 'search_products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHomePageAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          controller: scrollController,
          children: [
            // Category
            const Category(),
            // Best selling
            _buildBestSelling(),
            // Product
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách sản phẩm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: null,
                    child: Text('Xem thêm'),
                  ),
                ],
              ),
            ),
            // Product list
            LazyProductListBuilder(
              scrollController: scrollController,
              execute: (page) => sl<ProductRepository>().getSuggestionProductsRandomly(page, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestSelling() {
    return BestSellingProductList(
      future: () => sl<ProductRepository>().getProductFilter(1, 10),
    );
    // return SizedBox(
    //   height: 200,
    //   child: FutureBuilder<RespData<ProductDTO>>(
    //     future: sl<ProductRepository>().getProductFilter(1, 10),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState != ConnectionState.done) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       if (snapshot.hasError) {
    //         return Center(
    //           child: Text('Error: ${snapshot.error}'),
    //         );
    //       }
    //       return snapshot.data!.fold(
    //         (errorResp) => Center(
    //           child: Text('Error: $errorResp', style: const TextStyle(color: Colors.red)),
    //         ),
    //         (dataResp) {
    //           return BestSelling(
    //             bestSellingProductImages: dataResp.data.products.map((e) => e.image).toList(),
    //             bestSellingProductNames: dataResp.data.products.map((e) => e.name).toList(),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
  }

  AppBar _buildHomePageAppBar(BuildContext context) {
    return AppBar(
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
            clearOnSubmit: true,
            onSubmitted: (text) => context.go(SearchProductsPage.route, extra: text),
          ),
        ),
      ],
    );
  }
}
