import 'package:flutter/material.dart';
import 'package:flutter_vtv/features/auth/domain/entities/user_info_entity.dart';

import 'user_app_bar.dart';

class LoggedWidget extends StatelessWidget {
  const LoggedWidget({
    super.key,
    required this.userInfo,
  });

 final UserInfoEntity userInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildUserAppBar(context),
      body: Center(
        child: Text('Login with ${userInfo.toString()}'),
      ),
    );
  }
}
