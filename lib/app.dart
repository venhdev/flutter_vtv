import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/routes/app_routes.dart';
import 'config/themes/theme_provider.dart';

class VTVApp extends StatelessWidget {
  const VTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // title: 'Nhóm 1',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      // home: const HomePage(title: 'Flutter Demo Home Page'),
      routerConfig: AppRoutes.router,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
