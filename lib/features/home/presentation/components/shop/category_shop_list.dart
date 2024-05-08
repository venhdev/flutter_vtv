import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';

import '../../../../../service_locator.dart';

class ShopCategoryList extends StatelessWidget {
  const ShopCategoryList({super.key, required this.shopId});

  final int shopId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<GuestRepository>().getCategoryShopByShopId(shopId),
      // future: getCategoryShopByShopId(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.fold(
            (error) => MessageScreen.error(error.message),
            (ok) {
              if (ok.data!.isEmpty) return const MessageScreen(message: 'Danh sách trống');
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(color: Colors.grey),
                itemCount: ok.data!.length,
                itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      style: ListTileStyle.list,
                      leading: Image.network(ok.data![index].image),
                      title: Text(ok.data![index].name),
                      subtitle: Text('${ok.data![index].countProduct} sản phẩm'),
                    )),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
