import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/guest.dart';
import 'package:vtv_common/shop.dart';

import '../../../../../service_locator.dart';

final fakeData = [
  CategoryShopEntity(
    categoryShopId: 1,
    shopId: 1,
    name: 'Category 1',
    image: 'https://via.placeholder.com/150',
    countProduct: 10,
    products: [],
  ),
  CategoryShopEntity(
    categoryShopId: 2,
    shopId: 1,
    name: 'Category 2',
    image: 'https://via.placeholder.com/150',
    countProduct: 10,
    products: [],
  ),
  CategoryShopEntity(
    categoryShopId: 3,
    shopId: 1,
    name: 'Category 3',
    image: 'https://via.placeholder.com/150',
    countProduct: 10,
    products: [],
  ),
];

FRespData<List<CategoryShopEntity>> getCategoryShopByShopId() async {
  Future.delayed(const Duration(seconds: 2));
  return Right(SuccessResponse(data: fakeData));
}

class CategoryShopList extends StatelessWidget {
  const CategoryShopList({super.key, required this.shopId});

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
            (ok) => ListView.separated(
              separatorBuilder: (context, index) => const Divider(color: Colors.grey),
              itemCount: ok.data!.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  style: ListTileStyle.list,
                  
                  leading: Image.network(ok.data![index].image),
                  title: Text(ok.data![index].name),
                  subtitle: Text('${ok.data![index].countProduct} sản phẩm'),
                )
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
