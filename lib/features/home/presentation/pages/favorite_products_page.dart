import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product/product_card_item.dart';
import 'product_detail_page.dart';

//! Show all customer's favorite products
class FavoriteProductsPage extends StatelessWidget {
  const FavoriteProductsPage({super.key});

  static const String routeName = 'favorite-product';
  static const String path = '/user/favorite-product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sản phẩm yêu thích')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: sl<ProductRepository>().favoriteProductList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final resultEither = snapshot.data!;
              return resultEither.fold(
                (error) => MessageScreen.error(error.message),
                (ok) => ok.data!.isNotEmpty
                    ? GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: ok.data!.map((f) {
                          return ProductCardItem(
                            productId: f.productId,
                            onPressed: () async {
                              final productResp = await sl<GuestRepository>().getProductDetailById(f.productId);
                              productResp.fold(
                                (error) => MessageScreen.error(error.message),
                                (ok) {
                                  final productDetail = ok.data;
                                  context.push(ProductDetailPage.path, extra: productDetail);
                                },
                              );
                            },
                          );
                        }).toList(),
                      )
                    : const MessageScreen(message: 'Không có sản phẩm yêu thích nào'),
              );
            } else if (snapshot.hasError) {
              return MessageScreen.error(snapshot.error.toString());
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
