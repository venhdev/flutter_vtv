import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import 'intro_page.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class MainPage extends StatelessWidget {
  /// Constructs an [MainPage].
  const MainPage({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // the first run of the app
        if (appState.isFirstRun == true) {
          return const IntroPage();
        }

        // the app is not connected to the internet

        // if (appState.hasConnection == false) {
        //   return const Scaffold(
        //     body: Center(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           // icon
        //           Icon(Icons.wifi_off),
        //           Text('Không có kết nối mạng'),
        //         ],
        //       ),
        //     ),
        //   );
        // }

        return Scaffold(
          body: child,
          // if the app is not connected to the internet, show a bottom sheet
          bottomSheet: appState.hasConnection == false
              ? BottomSheet(
                  onClosing: () {},
                  enableDrag: false,
                  builder: (context) {
                    return Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(16),
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off),
                          SizedBox(width: 8),
                          Text('Không có kết nối mạng'),
                        ],
                      ),
                    );
                  },
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                tooltip: 'Trang chủ',
                label: 'Trang chủ', // index => 0
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                tooltip: 'Tài khoản',
                label: 'Tài khoản', // index => 1
                backgroundColor: Colors.blue,
              ),
            ],
            currentIndex: _calculateSelectedIndex(context),
            onTap: (int idx) => _onItemTapped(idx, context),
          ),
        );
      },
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/user')) {
      return 1;
    }
    // if (location.startsWith('/h3')) {
    //   return 2;
    // }
    // if (location.startsWith('/h4')) {
    //   return 3;
    // }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
      case 1:
        GoRouter.of(context).go('/user');
      // case 2:
      //   GoRouter.of(context).go('/home');
      // case 3:
      //   GoRouter.of(context).go('/home');
    }
  }
}
