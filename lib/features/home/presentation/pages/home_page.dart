import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../search/presentation/components/search_bar_component.dart';
import '../components/category_list.dart';
import '../components/product_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('VTV'),
        title: Text(
          "VTV",
          style: GoogleFonts.ribeye(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: const SearchBarComponent(),
          ),
        ],
      ),
      body: ListView(
        children: const [
          // Category
          Category(),
          // Product
          ProductList(),
        ],
      ),
    );
  }
}
