import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/components/custom_widgets.dart';
import 'package:flutter_vtv/features/auth/presentation/components/not_logged_widget.dart';

import '../bloc/auth_bloc.dart';
import '../components/logged_widget.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
              ),
            );
          }
        } else if (state.status == AuthStatus.authenticated) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          return const NotLoggedWidget();
        } else if (state.status == AuthStatus.authenticated) {
          return LoggedWidget(userInfo: state.auth!.userInfo);
        } else {
          return loadingWidget;
        }
      },
    );
  }
}

