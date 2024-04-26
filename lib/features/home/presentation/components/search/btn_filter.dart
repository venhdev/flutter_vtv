// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

import 'sheet_filter.dart';

class BtnFilter extends StatelessWidget {
  const BtnFilter(
    this.context, {
    super.key,
    required this.isFiltering,
    required this.minPrice,
    required this.maxPrice,
    required this.sortType,
    required this.onFilterChanged,
    required this.filterPriceRange,
  });

  final BuildContext context;
  final bool isFiltering;
  final bool filterPriceRange;

  final int minPrice;
  final int maxPrice;
  final String sortType;

  /// will be null if user cancels the filter by tapping outside the bottom sheet
  final void Function(FilterParams?) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      leadingIcon: Icons.filter_alt_outlined,
      label: 'Lọc',
      style: IconButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        backgroundColor: isFiltering ? Colors.green[300] : Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      // backgroundColor: isFiltering ? Colors.blue[300] : null,
      onPressed: () async => await handleBottomSheetFilter(),
    );
  }

  Future<void> handleBottomSheetFilter() async {
    final filterResult = await showModalBottomSheet<FilterParams>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => BottomSheetFilter(
        context: context,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortType: sortType,
        filterPriceRange: filterPriceRange,
      ),
    );

    log('filterResult: ${filterResult.toString()}');
    onFilterChanged(filterResult);
    //   builder: (context) => DraggableScrollableSheet(
    //     initialChildSize: 0.8,
    //     builder: (context, scrollController) => BottomSheetFilter(
    //       context: context,
    //       minPrice: minPrice,
    //       maxPrice: maxPrice,
    //       sortType: sortType,
    //     ),
    //   ),
    // );
  }
}

class FilterParams {
  FilterParams({
    this.isFiltering = false,
    required this.minPrice,
    required this.maxPrice,
    required this.sortType,
    required this.isFilterWithPriceRange,
  });

  /// default is false
  bool isFiltering;

  final int minPrice;
  final int maxPrice;
  final String sortType;
  final bool isFilterWithPriceRange;

  @override
  String toString() {
    return 'FilterParams(isFiltering: $isFiltering, minPrice: $minPrice, maxPrice: $maxPrice, sortType: $sortType, filterPriceRange: $isFilterWithPriceRange)';
  }

  FilterParams copyWith({
    bool? isFiltering,
    int? minPrice,
    int? maxPrice,
    String? sortType,
    bool? isFilterWithPriceRange,
  }) {
    return FilterParams(
      isFiltering: isFiltering ?? this.isFiltering,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortType: sortType ?? this.sortType,
      isFilterWithPriceRange: isFilterWithPriceRange ?? this.isFilterWithPriceRange,
    );
  }
}
