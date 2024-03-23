import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../components/logged_widget.dart';
import '../components/not_logged_widget.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  static const String routeName = 'user';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: context.read<AuthCubit>(),
      listener: (context, state) {
        // if there is message, show snackbar
        if (state.message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
        }
        if (state.status == AuthStatus.unauthenticated) {
          context.read<CartBloc>().add(FetchCart());
          if (state.code == 200 && state.redirectTo != null) {
            context.go(state.redirectTo!);
          }
        } else if (state.status == AuthStatus.authenticated) {
          context.read<CartBloc>().add(InitialCart());
          if (state.code == 200 && state.redirectTo != null) {
            context.go(state.redirectTo!);
          }
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const NotLoggedWidget();
        } else if (state.status == AuthStatus.authenticated) {
          return LoggedWidget(auth: state.auth!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
