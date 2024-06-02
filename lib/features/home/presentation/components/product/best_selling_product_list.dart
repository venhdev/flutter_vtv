import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';

class BestSellingProductListBuilder extends StatelessWidget {
  const BestSellingProductListBuilder({
    super.key,
    required this.lazyListController,
  });

  final LazyListController<ProductEntity> lazyListController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sản phẩm bán chạy',
          textAlign: TextAlign.left, // Align the text to the left
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: lazyListController.scrollDirection,
            child: LazyListBuilder(
              lazyListController: lazyListController,
              itemBuilder: (BuildContext context, int index, _) => lazyListController.build(context, index),
              separatorBuilder: (context, index) => const SizedBox(width: 4.0),
            ),
          ),
        ),
      ],
    );
  }
}
