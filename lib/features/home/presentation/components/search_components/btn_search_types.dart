import 'package:flutter/material.dart';

class BtnSortTypes extends StatefulWidget {
  const BtnSortTypes({
    super.key,
    required this.onSortChanged,
    this.initValue,
  });

  final Function(String) onSortChanged;
  final String? initValue;

  @override
  State<BtnSortTypes> createState() => _BtnSortTypesState();
}

class _BtnSortTypesState extends State<BtnSortTypes> {
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
          value: 'newest',
          child: Text('Mới nhất'),
        ),
        DropdownMenuItem(
          value: 'best-selling',
          child: Text('Bán chạy'),
        ),
        DropdownMenuItem(
          value: 'price-asc',
          child: Text('Giá tăng dần'),
        ),
        DropdownMenuItem(
          value: 'price-desc',
          child: Text('Giá giảm dần'),
        ),
        DropdownMenuItem(
          value: 'random',
          child: Text('Ngẫu nhiên'),
        ),
      ],
    );
  }
}
