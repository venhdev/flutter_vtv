import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
              'assets/images/intro_background.svg',
              semanticsLabel: 'Decorative background',
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    const Text(
                      "Khám phá ứng dụng",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      "VTV là nền tảng trực tuyến kết nối người mua và người bán, tập trung vào việc giao dịch các sản phẩm và dịch vụ từ các nhà cung cấp đa dạng",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStartButton(context)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildStartButton(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Provider.of<AppState>(context, listen: false).started(),
      child: Container(
        width: 328,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xffffc600),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Bắt đầu",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
