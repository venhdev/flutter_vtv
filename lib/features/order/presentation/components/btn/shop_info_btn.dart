import 'package:flutter/material.dart';

import '../../../../../service_locator.dart';
import '../../../../home/domain/repository/product_repository.dart';

Future<int?> _handleFollowShop(int shopId) async {
  final rsEither = await sl<ProductRepository>().followedShopAdd(shopId);

  return rsEither.fold(
    (error) => null,
    (ok) => ok.data?.followedShopId,
  );
}

Future<int?> _handleUnFollowShop(int followedShopId) async {
  final rsEither = await sl<ProductRepository>().followedShopDelete(followedShopId);

  return rsEither.fold(
    (error) => followedShopId, // if delete failed, return the same id
    (ok) => null,
  );
}

Color? _backgroundColor(ShopInfoEntry entry) {
  switch (entry) {
    case ShopInfoEntry.follow:
      return Colors.green.shade100;
    case ShopInfoEntry.unfollow:
      return Colors.red.shade100;
    default:
      return null;
  }
}

enum ShopInfoEntry {
  chat('Chat'),
  follow('+ Theo dõi'),
  unfollow('Bỏ theo dõi'),
  view('Xem shop'),
  loading('Đang tải...');

  const ShopInfoEntry(
    this.label,
  );
  final String label;
}

class ShopInfoButton extends StatelessWidget {
  const ShopInfoButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onNav,
    this.backgroundColor,
  });

  factory ShopInfoButton.view(void Function()? onNav) {
    return ShopInfoButton(
      label: ShopInfoEntry.view.label,
      onNav: onNav,
      backgroundColor: Colors.blue.shade100,
    );
  }

  factory ShopInfoButton.loading() {
    return ShopInfoButton(
      label: ShopInfoEntry.loading.label,
      onPressed: null,
      backgroundColor: _backgroundColor(ShopInfoEntry.loading),
    );
  }

  factory ShopInfoButton.unFollow(int followedShopId, void Function(int? followedShopId) onFollowChanged) {
    return ShopInfoButton(
      label: ShopInfoEntry.unfollow.label,
      onPressed: () async {
        onFollowChanged(await _handleUnFollowShop(followedShopId));
      },
      backgroundColor: _backgroundColor(ShopInfoEntry.unfollow),
    );
  }

  factory ShopInfoButton.follow(int shopId, void Function(int? followedShopId) onFollowChanged) {
    return ShopInfoButton(
      label: ShopInfoEntry.follow.label,
      onPressed: () async {
        final followedShopId = await _handleFollowShop(shopId);
        onFollowChanged(followedShopId);
      },
      backgroundColor: _backgroundColor(ShopInfoEntry.follow),
    );
  }

  factory ShopInfoButton.chat(void Function()? onNav) {
    return ShopInfoButton(
      label: ShopInfoEntry.chat.label,
      onNav: onNav,
      backgroundColor: Colors.blue.shade100,
    );
  }

  final Color? backgroundColor;
  final String label;

  /// return true when success
  final void Function()? onPressed;
  final void Function()? onNav;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: backgroundColor,
        // side: BorderSide.none,
      ),
      onPressed: onPressed ?? onNav,
      child: Text(label),
    );
  }
}

Widget test() {
  return ShopInfoButton.view(() => true);
}
