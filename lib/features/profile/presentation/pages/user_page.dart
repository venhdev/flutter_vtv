import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';

import '../../../../core/presentation/components/app_bar.dart';
import '../components/logged_view.dart';
import '../components/not_logged_view.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  static const String routeRoot = '/user';
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
      },
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return NotLoggedView(appBar: appBarBuilder(context, showSettingButton: true, showSearchBar: false));
        } else if (state.status == AuthStatus.authenticated) {
          return LoggedView(auth: state.auth!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
