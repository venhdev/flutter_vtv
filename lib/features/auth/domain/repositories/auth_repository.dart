import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  FResult<AuthEntity> retrieveAuth();
  FResult<AuthEntity> loginWithUsernameAndPassword(String username, String password);
  FResultVoid cacheAuth(AuthEntity authEntity);
}