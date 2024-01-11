import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vtv/page/home_page.dart';
import 'package:go_router/go_router.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();

    // Timer(
    //   const Duration(seconds: 10),
    //   () => Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const HomePage(),
    //     ),
    //   ),
    // );
    Timer(
      const Duration(seconds: 10),
      () => context.go('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nhóm 1'),
            Text('Thành viên nhóm 1:'),
            Text('Hà Nhật Vềnh - 20110599'),
            Text('Tô Duy Vượng - 20110053'),
            Text('Nguyễn Quốc Trung - 20110588'),
          ],
        ),
      ),
    );
  }
}
