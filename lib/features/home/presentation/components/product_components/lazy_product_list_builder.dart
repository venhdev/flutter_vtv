import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/typedef.dart';
import '../../../domain/dto/product_page_resp.dart';
import '../../../domain/entities/product_entity.dart';
import '../../pages/product_detail_page.dart';
import 'product_item.dart';

const bool _showIndicator = false;

class LazyProductListBuilder extends StatefulWidget {
  const LazyProductListBuilder({
    super.key,
    required this.dataCallback,
    this.scrollController,
    this.crossAxisCount = 2,
    this.emptyMessage = 'Không có sản phẩm nào',
  }) : assert(crossAxisCount > 0);

  final Future<RespData<ProductPageResp>> Function(int page) dataCallback;
  final int crossAxisCount;
  final ScrollController? scrollController; //! null -> use internal scrollController

  final String emptyMessage;

  @override
  State<LazyProductListBuilder> createState() => _LazyProductListBuilderState();
}

class _LazyProductListBuilderState extends State<LazyProductListBuilder> {
  late ScrollController _scrollController;
  late int _currentPage;
  bool _isLoading = false;
  final List<ProductEntity> _products = [];
  String? _message;

  //! cannot dispose scrollController because it is passed from parent

  @override
  void initState() {
    log('[LazyProductListBuilder] initState');
    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    } else {
      _scrollController = ScrollController();
    }
    _currentPage = 1;
    _loadData(_currentPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
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
            log('[LazyProductListBuilder] No more products');
            _message = 'Không còn sản phẩm nào';
          } else {
            _currentPage++; // After loading data, increase the current page by 1
          }
          return newProducts;
        },
      );

      if (mounted) {
        setState(() {
          log('[LazyProductListBuilder] Load ${data.length} products at page $page');
          _products.addAll(data);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log('[LazyProductListBuilder] build with ${_products.length} products');
    if (_products.isEmpty && !_isLoading) {
      return Center(
        child: Text(
          widget.emptyMessage,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }
    //? If parent passes the scrollController
    //: 1: Disable the physics of the GridView & shrinkWrap it
    //: 2: Use the parent's scrollController
    return GridView.builder(
      controller: widget.scrollController != null ? null : _scrollController,
      physics: widget.scrollController != null ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: widget.scrollController != null ? true : false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _showIndicator ? _products.length + 1 : _products.length,
      itemBuilder: (context, index) {
        if (_products.isEmpty && _isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == _products.length) {
          return Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _message == null
                    ? Container()
                    : Text('$_message'),
          );
        } else {
          return ProductItem(
            product: _products[index],
            onPressed: () {
              context.go(ProductDetailPage.path, extra: _products[index].productId);
            },
          );
        }
      },
    );
  }
}
