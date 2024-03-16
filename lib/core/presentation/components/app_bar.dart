import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/home/presentation/components/search_components/search_bar.dart';
import '../../../features/home/presentation/pages/search_page.dart';

AppBar buildAppBar(
  BuildContext context, {
  bool showSettingButton = false,
  bool showSearchBar = true,
  TextEditingController? searchController,
  Widget? leading,
  Function(String)? onSubmittedCallback,
  bool clearOnSubmit = false,
}) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    leading: leading,
    automaticallyImplyLeading: false,
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
      const IconButton.outlined(
        onPressed: null,
        icon: Icon(Icons.shopping_cart_outlined),
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
