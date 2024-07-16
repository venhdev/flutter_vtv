import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../../core/presentation/components/app_bar.dart';
import '../../../../service_locator.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/repository/product_repository.dart';
import '../components/category/category_list.dart';
import '../components/product/best_selling_product_list.dart';
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
  late LazyListController<ProductEntity> lazyProductListController;
  late LazyListController<ProductEntity> lazyBestSellingListController;

  // filter & sort
  FilterParams currentFilter = FilterParams(
    isFiltering: false,
    isFilterWithPriceRange: true,
    minPrice: 0,
    maxPrice: 10000000,
    sortType: 'newest',
  );

  bool isRefreshing = false;
  int crossAxisCount = 2;

  @override
  void initState() {
    super.initState();
    //# App is opened by terminated state via notification
    CustomerHandler.openMessageOnTerminatedApp();

    lazyProductListController = LazyListController(
        items: [],
        scrollController: ScrollController(),
        lastPageMessage: 'Đã hiển thị tất cả sản phẩm',
        paginatedData: (page, size) async {
          if (currentFilter.isFiltering) {
            if (currentFilter.isFilterWithPriceRange) {
              return sl<ProductRepository>().getProductFilterByPriceRange(
                page,
                size,
                currentFilter.minPrice,
                currentFilter.maxPrice,
                currentFilter.sortType,
              );
            } else {
              return sl<ProductRepository>().getProductFilter(
                page,
                size,
                currentFilter.sortType,
              );
            }
          }
          return sl<ProductRepository>().getSuggestionProductsRandomly(page, size);
        },
        itemBuilder: (context, index, data) {
          return ProductItem(
            product: data,
            onPressed: () {
              context.push(ProductDetailPage.path, extra: data.productId);
            },
          );
        })
      ..init()
      ..scrollController!.addListener(() {
        if (lazyProductListController.scrollController!.position.pixels ==
            lazyProductListController.scrollController!.position.maxScrollExtent) {
          lazyProductListController.loadNextPage();
        }
      });

    lazyBestSellingListController = LazyListController(
        items: [],
        scrollDirection: Axis.horizontal,
        useGrid: false,
        paginatedData: (_, __) => sl<ProductRepository>().getProductFilter(1, 10, SortType.bestSelling),
        itemBuilder: (context, index, product) => ProductItem(
              onPressed: () => context.go(ProductDetailPage.path, extra: product.productId),
              product: product,
              height: 140,
              width: 140,
            ),
        showLoadingIndicator: true)
      ..init()
      ..setDebugLabel('BestSellingList');
  }

  @override
  void dispose() {
    lazyProductListController.dispose();
    lazyBestSellingListController.dispose();
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
      appBar: appBarBuilder(context, clearOnSubmit: true),
      body: RefreshIndicator(
        onRefresh: () async {
          // _refresh(); // Remove all widget and re-render due to call API
          lazyProductListController.refresh();
          lazyBestSellingListController.refresh();
          if (context.read<AuthCubit>().state.status == AuthStatus.authenticated) {
            context.read<CartBloc>().add(InitialCart());
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            controller: lazyProductListController.scrollController,
            children: [
              //# Category
              // ignore: prefer_const_constructors
              CategoryList(),
              //# Best selling
              BestSellingProductListBuilder(lazyListController: lazyBestSellingListController),
              // const GlobalSystemVoucherPageView(),
              //# Product list with filter
              _buildProductListActionBar(context), // BUG turn off filter by price --> ERROR
              _buildLazyProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLazyProducts() {
    return LazyListBuilder(
      lazyListController: lazyProductListController,
      itemBuilder: (BuildContext context, int index, _) => lazyProductListController.build(context, index),
    );
  }

  Widget _buildProductListActionBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Danh sách sản phẩm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                currentFilter = filterParams;
                lazyProductListController.refresh();
              });
            }
          },
        ),
      ],
    );
  }
}
