import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/components/custom_dialogs.dart';
import 'address_page.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routeName = 'settings';
  static const String path = '/user/settings';

  Widget _buildButton(BuildContext context, {required String title, required void Function()? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer.withOpacity(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

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
                  _buildAddress(context),
                  _buildChangePassword(context),
                  _buildLogout(context),
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

  Widget _buildLogout(BuildContext context) {
    return _buildButton(context, title: 'Đăng xuất', onPressed: () {
      showDialogToConfirm(
        context: context,
        title: 'Đăng xuất',
        content: 'Bạn có chắc chắn muốn đăng xuất?',
        // confirmTextColor: Colors.red,
        confirmBackgroundColor: Colors.red.shade100,
        confirmTextColor: Colors.red.shade900,
        confirmText: 'Đăng xuất',
        dismissText: 'Thoát',
        onConfirm: () async {
          final refreshToken = context.read<AuthCubit>().state.auth!.refreshToken;
          await context.read<AuthCubit>().logout(refreshToken).then((_) {
            // redirect to user home
            GoRouter.of(context).go('/user');
          });
        },
      );
    });
  }

  Widget _buildChangePassword(BuildContext context) {
    return _buildButton(
      context,
      title: 'Thay đổi mật khẩu',
      onPressed: () {
        GoRouter.of(context).go('/user/settings/change-password');
      },
    );
  }

  Widget _buildAddress(BuildContext context) {
    return _buildButton(
      context,
      title: 'Địa chỉ',
      onPressed: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => const AddressPage(),
        // ));
        GoRouter.of(context).go(AddressPage.path);
      },
    );
  }
}
