import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app_state.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/cart_bloc.dart';
import '../pages/cart_page.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({
    super.key,
    this.pushOnNav = false,
  });

  final bool pushOnNav;

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
                      return IconButton(
                        onPressed: () {
                          if (pushOnNav) {
                            context.read<AppState>().hideBottomNav();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const CartPage();
                                },
                              ),
                            ).then((_) => context.read<AppState>().showBottomNav());
                          } else {
                            context.go(CartPage.path);
                          }
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                      );
                    }
                    return Badge(
                      label: Text(state.cart.count.toString()),
                      backgroundColor: Colors.orange,
                      offset: const Offset(0, 0),
                      child: IconButton(
                        onPressed: () {
                          if (pushOnNav) {
                            Provider.of<AppState>(context, listen: false).setBottomNavigationVisibility(false);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const CartPage();
                                },
                              ),
                            ).then((_) =>
                                Provider.of<AppState>(context, listen: false).setBottomNavigationVisibility(true));
                          } else {
                            context.go(CartPage.path);
                          }
                        },
                        icon: const Icon(Icons.shopping_cart),
                      ),
                    );
                  } else if (state is CartInitial || state is CartLoading) {
                    return const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.shopping_cart),
                    );
                  }
                  // REVIEW: there may be some other states/errors that need to be handled
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              // TODO chat
              // icon chat
              // const IconButton.outlined(
              //   onPressed: null,
              //   // onPressed: () {
              //   //   // log(context.read<CartBloc>().state.toString());
              //   //   // context.read<CartBloc>().add(InitialCart());
              //   // },
              //   icon: Icon(Icons.chat_outlined),
              // ),
            ],
          );
        }
      },
    );
  }
}
