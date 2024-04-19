//! Error when using vi language in jsonEncode

import 'package:vtv_common/vtv_common.dart';

const tUsername = 'admin';
const tPassword = 'admin';
const tRefreshToken = 'testRefreshToken';
const tSuccessResponse = SuccessResponse(code: 200, message: 'success');

final tUserInfoEntity = UserInfoEntity(
  customerId: 0,
  username: 'username',
  fullName: 'fullName',
  gender: true,
  email: 'email',
  birthday: DateTime(2000, 1, 1),
  status: Status.ACTIVE,
  roles: const [Role.CUSTOMER],
);
final tAuthEntity = AuthEntity(
  accessToken: 'accessToken',
  refreshToken: 'refreshToken',
  userInfo: tUserInfoEntity,
);

final tAuthModel = AuthEntity(
  accessToken: 'accessToken',
  refreshToken: 'refreshToken',
  userInfo: tUserInfoEntity,
);
