import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../bloc/auth_cubit.dart';
import 'user_app_bar.dart';

class LoggedWidget extends StatelessWidget {
  const LoggedWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state.auth;
    Logger().d('LoggedWidget: auth: $auth');
    return Scaffold(
      appBar: buildUserAppBar(context),
      body: Center(
        child: Text('Login with $auth'),
      ),
    );
  }
}
