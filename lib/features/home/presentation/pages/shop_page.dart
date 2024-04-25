import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../order/presentation/components/shop_info.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/repository/search_product_repository.dart';
import '../components/product/product_item.dart';
import '../components/search/btn_filter.dart';
import '../components/search/search_bar.dart';
import 'product_detail_page.dart';

//! ShopPage show all products of a shop, customer can:
// - View all products of a shop
// - Search products in a shop (not implemented yet)
// - Chat with shop owner (not implemented yet)
// - Follow/Unfollow a shop

const int _productPerPage = 10;

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, required this.shopId});

  static const String routeName = 'shop'; // '/:shopId'
  static const String path = '/home/shop';

  final int shopId;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late TextEditingController searchController;
  late LazyLoadController<ProductEntity> lazyController;
  late FilterParams _filterParams;
  String keywords = '';

  late ShopDetailResp _shopDetail;
  bool _loadingShopDetail = false;
  String errMsg = '';

  // control state
  int? _followedShopId;

  void checkFollowedShop(int shopId) async {
    final respEither = await sl<ProductRepository>().followedShopCheckExist(shopId);

    log('respEither checkFollowedShop: $respEither');
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

    await sl<ProductRepository>().getShopDetailById(widget.shopId).then((respEither) {
      respEither.fold(
        (error) {
          errMsg = error.message ?? 'Lỗi khi lấy thông tin shop';
        },
        (ok) {
          if (mounted) {
            setState(() {
              _loadingShopDetail = false;
              errMsg = '';
              _shopDetail = ok.data!;
            });
          }
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchShopDetailData();
    checkFollowedShop(widget.shopId);
    _filterParams = FilterParams(
      isFiltering: false,
      minPrice: 0,
      maxPrice: 10000000,
      sortType: 'newest',
      isFilterWithPriceRange: true,
    );
    searchController = TextEditingController();
    lazyController = LazyLoadController<ProductEntity>(
      scrollController: ScrollController(),
      items: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    log('[ShopPage] rebuild');
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          lazyController.reload();
          setState(() {});
        },
        child: CustomScrollView(
          controller: lazyController.scrollController,
          slivers: [
            if (!_loadingShopDetail) _buildAppBar(),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  SliverList _buildBody() {
    return SliverList(
      delegate: SliverChildListDelegate([
        if (!_loadingShopDetail)
          ShopInfo(
            decoration: BoxDecoration(color: Theme.of(context).appBarTheme.backgroundColor),
            shopId: widget.shopId,
            showChatBtn: true,
            showFollowBtn: true,
            followedShopId: _followedShopId,
            onFollowChanged: (followedShopId) {
              setState(() {
                _followedShopId = followedShopId;
              });
            },
            showFollowedCount: true,
            padding: const EdgeInsets.only(left: 8, right: 4),
            showShopDetail: true,
            shopDetail: _shopDetail,
          ),
        if (keywords.isNotEmpty) _actionBar(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: NestedLazyLoadBuilder(
            // dataCallback: (page) => sl<ProductRepository>().getProductPageByShop(page, _productPerPage, widget.shopId),
            dataCallback: _data,
            controller: lazyController,
            itemBuilder: (context, index, data) => ProductItem(
              product: data,
              onPressed: () {
                GoRouter.of(context).push(ProductDetailPage.path, extra: data.productId);
              },
            ),
          ),
        ),
      ]),
    );
  }

  Padding _actionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Từ khóa tìm kiếm: $keywords'),
          Row(
            children: [
              // no filter button
              if (_filterParams.isFiltering || keywords.isNotEmpty)
                IconButton(
                    onPressed: () {
                      setState(() {
                        _filterParams.isFiltering = false;
                        keywords = '';
                        searchController.clear();
                        lazyController.reload();
                      });
                    },
                    icon: const Icon(Icons.filter_alt_off)),

              // Filter button
              BtnFilter(
                context,
                isFiltering: _filterParams.isFiltering,
                onFilterChanged: (filterParams) {
                  if (filterParams != null) {
                    setState(() {
                      _filterParams = filterParams;
                      lazyController.reload();
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

  FRespData<ProductPageResp> _data(int page) async {
    if (_filterParams.isFiltering && keywords.isNotEmpty) {
      if (_filterParams.isFilterWithPriceRange) {
        return sl<SearchProductRepository>().searchProductShopPriceRangeSort(
          page,
          _productPerPage,
          keywords,
          _filterParams.sortType,
          _filterParams.minPrice,
          _filterParams.maxPrice,
          widget.shopId,
        );
      } else {
        return sl<SearchProductRepository>().searchProductShopSort(
          page,
          _productPerPage,
          keywords,
          _filterParams.sortType,
          widget.shopId,
        );
      }
    }
    return sl<ProductRepository>().getProductPageByShop(page, _productPerPage, widget.shopId);
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,

      // TODO implement shop cover image --API not ready
      // flexibleSpace: FlexibleSpaceBar(
      //   background: Image.network(
      //     'https://placehold.co/500/png',
      //     fit: BoxFit.cover,
      //   ),
      // ),

      actions: [
        SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            )),
        Expanded(
          child: SearchBarComponent(
            controller: searchController,
            clearOnSubmit: false,
            hintText: 'Tìm kiếm sản phẩm trong shop',
            onSubmitted: (text) {
              log('Search: $text');
              setState(() {
                keywords = text;
                _filterParams.isFiltering = true;
                lazyController.reload();
              });
            },
          ),
        ),
        const IconButton(
          onPressed: null,
          icon: Icon(Icons.more_vert),
        ),
      ],
    );
  }
}

class SlowBuildWidget extends StatefulWidget {
  const SlowBuildWidget({super.key});

  @override
  State<SlowBuildWidget> createState() => _SlowBuildWidgetState();
}

class _SlowBuildWidgetState extends State<SlowBuildWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
        const Duration(seconds: 2),
        () => 'Data Loaded',
      ),
      builder: (context, snapshot) {
        log('snapshot $snapshot');
        if (snapshot.hasData) {
          return SizedBox(
            height: 50,
            width: 100,
            child: Text(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          return MessageScreen.error(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
