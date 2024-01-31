import 'package:flutter_vtv/core/constants/enum.dart';
import 'package:flutter_vtv/core/error/failures.dart';
import 'package:flutter_vtv/features/auth/data/models/auth_model.dart';
import 'package:flutter_vtv/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_vtv/features/auth/domain/entities/user_info_entity.dart';

const tUsername = 'admin';
const tPassword = 'admin';
final tAuthEntity = AuthEntity(
  accessToken: 'accessToken',
  refreshToken: 'refreshToken',
  userInfo: UserInfoEntity(
    customerId: 0,
    username: 'username',
    fullName: 'fullName',
    gender: true,
    email: 'email',
    birthday: DateTime(2000, 1, 1),
    status: Status.ACTIVE,
    roles: const [Role.CUSTOMER],
  ),
);
final tAuthModel = AuthModel(
  accessToken: 'accessToken',
  refreshToken: 'refreshToken',
  userInfo: UserInfoEntity(
    customerId: 0,
    username: 'username',
    fullName: 'fullName',
    gender: true,
    email: 'email',
    birthday: DateTime(2000, 1, 1),
    status: Status.ACTIVE,
    roles: const [Role.CUSTOMER],
  ),
);
const testServerFailure = ServerFailure();

const dummyLoginSuccessRes = {
  "status": "string",
  "message": "string",
  "code": 0,
  "customerDTO": {
    "customerId": 0,
    "username": "username",
    "email": "email",
    "gender": true,
    "fullName": "fullName",
    "birthday": "2000-01-01",
    "status": "ACTIVE",
    "roles": ["CUSTOMER"]
  },
  "access_token": "accessToken",
  "refresh_token": "refreshToken"
};
const dummyLoginFailPassRes = {
  "code": 400,
  "status": "BAD_REQUEST",
  "message": "message",
};
