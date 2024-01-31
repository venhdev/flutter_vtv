import 'package:flutter/widgets.dart';
import 'package:flutter_vtv/features/auth/domain/entities/user_info_entity.dart';

class LoggedWidget extends StatelessWidget {
  const LoggedWidget({
    super.key,
    required this.userInfo,
  });

 final UserInfoEntity userInfo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Login with ${userInfo.toString()}'),
    );
  }
}
