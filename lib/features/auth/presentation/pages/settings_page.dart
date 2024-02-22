import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/components/custom_dialogs.dart';
import '../../../../core/presentation/components/custom_widgets.dart';
import '../bloc/auth_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        // fill the column width
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // logout button
          if (isLogin(context)) _buildLogoutButton(context),
        ],
      ),
    );
  }

  TextButton _buildLogoutButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        showMyDialogToConfirm(
            context: context,
            title: 'Đăng xuất',
            content: 'Bạn có chắc chắn muốn đăng xuất?',
            onConfirm: () async {
              final refreshToken = context.read<AuthCubit>().state.auth!.refreshToken;
              Logger().e('refreshToken: $refreshToken');
              await context.read<AuthCubit>().logout(refreshToken).then((_) {
                // redirect to user home
                GoRouter.of(context).go('/user');
              });
            });
      },
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticating) {
            return loadingWidget;
          }
          return const Text(
            'Đăng xuất',
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}
