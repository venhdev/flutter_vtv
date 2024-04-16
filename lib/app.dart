import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/routes/routes.dart';
import 'config/themes/theme_provider.dart';

class VTVApp extends StatelessWidget {
  const VTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'VTV Shop',
      routerConfig: AppRoutes.router2,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
