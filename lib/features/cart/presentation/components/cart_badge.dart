import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';

import '../bloc/cart_bloc.dart';
import '../pages/cart_page.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return _cart();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  BlocBuilder<CartBloc, CartState> _cart() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          if (state.cart.count == 0) {
            return IconButton(
              onPressed: () {
                context.push(CartPage.path);
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
                context.push(CartPage.path);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          );
        } else if (state is CartInitial || state is CartLoading) {
          return IconButton(
            onPressed: null,
            icon: Image.asset('assets/images/loading.gif', width: 40, height: 40),
          );
        }
        return GestureDetector(
          onTap: () => context.read<CartBloc>().add(const FetchCart()),
          child: const IconButton(
            onPressed: null,
            icon: Icon(Icons.shopping_cart),
          ),
        );
      },
    );
  }
}
