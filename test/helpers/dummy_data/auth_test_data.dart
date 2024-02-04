import 'package:flutter_vtv/core/constants/enum.dart';
import 'package:flutter_vtv/features/auth/data/models/auth_model.dart';
import 'package:flutter_vtv/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_vtv/features/auth/domain/entities/user_info_entity.dart';

//! Error when using vi language in jsonEncode

const tUsername = 'admin';
const tPassword = 'admin';
const tRefreshToken = 'testRefreshToken';

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

final tAuthModel = AuthModel(
  accessToken: 'accessToken',
  refreshToken: 'refreshToken',
  userInfo: tUserInfoEntity,
);
