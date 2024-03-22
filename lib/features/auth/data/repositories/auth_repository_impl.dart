import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/features/auth/domain/entities/user_info_entity.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/typedef.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../domain/dto/register_params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_data_source.dart';
import '../models/auth_model.dart';
import '../models/user_info_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authDataSource, this._secureStorageHelper);

  final AuthDataSource _authDataSource;
  final SecureStorageHelper _secureStorageHelper;

  @override
  FRespData<AuthEntity> loginWithUsernameAndPassword(
      String username, String password) async {
    try {
      final result = await _authDataSource.loginWithUsernameAndPassword(
          username, password);
      return Right(DataResponse(result.data.toEntity()));
    } on SocketException {
      return const Left(ClientError(message: kMsgNetworkError));
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FResult<void> cacheAuth(AuthEntity authEntity) async {
    try {
      final jsonAuthData = AuthModel.fromEntity(authEntity).toJson();
      await _secureStorageHelper.cacheAuth(jsonAuthData);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
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
  FRespEither logout(String refreshToken) async {
    try {
      final resOK =
          await _authDataSource.logoutAndRevokeRefreshToken(refreshToken);
      return Right(resOK);
    } on SocketException {
      return const Left(ClientError(message: kMsgNetworkError));
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FResult<void> deleteAuth() async {
    try {
      await _secureStorageHelper.deleteAuth();
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure(message: 'Lỗi xóa thông tin người dùng!'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FRespData<String> getNewAccessToken() async {
    try {
      final localAuth = await _secureStorageHelper.readAuth();
      final newAccessToken =
          await _authDataSource.getNewAccessToken(localAuth.refreshToken);
      return Right(newAccessToken);
    } on CacheException catch (e) {
      return Left(UnexpectedError(message: e.message));
    } on SocketException {
      return const Left(ClientError(message: kMsgNetworkError));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  /// Tells whether a token is expired.
  ///
  /// Returns false if the token is valid, true if it is expired.
  //!!! The package function {isExpired} returns true if the token is expired, false if it is valid. So, the return value is reversed.
  ///
  /// When some error occurs, it returns a [Failure].
  @override
  FResult<bool> isExpiredToken(String accessToken) async {
    try {
      return Right(JwtDecoder.isExpired(accessToken));
    } on FormatException catch (e) {
      return Left(UnexpectedFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FRespEither register(RegisterParams registerParams) async {
    try {
      final resOK = await _authDataSource.register(registerParams);
      return Right(resOK);
    } on SocketException {
      return const Left(ClientError(message: kMsgNetworkError));
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FRespEither changePassword(String oldPassword, String newPassword) async {
    try {
      final username = await _secureStorageHelper.username;
      final resOK = await _authDataSource.changePassword(
        username: username!, //? have checked in the 'Setting Page'
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return Right(resOK);
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FRespData<UserInfoEntity> editUserProfile(UserInfoEntity newInfo) async {
    try {
      final resOK = await _authDataSource.editUserProfile(
        newInfo: UserInfoModel.fromEntity(newInfo),
      );
      // update user info in local storage
      await _secureStorageHelper.updateUserInfo(resOK.data);
      return Right(resOK);
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FRespEither sendOTPForResetPassword(String username) async {
    try {
      final resOK =
          await _authDataSource.sendOTPForResetPasswordViaUsername(username);
      return Right(resOK);
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }

  @override
  FRespEither resetPasswordViaOTP(
      String username, String otpCode, String newPassword) async {
    try {
      final resOK = await _authDataSource.resetPassword(
        username: username,
        otp: otpCode,
        newPassword: newPassword,
      );
      return Right(resOK);
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }
}
