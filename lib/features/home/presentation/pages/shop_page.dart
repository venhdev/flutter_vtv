// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../order/presentation/components/shop_info.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product_components/product_item.dart';
import '../components/search_components/search_bar.dart';
import 'product_detail_page.dart';

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

  late LazyLoadController<ProductEntity> controller;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    controller = LazyLoadController<ProductEntity>(
      scrollController: ScrollController(),
      items: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.reload();
          setState(() {});
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: ShopInfo(
                  shopId: widget.shopId,
                  name: 'Shop Name',
                  avatar: 'https://placehold.co/300/png',
                  showChatBtn: true,
                  showFollowBtn: true,
                  padding: const EdgeInsets.only(left: 8, right: 4),
                ),
              ),
              automaticallyImplyLeading: false,
              //! REVIEW implement shop cover image --no API now
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
                    },
                  ),
                ),
                IconButton(
                  onPressed: null,
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                NestedLazyLoadBuilder(
                  dataCallback: (page) => sl<ProductRepository>().getProductPageByShop(page, 6, widget.shopId),
                  controller: controller,
                  itemBuilder: (context, index, data) => ProductItem(
                    product: data,
                    onPressed: () {
                      GoRouter.of(context).push(ProductDetailPage.path, extra: data.productId);
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
