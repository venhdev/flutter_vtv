import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../service_locator.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../../home/presentation/pages/shop_page.dart';

class ShopInfo extends StatefulWidget {
  const ShopInfo({
    super.key,
    this.padding,
    this.onPressed,
    required this.shopId,
    this.showFollowBtn = false,
    this.showChatBtn = false,
    this.showViewShopBtn = false,
    required this.avatar,
    required this.name,
    this.trailing,
  });

  final int shopId;
  final bool showFollowBtn;
  final bool showChatBtn;
  final bool showViewShopBtn;

  //data to render
  final String name;
  final String avatar;
  final Widget? trailing;

  final EdgeInsetsGeometry? padding;

  final void Function()? onPressed; //GoRouter.of(context).push('${ShopPage.path}/${shop.shopId}');

  @override
  State<ShopInfo> createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: widget.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // shop avatar, name, followed
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.avatar),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // shop name
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // shop followed
                      FutureBuilder(
                          future: sl<ProductRepository>().countShopFollowed(widget.shopId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!.fold(
                                (error) {
                                  log('Error: $error');
                                  return const SizedBox();
                                },
                                (ok) => Text(
                                  '${ok.data} người theo dõi',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                    ],
                  ),
                ],
              ),
            ),
            // trailing widget: follow, chat, view shop
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (widget.trailing != null ||
                          widget.showFollowBtn ||
                          widget.showChatBtn ||
                          widget.showViewShopBtn) ...[
                        if (widget.showViewShopBtn) _buildViewShopBtn(context),
                        if (widget.showChatBtn) _buildChatBtn(),
                        if (widget.showFollowBtn) ...[
                          const SizedBox(width: 4),
                          _isLoading
                              ? _buildLoadingBtn()
                              : FutureBuilder(
                                  future: sl<ProductRepository>().followedShopCheckExist(widget.shopId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      final followShopId = snapshot.data;

                                      if (followShopId != null) {
                                        return _buildUnFollowBtn(followShopId);
                                      } else {
                                        return _buildFollowBtn(widget.shopId);
                                      }
                                    } else if (snapshot.hasError) {
                                      return const SizedBox.shrink();
                                    } else {
                                      return _buildLoadingBtn();
                                    }
                                  },
                                ),
                        ],
                        if (widget.trailing != null) ...[const SizedBox(width: 4), widget.trailing!],
                      ],
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildViewShopBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        backgroundColor: Colors.blue.shade100,
        side: BorderSide.none,
      ),
      onPressed: () {
        context.push('${ShopPage.path}/${widget.shopId}');
      },
      child: const Text('Xem Shop'),
    );
  }

  Widget _buildFollowBtn(int shopId) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: Colors.green.shade100,
      ),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        final rsEither = await sl<ProductRepository>().followedShopAdd(shopId);

        rsEither.fold(
          (error) => null,
          (ok) {
            setState(() {
              _isLoading = false;
            });
          },
        );
      },
      child: const Text('+ Theo dõi'),
    );
  }

  Widget _buildUnFollowBtn(int followedShopId) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: Colors.red.shade100,
      ),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        final rsEither = await sl<ProductRepository>().followedShopDelete(followedShopId);

        rsEither.fold(
          (error) => null,
          (ok) {
            setState(() {
              _isLoading = false;
            });
          },
        );
      },
      child: const Text('Bỏ theo dõi'),
    );
  }

  Widget _buildChatBtn() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: null,
      child: const Text('Chat'),
    );
  }

  Widget _buildLoadingBtn() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        // backgroundColor: Colors.blue.shade100,
        side: BorderSide.none,
      ),
      onPressed: null,
      child: const Text('Đang tải...'),
    );
  }
}
