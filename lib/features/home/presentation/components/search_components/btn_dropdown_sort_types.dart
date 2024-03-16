import 'package:flutter/material.dart';

import '../../../../../core/constants/enum.dart';

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
          value: SortTypes.newest,
          child: Text('Mới nhất'),
        ),
        DropdownMenuItem(
          value: SortTypes.bestSelling,
          child: Text('Bán chạy'),
        ),
        DropdownMenuItem(
          value: SortTypes.priceAsc,
          child: Text('Giá tăng dần'),
        ),
        DropdownMenuItem(
          value: SortTypes.priceDesc,
          child: Text('Giá giảm dần'),
        ),
        DropdownMenuItem(
          value: SortTypes.random,
          child: Text('Ngẫu nhiên'),
        ),
      ],
    );
  }
}
