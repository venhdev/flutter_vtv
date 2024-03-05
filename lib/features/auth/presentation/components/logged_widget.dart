import 'package:flutter/material.dart';

import '../../domain/entities/auth_entity.dart';
import 'user_app_bar.dart';

class LoggedWidget extends StatelessWidget {
  const LoggedWidget({
    super.key,
    required this.auth,
  });

  final AuthEntity auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildUserAppBar(context, auth),
      body: const Column(
        children: [],
      ),
    );
  }
}
