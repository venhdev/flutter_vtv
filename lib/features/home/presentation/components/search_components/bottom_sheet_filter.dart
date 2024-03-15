import 'package:flutter/material.dart';

import '../../../../../core/helpers/helpers.dart';
import 'btn_filter.dart';
import 'btn_dropdown_sort_types.dart';

class BottomSheetFilter extends StatefulWidget {
  /// default range is 0 - 10tr
  const BottomSheetFilter({
    super.key,
    required this.context,
    required this.minPrice,
    required this.maxPrice,
    required this.sortType,
    this.minRange = 0,
    this.maxRange = 10000000, // 10tr
    this.divisions = 100,
    this.filterPriceRange = true,
  });
  // required
  final BuildContext context;
  final int minPrice;
  final int maxPrice;
  final String sortType;

  // optional
  final double minRange;
  final double maxRange;
  final int divisions;
  final bool filterPriceRange;

  @override
  State<BottomSheetFilter> createState() => _BottomSheetFilterState();
}

class _BottomSheetFilterState extends State<BottomSheetFilter> {
  late RangeValues _currentRangeValues;
  late double _minRange;
  late double _maxRange;
  late String _sortType;

  // optional
  late bool _filterPriceRange;

  @override
  void initState() {
    super.initState();
    if (widget.minPrice < widget.minRange) {
      _minRange = widget.minPrice.toDouble();
    } else {
      _minRange = widget.minRange;
    }

    if (widget.maxPrice > widget.maxRange) {
      _maxRange = widget.maxPrice.toDouble();
    } else {
      _maxRange = widget.maxRange;
    }

    _currentRangeValues = RangeValues(
      widget.minPrice.toDouble(),
      widget.maxPrice.toDouble(),
    );

    _filterPriceRange = widget.filterPriceRange;
    _sortType = widget.sortType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          const Text(
            'Lọc',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(thickness: 0.5, color: Colors.grey),
          _filterByPrice(),
          _buildSortTypes(),
          _btnApplyCancel(context),
        ],
      ),
    );
  }

  Widget _buildSortTypes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Sắp xếp theo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        BtnDropdownSortTypes(
          initValue: _sortType,
          onSortChanged: (sortType) {
            // don't need setState because BtnSortTypes is a stateful widget itself
            _sortType = sortType;
          },
        ),
      ],
    );
  }

  Expanded _btnApplyCancel(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(
                  context,
                  FilterParams(
                    isFiltering: false,
                    minPrice: _currentRangeValues.start.round(),
                    maxPrice: _currentRangeValues.end.round(),
                    sortType: _sortType,
                    filterPriceRange: _filterPriceRange,
                  ),
                );
              },
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: const Center(child: Text('Hủy lọc')),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(
                    context,
                    // (min: _currentRangeValues.start.round(), max: _currentRangeValues.end.round()),
                    FilterParams(
                      isFiltering: true,
                      minPrice: _currentRangeValues.start.round(),
                      maxPrice: _currentRangeValues.end.round(),
                      sortType: _sortType,
                      filterPriceRange: _filterPriceRange,
                    ));
              },
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[300],
                ),
                child: const Center(child: Text('Áp dụng')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionFilterPrice() {
    return Wrap(
      spacing: 10,
      children: [
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
          onPressed: () {
            setState(() {
              _currentRangeValues = const RangeValues(0, 100000);
              if (!_filterPriceRange) {
                _filterPriceRange = true;
              }
            });
          },
          child: const Text('Dưới 100.000'),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
          onPressed: () {
            setState(() {
              _currentRangeValues = const RangeValues(0, 500000);
              if (!_filterPriceRange) {
                _filterPriceRange = true;
              }
            });
          },
          child: const Text('Dưới 500.000'),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
          onPressed: () {
            setState(() {
              _currentRangeValues = const RangeValues(500000, 1000000);
              if (!_filterPriceRange) {
                _filterPriceRange = true;
              }
            });
          },
          child: const Text('500.000 - 1tr'),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
          onPressed: () {
            setState(() {
              _currentRangeValues = const RangeValues(1000000, 2000000);
              if (!_filterPriceRange) {
                _filterPriceRange = true;
              }
            });
          },
          child: const Text('1tr - 2tr'),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
          onPressed: () {
            setState(() {
              _currentRangeValues = const RangeValues(2000000, 5000000);
              if (!_filterPriceRange) {
                _filterPriceRange = true;
              }
            });
          },
          child: const Text('2tr - 5tr'),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
          onPressed: () {
            setState(() {
              _currentRangeValues = const RangeValues(5000000, 10000000);
              if (!_filterPriceRange) {
                _filterPriceRange = true;
              }
            });
          },
          child: const Text('Trên 5tr'),
        ),
      ],
    );
  }

  Column _filterByPrice() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: _filterPriceRange,
              onChanged: (bool? value) {
                setState(() {
                  _filterPriceRange = value!;
                });
              },
            ),
            const Text(
              'Hiện thị sản phẩm theo giá',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        _buildSuggestionFilterPrice(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Từ: ${formatCurrency(_currentRangeValues.start.round())}'),
            Text('Đến: ${formatCurrency(_currentRangeValues.end.round())}'),
          ],
        ),
        const SizedBox(height: 10),
        RangeSlider(
          values: _currentRangeValues,
          min: _minRange,
          max: _maxRange,
          divisions: widget.divisions,
          labels: RangeLabels(
            formatCurrency(_currentRangeValues.start.round()),
            formatCurrency(_currentRangeValues.end.round()),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
      ],
    );
  }
}
