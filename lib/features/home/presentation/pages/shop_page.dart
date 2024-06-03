import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/shop.dart';

import '../../../../core/handler/customer_handler.dart';
import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/repository/search_product_repository.dart';
import '../components/search/btn_filter.dart';
import '../components/search/simple_search_bar.dart';
import '../components/shop/category_shop_list.dart';
import '../components/shop/product_shop_list.dart';

//! ShopPage show all products of a shop, customer can:
// - View all products of a shop
// - Search products in a shop (not implemented yet)
// - Chat with shop owner (not implemented yet)
// - Follow/Unfollow a shop
//! because cannot pass scrollController to LazyLoadBuilder, cannot load more page when scroll to the end
//> for the first load all products of a shop >> [_productPerPage] really large //? server limit 200
// const int _productPerPage = 200; >> config in LazyListController

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, required this.shopId});

  static const String routeName = 'shop'; // '/:shopId'
  static const String path = '/home/shop';

  final int shopId;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LazyListController<ProductEntity> _lazyController;
  late FilterParams _filterParams;
  late TextEditingController _searchController;
  String _keywords = '';

  late ShopDetailResp _shopDetail;
  bool _loadingShopDetail = false;

  // control state
  int? _followedShopId;

  FRespData<ProductPageResp> _paginatedData(int page, int size) async {
    if (_filterParams.isFiltering && _keywords.isNotEmpty) {
      if (_filterParams.isFilterWithPriceRange) {
        return sl<SearchProductRepository>().searchProductShopPriceRangeSort(
          page,
          size,
          _keywords,
          _filterParams.sortType,
          _filterParams.minPrice,
          _filterParams.maxPrice,
          _shopDetail.shop.shopId,
        );
      } else {
        return sl<SearchProductRepository>().searchProductShopSort(
          page,
          size,
          _keywords,
          _filterParams.sortType,
          _shopDetail.shop.shopId,
        );
      }
    }
    return sl<ProductRepository>().getProductPageByShop(page, size, widget.shopId);
  }

  void checkFollowedShop(int shopId) async {
    final respEither = await sl<ProductRepository>().followedShopCheckExist(shopId);

    respEither.fold(
      (error) => log('Error: ${error.message}'),
      (ok) {
        if (mounted) {
          setState(() {
            _followedShopId = ok;
          });
        }
      },
    );
  }

  void fetchShopDetailData() async {
    setState(() {
      _loadingShopDetail = true;
    });

    await sl<GuestRepository>().getShopDetailById(widget.shopId).then((respEither) {
      respEither.fold(
        (error) {
          //> if error, the state always is loading
          log('Error: ${error.message}');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(error.message ?? 'Xảy ra lỗi khi lấy thông tin Shop')),
            );
        },
        (ok) {
          if (mounted) {
            setState(() {
              _shopDetail = ok.data!;
              _loadingShopDetail = false;
            });
          }
        },
      );
    });
  }

  final _tabs = <Tab>[
    const Tab(text: 'Sản phẩm'),
    const Tab(text: 'Danh mục'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _filterParams = FilterParams(
      isFiltering: false,
      minPrice: 0,
      maxPrice: 100000000,
      sortType: 'newest',
      isFilterWithPriceRange: false,
    );
    _lazyController = LazyListController<ProductEntity>(
      paginatedData: _paginatedData,
      items: [],
    );
    fetchShopDetailData();
    checkFollowedShop(widget.shopId);
    _searchController = TextEditingController();
    _lazyController.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _lazyController.dispose();
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            if (!_loadingShopDetail) _sliverAppBar(context, innerBoxIsScrolled),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              _loadingShopDetail
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        if (_keywords.isNotEmpty) ...[_actionBar()],
                        Expanded(
                          child: ProductShopList(lazyController: _lazyController),
                        ),
                      ],
                    ),
              ShopCategoryList(shopId: widget.shopId),
            ],
          ),
        ),
      ),
    );
  }

  ShopInfo shopInfo(BuildContext context) {
    return ShopInfo(
      shopId: widget.shopId,
      showChatBtn: true,
      showFollowBtn: true,
      followedShopId: _followedShopId,
      onFollowPressed: (shopId) async => await CustomerHandler.handleFollowShop(shopId),
      onUnFollowPressed: (followedShopId) async => await CustomerHandler.handleUnFollowShop(followedShopId),
      onFollowChanged: (followedShopId) {
        setState(() {
          _followedShopId = followedShopId;
        });
      },
      onChatPressed: () async => await CustomerHandler.navigateToChatPage(context, shopId: widget.shopId),
      showFollowedCount: true,
      padding: const EdgeInsets.only(left: 8, right: 4),
      showShopDetail: true,
      shopDetail: _shopDetail,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ShopDetailPage(shopDetail: _shopDetail);
            },
          ),
        );
      },
    );
  }

  Widget _actionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(style: VTVTheme.hintText12, text: 'Từ khóa tìm kiếm:', children: [
                TextSpan(
                    text: ' $_keywords',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
              ]),
            ),
          ),
          Row(
            children: [
              //# no filter button
              if (_filterParams.isFiltering || _keywords.isNotEmpty)
                IconButton(
                    onPressed: () {
                      setState(() {
                        _filterParams.isFiltering = false;
                        _keywords = '';
                        _searchController.clear();
                        _lazyController.refresh();
                      });
                    },
                    icon: const Icon(Icons.filter_alt_off)),

              //# Filter button
              BtnFilter(
                context,
                isFiltering: _filterParams.isFiltering,
                onFilterChanged: (filterParams) {
                  if (filterParams != null) {
                    setState(() {
                      _filterParams = filterParams;
                      _lazyController.refresh();
                    });
                  }
                },
                minPrice: _filterParams.minPrice,
                maxPrice: _filterParams.maxPrice,
                sortType: _filterParams.sortType,
                filterPriceRange: _filterParams.isFilterWithPriceRange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverAppBar _sliverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      titleSpacing: 0,
      // forceElevated: innerBoxIsScrolled,
      floating: true,
      surfaceTintColor: Colors.transparent,
      title: SimpleSearchBar(
        searchController: _searchController,
        clearOnSubmit: false,
        hintText: 'Tìm sản phẩm trong Shop',
        onSubmitted: (text) {
          setState(() {
            _keywords = text;
            _filterParams.isFiltering = true;
            _lazyController.refresh();
          });
        },
      ),

      // _TODO implement shop cover image --API not ready
      // flexibleSpace: FlexibleSpaceBar(
      //   background: Image.network(
      //     'https://placehold.co/500/png',
      //     fit: BoxFit.cover,
      //   ),
      // ),

      actions: const [
        IconButton(
          onPressed: null,
          icon: Icon(Icons.more_vert),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Column(
          children: [
            Wrapper(
              backgroundColor: Theme.of(context).colorScheme.surface,
              useBoxShadow: false,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: shopInfo(context),
            ),
            TabBar(
              padding: EdgeInsets.zero,
              controller: _tabController,
              tabs: _tabs,
            ),
          ],
        ),
      ),
      // flexibleSpace: FlexibleSpaceBar(
      //   background: SizedBox(
      //     height: 200,
      //     child: Image.network(
      //       'https://placehold.co/500/png',
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
    );
  }
}
