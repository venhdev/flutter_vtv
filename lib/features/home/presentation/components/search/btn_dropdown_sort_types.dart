import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';

class BtnDropdownSortTypes extends StatefulWidget {
  const BtnDropdownSortTypes({
    super.key,
    required this.onSortChanged,
    this.initValue,
  });

  final Function(String) onSortChanged;
  final String? initValue;

  @override
  State<BtnDropdownSortTypes> createState() => _BtnDropdownSortTypesState();
}

class _BtnDropdownSortTypesState extends State<BtnDropdownSortTypes> {
  late String _selectedSortType; // Default sort type

  @override
  void initState() {
    super.initState();
    _selectedSortType = widget.initValue ?? 'newest';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedSortType,
      onChanged: (String? newValue) {
        setState(() {
          _selectedSortType = newValue!;
        });
        widget.onSortChanged(_selectedSortType);
      },
      items: const [
        DropdownMenuItem(
          value: SortType.newest,
          child: Text('Mới nhất'),
        ),
        DropdownMenuItem(
          value: SortType.bestSelling,
          child: Text('Bán chạy'),
        ),
        DropdownMenuItem(
          value: SortType.priceAsc,
          child: Text('Giá tăng dần'),
        ),
        DropdownMenuItem(
          value: SortType.priceDesc,
          child: Text('Giá giảm dần'),
        ),
        DropdownMenuItem(
          value: SortType.random,
          child: Text('Ngẫu nhiên'),
        ),
      ],
    );
  }
}
