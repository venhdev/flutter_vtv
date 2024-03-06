
import 'package:flutter/material.dart';

class SortComponent extends StatefulWidget {
  final Function(String) onSortChanged;

  const SortComponent({super.key, required this.onSortChanged});

  @override
  _SortComponentState createState() => _SortComponentState();
}

class _SortComponentState extends State<SortComponent> {
  String selectedSortType = 'newest'; // Default sort type

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedSortType,
      onChanged: (String? newValue) {
        setState(() {
          selectedSortType = newValue!;
        });
        widget.onSortChanged(selectedSortType);
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
