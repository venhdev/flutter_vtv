import 'dart:developer';

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
  List<int?> followedShopIds = [];
  List<FollowedShopEntity>? followedShopList;

  void _loadFollowedShop() async {
    followedShopIds.clear();
    followedShopList = null;
    final resultEither = await sl<ProductRepository>().followedShopList();
    resultEither.fold(
      (error) => [],
      (ok) {
        followedShopList = ok.data!;
        // followedShopIds = ok.data!.map((e) => e.followedShopId).toList(); //> List<int>
        for (var i = 0; i < ok.data!.length; i++) {
          followedShopIds.add(ok.data![i].followedShopId);
        }
      },
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadFollowedShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang theo dõi'),
      ),
      body: followedShopList != null
          ? RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _loadFollowedShop();
                });
              },
              child: ListView.builder(
                itemCount: followedShopList!.length,
                itemBuilder: (context, index) {
                  final shop = followedShopList![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                    child: ShopInfo(
                      shopId: shop.shopId,
                      shopAvatar: shop.avatar ?? 'https://placehold.co/200x200/png',
                      shopName: shop.shopName,
                      showFollowBtn: true,
                      followedShopId: followedShopIds[index],
                      onFollowChanged: (followedShopId) {
                        log('followedShopId: $followedShopId');
                        setState(() {
                          followedShopIds[index] = followedShopId;
                        });
                      },
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () async {
                        await GoRouter.of(context)
                            .push<bool?>('${ShopPage.path}/${shop.shopId}')
                            .then((_) => setState(() {
                                  _loadFollowedShop();
                                }));
                      },
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      // body: FutureBuilder(
      //   future: sl<ProductRepository>().followedShopList(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       final resultEither = snapshot.data!;
      //       return resultEither.fold(
      //           (error) => MessageScreen.error(error.message!),
      //           (ok) => RefreshIndicator(
      //                 onRefresh: () async {
      //                   setState(() {});
      //                 },
      //                 child: ok.data!.isEmpty
      //                     ? const Center(child: Text('Bạn không theo dõi shop nào!'))
      //                     : ListView.builder(
      //                         itemCount: ok.data!.length,
      //                         itemBuilder: (context, index) {
      //                           final shop = ok.data![index];
      //                           return Padding(
      //                             padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
      //                             child: FutureBuilder(
      //                                 future: sl<ProductRepository>().followedShopCheckExist(shop.shopId),
      //                                 builder: (context, snapshot) {
      //                                   if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
      //                                     final rsEither = snapshot.data!;
      //                                     final followedShopId = rsEither.fold(
      //                                       (error) => null,
      //                                       (ok) => ok,
      //                                     );
      //                                     return ShopInfo(
      //                                       shopId: shop.shopId,
      //                                       shopAvatar: shop.avatar ?? 'https://placehold.co/200x200/png',
      //                                       shopName: shop.shopName,
      //                                       showFollowBtn: true,
      //                                       followedShopId: followedShopId,
      //                                       onFollowChanged: (_) {
      //                                         setState(() {});
      //                                       },
      //                                       decoration: BoxDecoration(
      //                                         color: Colors.grey.shade200,
      //                                         borderRadius: BorderRadius.circular(8),
      //                                       ),
      //                                       onPressed: () async {
      //                                         await GoRouter.of(context)
      //                                             .push<bool?>('${ShopPage.path}/${shop.shopId}')
      //                                             .then((_) => setState(() {}));
      //                                       },
      //                                     );
      //                                   }

      //                                   return const Center(
      //                                     child: CircularProgressIndicator(),
      //                                   );
      //                                 }),
      //                           );
      //                         },
      //                       ),
      //               ));
      //     } else if (snapshot.hasError) {
      //       return MessageScreen.error(snapshot.error.toString());
      //     }
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
    );
  }
}
