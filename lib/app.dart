import 'package:flutter/material.dart';

import 'config/routes/app_routes.dart';

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
      theme: ThemeData.light(),
    );
  }
}
