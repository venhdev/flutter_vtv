import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/helpers/secure_storage_helper.dart';
import 'package:flutter_vtv/features/auth/domain/entities/auth_entity.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/dto/register_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_data_source.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authDataSource, this._secureStorageHelper);

  final AuthDataSource _authDataSource;
  final SecureStorageHelper _secureStorageHelper;

  @override
  FResult<AuthEntity> loginWithUsernameAndPassword(String username, String password) async {
    try {
      final model = await _authDataSource.loginWithUsernameAndPassword(username, password);
      return Right(model.toEntity());
    } on SocketException {
      return const Left(ServerFailure(message: kMsgNetworkError));
    } on ClientException catch (e) {
      return Left(ClientFailure(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
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
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FResult<AuthEntity> retrieveAuth() async {
    try {
      final authData = await _secureStorageHelper.readAuth();
      return Right(authData);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FResultVoid logout(String refreshToken) async {
    try {
      return Right(await _authDataSource.disableRefreshToken(refreshToken));
    } on SocketException {
      return const Left(ServerFailure(message: kMsgNetworkError));
    } on ClientException catch (e) {
      return Left(ClientFailure(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FResultVoid deleteAuth() async {
    try {
      return Right(await _secureStorageHelper.deleteAuth());
    } on CacheException {
      return const Left(CacheFailure(message: 'Lỗi xóa thông tin người dùng!'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FResult<String> getNewAccessToken() async {
    try {
      final auth = await _secureStorageHelper.readAuth();
      final newAccessToken = await _authDataSource.getNewAccessToken(auth.refreshToken);
      return Right(newAccessToken);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on SocketException {
      return const Left(ServerFailure(message: kMsgNetworkError));
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  /// Returns true if the token is valid, false if it is expired.
  /// When some error occurs, it returns a [Failure].
  @override
  FResult<bool> isValidToken(String accessToken) async {
    try {
      return Right(JwtDecoder.isExpired(accessToken));
    } on FormatException catch (e) {
      return Left(UnexpectedFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FResult<void> register(RegisterParams registerParams) async {
    try {
      await _authDataSource.register(registerParams);
      return const Right(null);
    } on SocketException {
      return const Left(ServerFailure(message: kMsgNetworkError));
    } on ClientException catch (e) {
      return Left(ClientFailure(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
