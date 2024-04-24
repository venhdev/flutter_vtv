import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../auth/presentation/components/rating.dart';
import 'btn/shop_info_btn.dart';

class ShopInfo extends StatelessWidget {
  const ShopInfo({
    super.key,
    required this.shopId,
    this.followedShopId,
    this.shopDetail,
    this.shopName,
    this.shopAvatar,
    this.padding,
    this.decoration,
    this.onPressed,
    this.hideAllButton = false,
    this.showFollowBtn = false, //> followedShopId (check) + onFollowChanged (update)
    this.showChatBtn = false,
    this.showViewShopBtn = false,
    this.showFollowedCount = false,
    this.trailing,
    this.showShopDetail = false,
    this.onViewPressed,
    this.onChatPressed,
    this.onFollowChanged,
  })  : assert((shopName != null && shopAvatar != null) || shopDetail != null),
        assert(showFollowedCount && shopDetail != null || !showFollowedCount),
        assert(showFollowBtn && onFollowChanged != null || !showFollowBtn);

  factory ShopInfo.viewOnly({
    required int shopId,
    required String shopName,
    required String shopAvatar,
  }) {
    return ShopInfo(
      shopId: shopId,
      shopName: shopName,
      shopAvatar: shopAvatar,
      hideAllButton: true,
    );
  }

  // required data
  final int shopId;
  final int? followedShopId;
  final ShopDetailResp? shopDetail;

  final String? shopName;
  final String? shopAvatar;

  // control which button to show
  final bool hideAllButton;
  final bool showFollowBtn;
  final bool showChatBtn;
  final bool showViewShopBtn;
  final bool showFollowedCount;
  final bool showShopDetail;

  // others
  final Widget? trailing; //REVIEW maybe delete this

  final void Function()? onPressed; // GoRouter.of(context).push('${ShopPage.path}/${shop.shopId}');
  final void Function()? onViewPressed;
  final void Function()? onChatPressed;

  // controlled by parent
  final void Function(int? followedShopId)? onFollowChanged;

  // style the widget
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: decoration,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //# avatar - [name - count followed]
                  _shopBaseInfo(),
                  //# trailing buttons: follow, chat, view shop
                  if (!hideAllButton) _actionButtons(context)
                ],
              ),

              //# more info (only available when ShopDetail is provided)
              if (showShopDetail && shopDetail != null) ...[
                _shopMoreInfo(),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _shopMoreInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          child: Rating(
            rating: shopDetail!.averageRatingShop,
            iconSize: 14,
            customText: '${shopDetail!.averageRatingShop.toString()}/5.0',
          ),
        ),
        const VerticalDivider(indent: 4, endIndent: 4),
        Text('${shopDetail!.countProduct} sản phẩm', style: const TextStyle(fontSize: 12)),
        const VerticalDivider(indent: 4, endIndent: 4),
        Text('${shopDetail!.countCategoryShop} danh mục', style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (trailing != null || showFollowBtn || showChatBtn || showViewShopBtn) ...[
              if (showViewShopBtn) ShopInfoButton.view(onViewPressed),
              if (showChatBtn) ShopInfoButton.chat(onChatPressed),
              if (showFollowBtn && onFollowChanged != null) ...[
                const SizedBox(width: 4),
                followedShopId == null
                    ? ShopInfoButton.follow(shopId, onFollowChanged!)
                    : ShopInfoButton.unFollow(followedShopId!, onFollowChanged!),
              ],
              if (trailing != null) ...[const SizedBox(width: 4), trailing!],
            ],
          ],
        ),
      ),
    );
  }

  /// avatar - [name - count followed]
  Widget _shopBaseInfo() {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(shopDetail != null ? shopDetail!.shop.avatar : shopAvatar!),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopDetail != null ? shopDetail!.shop.name : shopName!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (showFollowedCount && shopDetail != null) ...[
                      Text(
                        '${shopDetail!.countFollowed} người theo dõi',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//**// FutureBuilder(
                      //     future: sl<ProductRepository>().countShopFollowed(widget.shopId),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         return snapshot.data!.fold(
                      //           (error) {
                      //             log('Error: $error');
                      //             return const SizedBox();
                      //           },
                      //           (ok) => Text(
                      //             '${ok.data} người theo dõi',
                      //             style: const TextStyle(fontSize: 12),
                      //           ),
                      //         );
                      //       }
                      //       return const SizedBox();
                      //     }), */