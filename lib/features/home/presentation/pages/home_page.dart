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
  int crossAxisCount = 2;

  Future<void> _refresh() async {
    setState(() {
      lazyController.reload();
      if (context.read<AuthCubit>().state.status == AuthStatus.authenticated) {
        context.read<CartBloc>().add(InitialCart());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<FirebaseCloudMessagingManager>().runWhenContainInitialMessage(
        (remoteMessage) {
          CustomerHandler.navigateToOrderDetailPageViaRemoteMessage(remoteMessage);
        },
      );
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
            context.push(
              ProductDetailPage.path,
              extra: lazyController.items[index].productId,
            );
          },
        );
      },
    );
  }

  Widget _buildProductListActionBar(BuildContext context) {
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
                currentFilter = filterParams;
                lazyController.reload();
              });
            }
          },
        ),
      ],
    );
  }
}

// class GlobalSystemVoucherPageView extends StatefulWidget {
//   const GlobalSystemVoucherPageView({super.key});

//   @override
//   State<GlobalSystemVoucherPageView> createState() => _GlobalSystemVoucherPageViewState();
// }

// class _GlobalSystemVoucherPageViewState extends State<GlobalSystemVoucherPageView> {
//   // late PageController _pageViewController;

//   @override
//   void initState() {
//     super.initState();
//     // _pageViewController = PageController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextTheme textTheme = Theme.of(context).textTheme;

//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         if (state.status == AuthStatus.authenticated) {
//           return FutureBuilder(
//             future: sl<VoucherRepository>().listOnSystem(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return snapshot.data!.fold(
//                   (error) => MessageScreen.error(error.message),
//                   (ok) {
//                     if (ok.data!.isEmpty) {
//                       return const SizedBox.shrink();
//                     }
//                     return CarouselSlider.builder(
//                       options: CarouselOptions(height: 150, enableInfiniteScroll: false),
//                       itemCount: ok.data!.length,
//                       itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => VoucherItemV2(
//                         voucher: ok.data![itemIndex],
//                         onPressed: (_) {
//                           context.go(VoucherCollectionPage.path);
//                         },
//                         actionLabel: 'Sử\ndụng',
//                       ),
//                     );
//                   },
//                 );
//               } else if (snapshot.hasError) {
//                 return MessageScreen.error(snapshot.error.toString());
//               }
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             },
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }
// }
