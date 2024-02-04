import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/usecase/base_usecase.dart';
import 'package:flutter_vtv/features/auth/domain/dto/register_params.dart';
import 'package:flutter_vtv/features/auth/domain/repositories/auth_repository.dart';

class RegisterUC implements UseCaseHasParams<FResultVoid, RegisterParams> {
  final AuthRepository authRepository;
  RegisterUC(this.authRepository);
  @override
  FResultVoid call(RegisterParams params) async {
    return await authRepository.register(params);
  }
}
