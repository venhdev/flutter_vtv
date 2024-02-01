import 'package:flutter_vtv/core/usecase/base_usecase.dart';

import '../../../../core/constants/typedef.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RetrieveAuthUC extends UseCaseNoParam<FResult<AuthEntity>> {
  final AuthRepository _authRepository;

  RetrieveAuthUC(this._authRepository);
  @override
  FResult<AuthEntity> call() async {
    return await _authRepository.retrieveAuth();
  }
}
