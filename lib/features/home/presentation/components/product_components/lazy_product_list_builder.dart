import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../../core/constants/typedef.dart';
import '../../../domain/dto/product_dto.dart';
import '../../../domain/entities/product_entity.dart';
import '../product_item.dart';

class LazyProductListBuilder extends StatefulWidget {
  const LazyProductListBuilder({
    super.key,
    required this.execute,
    required this.scrollController,
    this.future,
    this.crossAxisCount = 2,
    this.showPageNumber = false,
    this.currentPage,
    this.onPageChanged,
    this.keywords,
  })  : assert(crossAxisCount > 0),
        assert(showPageNumber == false || (currentPage != null && onPageChanged != null));

  final Future<RespData<ProductDTO>>? future;
  final Future<RespData<ProductDTO>> Function(int page) execute;
  final String? keywords;
  final int crossAxisCount;

  // for showing page number component at the bottom
  final bool showPageNumber;
  final int? currentPage;
  final void Function(int page)? onPageChanged;
  final ScrollController scrollController;

  @override
  State<LazyProductListBuilder> createState() => _LazyProductListBuilderState();
}

class _LazyProductListBuilderState extends State<LazyProductListBuilder> {
  late int _currentPage;
  bool _isLoading = false;
  final List<ProductEntity> _products = [];

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _loadData(_currentPage);
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent && !_isLoading) {
        log('Load more products in [LazyProductListBuilder]...');
        _loadData(_currentPage);
      }
    });
  }

  Future<void> _loadData(int page) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      List<ProductEntity> data;
      final dataEither = await widget.execute(page);
      data = dataEither.fold(
        (error) {
          log('Error: ${error.toString()}');
          return [];
        },
        (dataResp) {
          final newProducts = dataResp.data.products;
          _currentPage++;
          return newProducts;
        },
      );

      setState(() {
        _products.addAll(data);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return GridView.count(
    //   controller: _scrollController,
    //   crossAxisCount: widget.crossAxisCount,
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   children: _products.map((product) => ProductItem(product: product)).toList(),
    // );

    return GridView.builder(
      // controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _products.length + 1,
      itemBuilder: (context, index) {
        // return Container(
        //   color: Colors.red,
        //   height: 100,
        //   width: 100,
        //   child: Text('Product $index'),
        // );
        if (_products.isEmpty) {
          return const Text('Không tim thấy sản phẩm nào');
        } else if (index == _products.length) {
          return Center(
            child: _isLoading ? const CircularProgressIndicator() : Container(),
          );
        } else {
          return ProductItem(product: _products[index]);
        }
      },
    );
  }
}
