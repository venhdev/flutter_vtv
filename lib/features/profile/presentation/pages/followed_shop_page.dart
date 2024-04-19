import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../../home/presentation/pages/shop_page.dart';
import '../../../order/presentation/components/shop_info.dart';

class FollowedShopPage extends StatefulWidget {
  const FollowedShopPage({super.key});

  static const String routeName = 'followed';
  static const String path = '/user/followed';

  @override
  State<FollowedShopPage> createState() => _FollowedShopPageState();
}

class _FollowedShopPageState extends State<FollowedShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang theo dõi'),
      ),
      body: FutureBuilder(
        future: sl<ProductRepository>().followedShopList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final resultEither = snapshot.data!;
            return resultEither.fold(
                (error) => MessageScreen.error(error.message!),
                (ok) => RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: ok.data!.isEmpty
                          ? const Center(child: Text('Bạn không theo dõi shop nào!'))
                          : ListView.builder(
                              itemCount: ok.data!.length,
                              itemBuilder: (context, index) {
                                final shop = ok.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                                  child: ShopInfo(
                                    shopId: shop.shopId,
                                    avatar: shop.avatar ?? 'https://placehold.co/200x200/png',
                                    name: shop.shopName,
                                    showFollowBtn: true,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onPressed: () async {
                                      await GoRouter.of(context)
                                          .push<bool?>('${ShopPage.path}/${shop.shopId}')
                                          .then((_) => setState(() {}));
                                    },
                                  ),
                                );
                              },
                            ),
                    ));
          } else if (snapshot.hasError) {
            return MessageScreen.error(snapshot.error.toString());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
