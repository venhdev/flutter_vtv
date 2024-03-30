import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../../features/cart/presentation/pages/cart_page.dart';
import '../../../features/home/presentation/components/search_components/search_bar.dart';
import '../../../features/home/presentation/pages/search_page.dart';

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
                context.go(SearchPage.path, extra: text);
              }
            },
          ),
        ),
      // icon cart badge (number of items in cart)
      const CartBadge(),

      // icon settings
      if (showSettingButton)
        IconButton.outlined(
          onPressed: () => context.go('/user/settings'),
          icon: const Icon(Icons.settings_outlined),
        ),
    ],
  );
}

class CartBadge extends StatelessWidget {
  const CartBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status != AuthStatus.authenticated) {
          return const SizedBox.shrink();
        } else {
          return Row(
            children: [
              // icon cart
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoaded) {
                    if (state.cart.count == 0) {
                      return IconButton.outlined(
                        onPressed: () => context.go(CartPage.path),
                        icon: const Icon(Icons.shopping_cart_outlined),
                      );
                    }
                    return Badge(
                      label: Text(state.cart.count.toString()),
                      backgroundColor: Colors.orange,
                      child: IconButton.outlined(
                        onPressed: () => context.go(CartPage.path),
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                    );
                  } else if (state is CartInitial || state is CartLoading) {
                    return const IconButton.outlined(
                      onPressed: null,
                      icon: Icon(Icons.shopping_cart_outlined),
                    );
                  }
                  // NOTE: there may be some other states/errors that need to be handled
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              // icon chat
              const IconButton.outlined(
                onPressed: null,
                // onPressed: () {
                //   // log(context.read<CartBloc>().state.toString());
                //   // context.read<CartBloc>().add(InitialCart());
                // },
                icon: Icon(Icons.chat_outlined),
              ),
            ],
          );
        }
      },
    );
  }
}
// return Badge(
//   label: BlocBuilder<AuthCubit, AuthState>(
//     builder: (context, state) {
//       if (state.status != AuthStatus.authenticated) return const SizedBox.shrink();
//       return BlocBuilder<CartBloc, CartState>(
//         builder: (context, state) {
//           if (state is CartLoaded) {
//             return Text(state.cart.count.toString());
//           }
//           return const SizedBox.shrink();
//         },
//       );
//     },
//   ),
//   backgroundColor: Colors.orange,
//   child: IconButton.outlined(
//     onPressed: () => context.go(CartPage.route),
//     icon: const Icon(Icons.shopping_cart_outlined),
//   ),
// );
