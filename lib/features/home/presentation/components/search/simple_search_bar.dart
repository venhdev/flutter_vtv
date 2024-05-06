import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/features/home/domain/entities/search_history_entity.dart';
import 'package:flutter_vtv/features/home/domain/repository/search_product_repository.dart';
import 'package:vtv_common/auth.dart';

import '../../../../../service_locator.dart';
import 'customer_search_delegate.dart';

class SimpleSearchBar extends StatefulWidget {
  const SimpleSearchBar({
    super.key,
    this.clearOnSubmit = false,
    this.controller,
    required this.onSubmitted,
    this.hintText,
    this.hintStyle = const TextStyle(color: Colors.grey),
  });

  final bool clearOnSubmit;
  final void Function(String text)? onSubmitted;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle hintStyle;

  @override
  State<SimpleSearchBar> createState() => _SimpleSearchBarState();
}

class _SimpleSearchBarState extends State<SimpleSearchBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    //> if controller is passed, use it, otherwise create a new one
    if (widget.controller != null) {
      _searchController = widget.controller!;
    } else {
      _searchController = TextEditingController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      readOnly: true,
                      onTap: () async {
                        final List<SearchHistoryEntity> searchHistories;
                        final isLoggedIn = context.read<AuthCubit>().state.auth != null;

                        //> when logged in, get search history of user
                        if (isLoggedIn) {
                          final resultEither = await sl<SearchProductRepository>().searchHistoryGetPage(1, 50);
                          if (!context.mounted) return;

                          searchHistories = resultEither.fold(
                            (error) => [],
                            (ok) => ok.data!.items,
                          );
                        } else {
                          searchHistories = [];
                        }

                        final searchResult = await showSearch<SearchHistoryEntity>(
                          context: context,
                          delegate: CustomerSearchDelegate(searchList: searchHistories),
                        );

                        if (searchResult != null) {
                          _handleSubmitted(searchResult.search);
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                        hintText: widget.hintText ?? 'Tìm kiếm sản phẩm',
                        border: InputBorder.none,
                        hintStyle: widget.hintStyle,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _handleSubmitted(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _handleSubmitted(_searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      //> save search history
      final isLoggedIn = context.read<AuthCubit>().state.auth != null;
      if (isLoggedIn) {
        sl<SearchProductRepository>().searchHistoryAdd(searchQuery);
      }

      widget.onSubmitted?.call(searchQuery);
      if (widget.clearOnSubmit) _searchController.clear();
    }
  }
}
