import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/constants/typedef.dart';
import '../../base/base_lazy_load_entity.dart';

// OK_BUG rebuild when the parent long list is scrolled >> lost data + rebuild lazy load
class NestedLazyLoadBuilder<T> extends StatefulWidget {
  const NestedLazyLoadBuilder({
    super.key,
    required this.dataCallback,
    required this.controller,
    // this.onReachEnd,
    // this.scrollController,
    this.crossAxisCount = 2,
    required this.itemBuilder,
    this.showIndicator = false,
    this.emptyMessage = 'Trống',
  }) : assert(crossAxisCount > 0);

  final Future<RespData<IBasePageResp<T>>> Function(int page) dataCallback;
  final LazyLoadController<T> controller;
  // final void Function(List<T>)? onReachEnd;

  final int crossAxisCount;

  // final ScrollController? scrollController; //: null -> use internal scrollController
  final Widget Function(BuildContext context, int index, T data) itemBuilder;

  /// Show loading indicator at the end of the list
  final bool showIndicator;
  final String emptyMessage;

  @override
  State<NestedLazyLoadBuilder<T>> createState() => _NestedLazyLoadBuilderState<T>();
}

class LazyLoadController<T> {
  LazyLoadController({
    required this.scrollController,
    required this.items,
    this.useGrid = false,
    this.currentPage = 1,
  });

  final ScrollController scrollController;
  final List<T> items;
  final bool useGrid;
  int currentPage;

  //add
  void addItems(List<T> newItems) {
    items.addAll(newItems);
  }
}

class _NestedLazyLoadBuilderState<T> extends State<NestedLazyLoadBuilder<T>> {
  // late ScrollController _scrollController; //
  // late int _currentPage;
  bool _isLoading = false;
  String? _message;
  // final List<T> _items = []; //

  // @override
  // void dispose() {
  //   //> dispose the scrollController if it's internal
  //   if (widget.scrollController == null) {
  //     _scrollController.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    // if (widget.scrollController != null) {
    //   _scrollController = widget.scrollController!;
    // } else {
    //   _scrollController = ScrollController();
    // }
    // _currentPage = 1;
    _loadData(widget.controller.currentPage);
    widget.controller.scrollController.addListener(() {
      if (widget.controller.scrollController.position.pixels ==
              widget.controller.scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadData(widget.controller.currentPage);
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

      List<T> data;
      final dataEither = await widget.dataCallback(page);
      data = dataEither.fold(
        (error) {
          Fluttertoast.showToast(msg: '${error.message}');
          return [];
        },
        (dataResp) {
          final newItems = dataResp.data.listItem;
          if (newItems.isEmpty) {
            log('[LazyLoadBuilder] No more items at page $page');
            _message = 'No more items';
          } else {
            // _currentPage++; // After loading data, increase the current page by 1
            widget.controller.currentPage++;
          }
          return newItems;
        },
      );

      log('data length: ${data.length}');

      if (mounted) {
        setState(() {
          log('[LazyLoadBuilder] load more ${data.length} items at page $page');
          // _items.addAll(data);
          //? If parent passes the controller >> call onAddItems
          if (widget.controller.items.isEmpty) {
            widget.controller.addItems(data);
          } else {
            widget.controller.addItems(data);
          }
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // log('[LazyLoadBuilder] build with ${_items.length} items');
    log('[LazyLoadBuilder] build with ${widget.controller.items.length} items');
    if (widget.controller.items.isEmpty && !_isLoading) {
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
    return widget.controller.useGrid ? _buildLazyLoadWithGridView() : _buildLazyLoadWithListView();
  }

  ListView _buildLazyLoadWithListView() {
    return ListView.builder(
      // controller: widget.scrollController != null ? null : _scrollController,
      // physics: widget.scrollController != null ? const NeverScrollableScrollPhysics() : null,
      // shrinkWrap: widget.scrollController != null ? true : false,
      // controller: widget.controller.scrollController,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: widget.crossAxisCount,
      //   crossAxisSpacing: 8,
      //   mainAxisSpacing: 8,
      // ),
      itemCount: widget.showIndicator ? widget.controller.items.length + 1 : widget.controller.items.length,
      itemBuilder: (context, index) {
        if (widget.controller.items.isEmpty && _isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == widget.controller.items.length) {
          return Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _message == null
                    ? Container()
                    : Text('$_message'),
          );
        } else {
          return widget.itemBuilder(context, index, widget.controller.items[index]);
        }
      },
    );
  }

  Widget _buildLazyLoadWithGridView() {
    return GridView.builder(
      // controller: widget.scrollController != null ? null : _scrollController,
      // physics: widget.scrollController != null ? const NeverScrollableScrollPhysics() : null,
      // shrinkWrap: widget.scrollController != null ? true : false,
      // controller: widget.controller.scrollController,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.showIndicator ? widget.controller.items.length + 1 : widget.controller.items.length,
      itemBuilder: (context, index) {
        if (widget.controller.items.isEmpty && _isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == widget.controller.items.length) {
          return Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _message == null
                    ? Container()
                    : Text('$_message'),
          );
        } else {
          return widget.itemBuilder(context, index, widget.controller.items[index]);
        }
      },
    );
  }
}
