import 'package:flutter/material.dart';

import '../../../../../core/presentation/components/custom_buttons.dart';
import 'bottom_sheet_filter.dart';

class BtnFilter extends StatelessWidget {
  const BtnFilter(
    this.context, {
    super.key,
    required this.isFiltering,
    required this.minPrice,
    required this.maxPrice,
    required this.sortType,
    required this.onFilterChanged,
  });

  final BuildContext context;
  final bool isFiltering;
  final int minPrice;
  final int maxPrice;
  final String sortType;

  /// will be null if user cancels the filter by tapping outside the bottom sheet
  final void Function(FilterParams?) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      icon: Icons.filter_alt_outlined,
      text: 'Lọc',
      backgroundColor: isFiltering ? Colors.blue[300] : null,
      onPressed: () async => await handleBottomSheetFilter(),
    );
  }

  Future<void> handleBottomSheetFilter() async {
    final filterResult = await showModalBottomSheet<FilterParams>(
      context: context,
      builder: (context) => BottomSheetFilter(
        context: context,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortType: sortType,
      ),
    );

    onFilterChanged(filterResult);
  }
}

class FilterParams {
  FilterParams({
    required this.isFiltering,
    required this.minPrice,
    required this.maxPrice,
    required this.sortType,
    required this.filterPriceRange,
  });

  final bool isFiltering;
  final int minPrice;
  final int maxPrice;
  final String sortType;
  final bool filterPriceRange;
}
