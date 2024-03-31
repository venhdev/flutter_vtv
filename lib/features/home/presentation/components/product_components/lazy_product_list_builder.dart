import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/constants/typedef.dart';
import '../../../domain/dto/product_page_resp.dart';
import '../../../domain/entities/product_entity.dart';
import 'product_item.dart';

class LazyProductListBuilder extends StatefulWidget {
  const LazyProductListBuilder({
    super.key,
    required this.dataCallback,
    required this.scrollController,
    this.crossAxisCount = 2,
  }) : assert(crossAxisCount > 0);

  final Future<RespData<ProductPageResp>> Function(int page) dataCallback;
  final int crossAxisCount;
  final ScrollController scrollController;

  @override
  State<LazyProductListBuilder> createState() => _LazyProductListBuilderState();
}

class _LazyProductListBuilderState extends State<LazyProductListBuilder> {
  late int _currentPage;
  bool _isLoading = false;
  final List<ProductEntity> _products = [];
  String? _message;

  @override
  void initState() {
    log('[LazyProductListBuilder] initState');
    super.initState();
    _currentPage = 1;
    _loadData(_currentPage);
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
              widget.scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadData(_currentPage);
      }
    });
  }

  Future<void> _loadData(int page) async {
    if (!_isLoading) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      await Future.delayed(const Duration(milliseconds: 500));

      List<ProductEntity> data;
      final dataEither = await widget.dataCallback(page);
      data = dataEither.fold(
        (error) {
          Fluttertoast.showToast(msg: '${error.message}');
          return [];
        },
        (dataResp) {
          final newProducts = dataResp.data.products;
          if (newProducts.isEmpty) {
            _message = 'Không còn sản phẩm nào';
          } else {
            _currentPage++; // After loading data, increase the current page by 1
          }
          return newProducts;
        },
      );

      if (mounted) {
        setState(() {
          _products.addAll(data);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log('[LazyProductListBuilder] build with ${_products.length} products');
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
        if (_products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == _products.length) {
          return Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _message == null
                    ? Container()
                    : Text(
                        '$_message',
                      ),
          );
        } else {
          return ProductItem(product: _products[index]);
        }
      },
    );
  }
}
