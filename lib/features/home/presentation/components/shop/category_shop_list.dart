import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/shop.dart';

import '../../../../../service_locator.dart';
import '../../pages/product_detail_page.dart';
import '../product/product_item.dart';

class ShopCategoryList extends StatefulWidget {
  const ShopCategoryList({super.key, required this.shopId});

  final int shopId;

  @override
  State<ShopCategoryList> createState() => _ShopCategoryListState();
}

class _ShopCategoryListState extends State<ShopCategoryList> {
  int? categoryShopId;

  @override
  Widget build(BuildContext context) {
    return categoryShopId == null
        ? FutureBuilder(
            future: sl<GuestRepository>().getCategoryShopByShopId(widget.shopId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.fold(
                  (error) => MessageScreen.error(error.message),
                  (ok) {
                    if (ok.data!.isEmpty) return const MessageScreen(message: 'Danh sách trống');
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
                      itemCount: ok.data!.length,
                      itemBuilder: (context, index) => CategoryShopItem(
                        categoryShop: ok.data![index],
                        onItemPressed: (categoryShopId) {
                          setState(() {
                            this.categoryShopId = categoryShopId;
                          });
                        },
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          )
        : FutureBuilder(
            future: sl<GuestRepository>().getCategoryShopByCategoryShopId(categoryShopId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.fold(
                  (error) => MessageScreen.error(error.message),
                  (ok) {
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        title: Text(ok.data!.name),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              categoryShopId = null;
                            });
                          },
                        ),
                      ),
                      body: ok.data!.products!.isNotEmpty
                          ? LazyListBuilder(
                              lazyListController: LazyListController<ProductEntity>.static(items: ok.data!.products!),
                              itemBuilder: (context, index, data) => ProductItem(
                                  product: data,
                                  onPressed: () {
                                    GoRouter.of(context).push(ProductDetailPage.path, extra: data.productId);
                                  }),
                              padding: const EdgeInsets.all(8.0),
                            )
                          : const MessageScreen(message: 'Danh sách trống'),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
  }
}

class CategoryShopItem extends StatelessWidget {
  const CategoryShopItem({
    super.key,
    required this.categoryShop,
    required this.onItemPressed,
  });

  final ShopCategoryEntity categoryShop;
  final ValueChanged<int> onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () => onItemPressed(categoryShop.categoryShopId),
        style: ListTileStyle.list,
        leading: Image.network(categoryShop.image),
        title: Text(categoryShop.name),
        subtitle: Text('${categoryShop.countProduct} sản phẩm'),
      ),
    );
  }
}
