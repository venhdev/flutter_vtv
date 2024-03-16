import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/constants/enum.dart';
import 'package:flutter_vtv/features/home/presentation/components/search_components/btn_filter.dart';

import '../../../../core/presentation/components/app_bar.dart';
import '../../../../service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product_components/best_selling_product_list.dart';
import '../components/product_components/category_list.dart';
import '../components/product_components/lazy_product_list_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  final _productPerPage = 4; // page size

  // filter & sort
  FilterParams currentFilter = FilterParams(
    isFiltering: false,
    filterPriceRange: true,
    minPrice: 0,
    maxPrice: 10000000,
    sortType: 'newest',
  );

  bool isRefreshing = false;
  bool isShowing = true;
  int crossAxisCount = 2;

  Future<void> _refresh() async {
    setState(() {
      isRefreshing = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isRefreshing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: buildAppBar(context, clearOnSubmit: true),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh(); // Remove all widget and re-render due to call API
          context.read<CartBloc>().add(FetchCart());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            controller: scrollController,
            children: [
              // Category
              const CategoryList(),
              // Best selling
              BestSellingProductListBuilder(future: () => sl<ProductRepository>().getProductFilter(1, 10, SortTypes.bestSelling)),
              // Product
              _buildProductActionBar(context),
              isShowing
                  ? LazyProductListBuilder(
                      crossAxisCount: crossAxisCount,
                      scrollController: scrollController,
                      dataCallback: (page) async {
                        if (currentFilter.isFiltering) {
                          if (currentFilter.filterPriceRange) {
                            return sl<ProductRepository>().getProductFilterByPriceRange(
                              page,
                              _productPerPage,
                              currentFilter.minPrice,
                              currentFilter.maxPrice,
                              currentFilter.sortType,
                            );
                          } else {
                            return sl<ProductRepository>().getProductFilter(page, _productPerPage, currentFilter.sortType);
                          }
                        }
                        return sl<ProductRepository>().getSuggestionProductsRandomly(page, _productPerPage);
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildProductActionBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Danh sách sản phẩm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                isShowing = false;
                currentFilter = filterParams;

                // isFiltering = filterParams.isFiltering;
                // minPrice = filterParams.minPrice;
                // maxPrice = filterParams.maxPrice;
                // currentSortType = filterParams.sortType;
                // filterPriceRange = filterParams.filterPriceRange;
              });
            }
            // use [isSortTypeChanged] to completed remove [LazyProductListBuilder]
            // out of the widget tree before re-render
            Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                isShowing = true;
              });
            });
          },
        ),
      ],
    );
  }

  // Widget _buildBestSelling() {
  //   return BestSellingProductList(
  //     future: () => sl<ProductRepository>().getProductFilter(1, 10),
  //   );
  //   // return SizedBox(
  //   //   height: 200,
  //   //   child: FutureBuilder<RespData<ProductDTO>>(
  //   //     future: sl<ProductRepository>().getProductFilter(1, 10),
  //   //     builder: (context, snapshot) {
  //   //       if (snapshot.connectionState != ConnectionState.done) {
  //   //         return const Center(
  //   //           child: CircularProgressIndicator(),
  //   //         );
  //   //       }
  //   //       if (snapshot.hasError) {
  //   //         return Center(
  //   //           child: Text('Error: ${snapshot.error}'),
  //   //         );
  //   //       }
  //   //       return snapshot.data!.fold(
  //   //         (errorResp) => Center(
  //   //           child: Text('Error: $errorResp', style: const TextStyle(color: Colors.red)),
  //   //         ),
  //   //         (dataResp) {
  //   //           return BestSelling(
  //   //             bestSellingProductImages: dataResp.data.products.map((e) => e.image).toList(),
  //   //             bestSellingProductNames: dataResp.data.products.map((e) => e.name).toList(),
  //   //           );
  //   //         },
  //   //       );
  //   //     },
  //   //   ),
  //   // );
  // }
}
