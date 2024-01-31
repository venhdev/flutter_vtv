import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/helpers/secure_storage_helper.dart';

import 'package:flutter_vtv/features/auth/domain/entities/auth_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_data_source.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authDataSource, this._connectivity, this._secureStorageHelper);

  final AuthDataSource _authDataSource;
  final Connectivity _connectivity;
  final SecureStorageHelper _secureStorageHelper;

  @override
  FResult<AuthEntity> loginWithUsernameAndPassword(String username, String password) async {
    try {
      final connectivityResult = await (_connectivity.checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return const Left(ConnectionFailure(message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.'));
      }

      final model = await _authDataSource.loginWithUsernameAndPassword(username, password);
      return Right(model.toEntity());
    } on ClientException catch (e) {
      return Left(ClientFailure(code: e.code, message: e.message));
    } on CacheException {
      return const Left(UnexpectedFailure(message: 'Lỗi ứng dụng!'));
    } catch (e) {
      return const Left(UnexpectedFailure(message: 'Lỗi không xác định! [loginWithUsernameAndPassword]'));
    }
  }

  @override
  FResultVoid cacheAuth(AuthEntity authEntity) async {
    try {
      final jsonAuthData = AuthModel.fromEntity(authEntity).toJson();
      await _secureStorageHelper.cacheAuth(jsonAuthData);
      return const Right(null);
    } on CacheException {
      return const Left(UnexpectedFailure(message: 'Lỗi lưu thông tin người dùng!'));
    } catch (e) {
      return const Left(UnexpectedFailure(message: 'Lỗi không xác định! [cacheAuth]'));
    }
  }

  @override
  FResult<AuthEntity> retrieveAuth() async {
    try {
      final authData = await _secureStorageHelper.readAuth();
      return Right(authData);
    } on CacheException {
      return const Left(UnexpectedFailure(message: 'Lỗi lấy thông tin người dùng!'));
    } catch (e) {
      return const Left(UnexpectedFailure(message: 'Lỗi không xác định! [retrieveAuth]'));
    }
  }
}
