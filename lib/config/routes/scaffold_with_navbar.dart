import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vtv_common/core.dart';

import '../../app_state.dart';
import '../../core/presentation/pages/intro_page.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // the first run of the app
        if (appState.isFirstRun == true) {
          return const IntroPage();
        } else if (appState.isServerDown == null) {
          return Scaffold(
            body: MessageScreen(
              message: 'Đang kiểm tra kết nối đến máy chủ...',
              icon: Image.asset('assets/images/loading.gif', height: 100, width: 100),
            ),
          );
        } else if (appState.isServerDown == true) {
          return Scaffold(
            body: MessageScreen(
              message: 'Không thể kết nối đến máy chủ...',
              icon: const Icon(Icons.wifi_off),
              onPressed: () => appState.retryConnection(),
              onIconLongPressed: () => context.push('/dev'),
            ),
          );
        } else if (appState.isServerDown == false) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  tooltip: 'Trang chủ',
                  label: 'Trang chủ', // index => 0
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  tooltip: 'Thông báo',
                  label: 'Thông báo', // index => 1
                  backgroundColor: Colors.blue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  tooltip: 'Tài khoản',
                  label: 'Tài khoản', // index => 2
                  backgroundColor: Colors.blue,
                ),
              ],
              currentIndex: navigationShell.currentIndex,
              onTap: (int index) => _onTap(context, index),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Đã xảy ra lỗi không xác định...'),
            ),
          );
        }
      },
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
