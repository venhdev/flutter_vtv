import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/components/custom_widgets.dart';
import '../bloc/auth_cubit.dart';
import '../components/logged_widget.dart';
import '../components/not_logged_widget.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  static const String routeName = 'user';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // if there is message, show snackbar
        if (state.message != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
            ),
          );
        }
        if (state.status == AuthStatus.unauthenticated) {
          if (state.code == 200) {
            context.go('/user/login');
          }
        } else if (state.status == AuthStatus.authenticated) {
          if (state.code == 200) {
            context.go('/home');
          }
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const NotLoggedWidget();
        } else if (state.status == AuthStatus.authenticated) {
          return LoggedWidget(auth: state.auth!);
        } else {
          return loadingWidget;
        }
      },
    );
  }
}
