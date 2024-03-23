import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/components/custom_dialogs.dart';
import '../bloc/auth_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routeName = 'settings';
  static const String path = 'settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        actions: [
          // dev page button
          IconButton(
            onPressed: () {
              GoRouter.of(context).go('/dev');
            },
            icon: const Icon(Icons.developer_mode),
          ),
        ],
      ),
      body: Column(
        // fill the column width
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // logout button
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.unauthenticated) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildChangePasswordButton(context),
                  _buildLogoutButton(context),
                ],
              );
            },
          ),
          // if (isLogin(context)) _buildChangePasswordButton(context),
          // if (isLogin(context)) _buildLogoutButton(context),
        ],
      ),
    );
  }

  // change password button
  TextButton _buildChangePasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).go('/user/settings/change-password');
      },
      style: TextButton.styleFrom(
        backgroundColor:
            Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Thay đổi mật khẩu',
        style: TextStyle(fontWeight: FontWeight.bold),
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
              final refreshToken =
                  context.read<AuthCubit>().state.auth!.refreshToken;
              await context.read<AuthCubit>().logout(refreshToken).then((_) {
                // redirect to user home
                GoRouter.of(context).go('/user');
              });
            });
      },
      style: TextButton.styleFrom(
        backgroundColor:
            Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticating) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
