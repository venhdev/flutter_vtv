import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/cart/domain/repository/cart_repository.dart';
import '../../../features/home/presentation/components/search_components/search_bar.dart';
import '../../../features/home/presentation/pages/search_page.dart';
import '../../../service_locator.dart';

AppBar buildAppBar(
  BuildContext context, {
  String? title,
  bool showSettingButton = false,
  bool showSearchBar = true,
  TextEditingController? searchController,
  Widget? leading,
  Function(String)? onSubmittedCallback,
  bool clearOnSubmit = false,
  bool automaticallyImplyLeading = false,
}) {
  // title & search bar can't be shown at the same time
  assert(title == null || showSearchBar == false, 'title & search bar can\'t be shown at the same time');
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    leading: leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: [
      // search bar
      if (showSearchBar)
        Expanded(
          child: SearchBarComponent(
            controller: searchController,
            clearOnSubmit: clearOnSubmit,
            onSubmitted: (text) {
              if (onSubmittedCallback != null) {
                onSubmittedCallback(text);
              } else {
                context.go(SearchPage.route, extra: text);
              }
            },
          ),
        ),
      // icon cart
      Badge(
        label: FutureBuilder(
          future: sl<CartRepository>().getCarts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.fold(
                (error) => const Text('-'),
                (data) => Text(data.data.count.toString()),
              );
            }
            return const Text('-');
          },
        ),
        backgroundColor: Colors.orange,
        child: const IconButton.outlined(
          onPressed: null,
          icon: Icon(Icons.shopping_cart_outlined),
        ),
      ),

      // icon chat
      const IconButton.outlined(
        onPressed: null,
        icon: Icon(Icons.chat_outlined),
      ),

      // icon settings
      if (showSettingButton)
        IconButton.outlined(
          onPressed: () => context.go('/user/settings'),
          icon: const Icon(Icons.settings_outlined),
        ),
    ],
  );
}
