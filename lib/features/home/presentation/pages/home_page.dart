import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/typedef.dart';
import '../../../../core/network/base_response.dart';
import '../../../../service_locator.dart';
import '../../domain/dto/product_dto.dart';
import '../components/best_selling_view.dart';
import '../components/search_bar_component.dart';
import '../../domain/repository/product_repository.dart';
import '../components/category_list.dart';
import '../components/product_list_builder.dart';
import 'search_products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = 1;
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
              clearOnSubmit: true,
              onSubmitted: (text) => context.go(SearchProductsPage.route, extra: text),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: FutureBuilder<RespData<ProductDTO>>(
              future: sl<ProductRepository>().getProductFilter(1, 10),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return snapshot.data!.fold(
                  (errorResp) => Center(
                    child: Text('Error: $errorResp', style: const TextStyle(color: Colors.red)),
                  ),
                  (dataResp) {
                    return BestSellingScreen(
                      bestSellingProducts: dataResp.data.products.map((e) => e.image).toList(),
                    );
                  },
                );
              },
            ),
          ),
          // Category
          const Category(),
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
          ProductListBuilder(
            future: sl<ProductRepository>().getSuggestionProductsRandomly(currentPage, 10),
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
