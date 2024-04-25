import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../core/presentation/components/app_bar.dart';
import '../../../../service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product/best_selling_product_list.dart';
import '../components/category/category_list.dart';
import '../components/product/product_item.dart';
import '../components/search/btn_filter.dart';
import 'product_detail_page.dart';

//! HomePage is the main page of the app, showing all products, categories, and best-selling products...
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeRoot = '/home';
  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _productPerPage = 6; //! page size
  final lazyController = LazyLoadController<ProductEntity>(
    scrollController: ScrollController(),
    items: [],
    useGrid: true,
    // showIndicator: true,
  );

  // filter & sort
  FilterParams currentFilter = FilterParams(
    isFiltering: false,
    isFilterWithPriceRange: true,
    minPrice: 0,
    maxPrice: 10000000,
    sortType: 'newest',
  );

  bool isRefreshing = false;
  bool isShowing = true;
  int crossAxisCount = 2;

  Future<void> _refresh() async {
    // setState(() {
    //   isRefreshing = true;
    //   lazyController.reload();
    //   if (context.read<AuthCubit>().state.status == AuthStatus.authenticated) {
    //     context.read<CartBloc>().add(InitialCart());
    //   }
    // });
    // await Future.delayed(const Duration(milliseconds: 300));
    // setState(() {
    //   isRefreshing = false;
    // });

    setState(() {
      lazyController.reload();
      if (context.read<AuthCubit>().state.status == AuthStatus.authenticated) {
        context.read<CartBloc>().add(InitialCart());
      }
    });
  }

  @override
  void dispose() {
    lazyController.scrollController.dispose();
    super.dispose();
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
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            controller: lazyController.scrollController,
            children: [
              //# Category
              const CategoryList(),
              //# Best selling
              BestSellingProductListBuilder(
                future: () => sl<ProductRepository>().getProductFilter(1, 10, SortTypes.bestSelling),
              ),
              //# Product list with filter
              // BUG turn off filter by price --> ERROR
              _buildProductActionBar(context),
              _buildLazyProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLazyProducts() {
    if (isShowing) {
      return NestedLazyLoadBuilder<ProductEntity>(
        controller: lazyController,
        crossAxisCount: 2,
        dataCallback: (page) async {
          if (currentFilter.isFiltering) {
            if (currentFilter.isFilterWithPriceRange) {
              return sl<ProductRepository>().getProductFilterByPriceRange(
                page,
                _productPerPage,
                currentFilter.minPrice,
                currentFilter.maxPrice,
                currentFilter.sortType,
              );
            } else {
              return sl<ProductRepository>().getProductFilter(
                page,
                _productPerPage,
                currentFilter.sortType,
              );
            }
          }
          return sl<ProductRepository>().getSuggestionProductsRandomly(page, _productPerPage);
        },
        itemBuilder: (context, index, data) {
          return ProductItem(
            product: lazyController.items[index],
            onPressed: () {
              // context.go(ProductDetailPage.path, extra: _products[index].productId);
              // context.read<AppState>().hideBottomNav();
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return ProductDetailPage(productId: lazyController.items[index].productId);
              //     },
              //   ),
              // ).then(
              //   (_) {
              //     context.read<AppState>().showBottomNav();
              //   },
              // );

              context.push(
                ProductDetailPage.path,
                extra: lazyController.items[index].productId,
              );
            },
          );
        },
      );
      // return LazyProductListBuilder(
      //   crossAxisCount: crossAxisCount,
      //   // scrollController: (execute) {
      //   //   _scrollController.addListener(() {
      //   //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      //   //       execute();
      //   //     }
      //   //   });
      //   //   return _scrollController;
      //   // },
      //   scrollController: _scrollController,
      //   dataCallback: (page) async {
      //     if (currentFilter.isFiltering) {
      //       if (currentFilter.filterPriceRange) {
      //         return sl<ProductRepository>().getProductFilterByPriceRange(
      //           page,
      //           _productPerPage,
      //           currentFilter.minPrice,
      //           currentFilter.maxPrice,
      //           currentFilter.sortType,
      //         );
      //       } else {
      //         return sl<ProductRepository>().getProductFilter(
      //           page,
      //           _productPerPage,
      //           currentFilter.sortType,
      //         );
      //       }
      //     }
      //     return sl<ProductRepository>().getSuggestionProductsRandomly(page, _productPerPage);
      //   },
      // );
    } else {
      return const SizedBox();
    }
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
          filterPriceRange: currentFilter.isFilterWithPriceRange,
          onFilterChanged: (filterParams) {
            if (filterParams != null) {
              setState(() {
                // isShowing = false; //> no longer need this >> controlled by [LazyProductListBuilder]
                currentFilter = filterParams;
                lazyController.reload();

                // isFiltering = filterParams.isFiltering;
                // minPrice = filterParams.minPrice;
                // maxPrice = filterParams.maxPrice;
                // currentSortType = filterParams.sortType;
                // filterPriceRange = filterParams.filterPriceRange;
              });
            }
            //> no longer need this >> controlled by [LazyProductListBuilder]
            // use [isSortTypeChanged] to completed remove [LazyProductListBuilder]
            // out of the widget tree before re-render
            // Future.delayed(const Duration(milliseconds: 300), () {
            //   setState(() {
            //     isShowing = true;
            //   });
            // });
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
