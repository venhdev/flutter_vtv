import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../core/presentation/pages/intro_page.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
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
            currentIndex: _calculateSelectedIndex(context),
            onTap: (int idx) => _onItemTapped(idx, context),
          ),
          // bottomNavigationBar: _shouldShowBottomNavigationBar(context)
          //     ? appState.isBottomNavigationVisible
          //         ? BottomNavigationBar(
          //             items: const <BottomNavigationBarItem>[
          //               BottomNavigationBarItem(
          //                 icon: Icon(Icons.shopping_cart),
          //                 tooltip: 'Trang chủ',
          //                 label: 'Trang chủ', // index => 0
          //               ),
          //               BottomNavigationBarItem(
          //                 icon: Icon(Icons.notifications),
          //                 tooltip: 'Thông báo',
          //                 label: 'Thông báo', // index => 1
          //                 backgroundColor: Colors.blue,
          //               ),
          //               BottomNavigationBarItem(
          //                 icon: Icon(Icons.person),
          //                 tooltip: 'Tài khoản',
          //                 label: 'Tài khoản', // index => 2
          //                 backgroundColor: Colors.blue,
          //               ),
          //             ],
          //             currentIndex: _calculateSelectedIndex(context),
          //             onTap: (int idx) => _onItemTapped(idx, context),
          //           )
          //         : null
          //     : null,
        );
      },
    );
  }

  // bool _shouldShowBottomNavigationBar(BuildContext context) {
  //   final String location = GoRouterState.of(context).uri.toString();
  //   return true;
  // switch (location) {
  //   case CartPage.path:
  //   case ProductDetailPage.path:
  //   case AddressPage.path:
  //   case AddAddressPage.path:
  //   case CheckoutPage.path || '${CheckoutPage.path}?isCreateWithCart=false':
  //   case SettingsPage.path:
  //   case OrderDetailPage.path:
  //   case PurchasePage.path:
  //   case SearchPage.path:
  //     return false;
  //   default:
  //     return true;
  // }
  // }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/notification')) {
      return 1;
    }
    if (location.startsWith('/user')) {
      return 2;
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
        GoRouter.of(context).go('/notification');
      case 2:
        GoRouter.of(context).go('/user');
      // case 2:
      //   GoRouter.of(context).go('/home');
      // case 3:
      //   GoRouter.of(context).go('/home');
    }
  }
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar2 extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar2({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        // Here, the items of BottomNavigationBar are hard coded. In a real
        // world scenario, the items would most likely be generated from the
        // branches of the shell route, which can be fetched using
        // `navigationShell.route.branches`.
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
