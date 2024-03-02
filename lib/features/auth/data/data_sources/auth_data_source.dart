import 'dart:convert';

import 'package:flutter_vtv/core/notification/firebase_cloud_messaging_manager.dart';
import 'package:flutter_vtv/features/auth/data/models/user_info_model.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/register_params.dart';
import '../models/auth_model.dart';

// <https://pub.dev/packages/jwt_decoder>

abstract class AuthDataSource {
  // ======================  Auth controller ======================
  Future<DataResponse<AuthModel>> loginWithUsernameAndPassword(String username, String password);
  Future<SuccessResponse> register(RegisterParams registerDTO);
  Future<SuccessResponse> logoutAndRevokeRefreshToken(String refreshToken); // use for logout
  Future<DataResponse<String>> getNewAccessToken(String refreshToken); // handing expired token
  // ======================  Auth controller ======================

  // ======================  Customer controller ======================
  // Get user's profile
  Future<DataResponse<AuthModel>> getUserProfile();
  // Edit user's profile
  Future<DataResponse<UserInfoModel>> editUserProfile({required UserInfoModel newInfo});

  /// Request send OTP to the user's email
  Future<SuccessResponse> requestOtpForResetPassword(String username);

  /// Request reset password with OTP code received from the user's email
  Future<SuccessResponse> resetPassword({
    required String username,
    required String otp,
    required String newPassword,
  });
  Future<SuccessResponse> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  });
  // ======================  Customer controller ======================
}

class AuthDataSourceImpl implements AuthDataSource {
  final http.Client _client;
  final FirebaseCloudMessagingManager _fcmManager;
  final SecureStorageHelper _secureStorageHelper;

  AuthDataSourceImpl(this._client, this._fcmManager, this._secureStorageHelper);

  @override
  Future<DataResponse<AuthModel>> loginWithUsernameAndPassword(String username, String password) async {
    final fcmToken = _fcmManager.currentFCMToken;

    final body = {
      'username': username,
      'password': password,
      'fcmToken': fcmToken,
    };

    // send request
    final response = await _client.post(
      baseUri(path: kAPIAuthLoginURL),
      headers: baseHttpHeaders(),
      body: jsonEncode(body),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = DataResponse<AuthModel>(
        AuthModel.fromJsonMap(decodedBody),
        code: response.statusCode,
        message: decodedBody['message'],
      );
      return result;
    } else {
      throwException(
        code: response.statusCode,
        message: jsonDecode(utf8BodyMap)['message'],
        url: kAPIAuthLoginURL,
      );
    }
  }

  @override
  Future<SuccessResponse> logoutAndRevokeRefreshToken(String refreshToken) async {
    // body contains fcmToken
    final body = {
      'fcmToken': _fcmManager.currentFCMToken,
    };
    // send request
    final response = await _client.post(
      baseUri(path: kAPIAuthLogoutURL),
      headers: baseHttpHeaders(refreshToken: refreshToken),
      body: jsonEncode(body),
    );
    return handleResponseNoData(response, kAPIAuthLogoutURL);
  }

  @override
  Future<DataResponse<String>> getNewAccessToken(String refreshToken) async {
    // send request
    final response = await _client.post(
      baseUri(path: kAPIAuthRefreshTokenURL),
      headers: baseHttpHeaders(refreshToken: refreshToken),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      return DataResponse(
        decodedBody['accessToken'],
        code: response.statusCode,
        message: decodedBody['message'],
      );
    } else {
      throwException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: kAPIAuthRegisterURL,
      );
    }
  }

  @override
  Future<SuccessResponse> register(RegisterParams registerParams) async {
    final body = registerParams.toJson();

    // send request
    final response = await _client.post(
      baseUri(path: kAPIAuthRegisterURL),
      headers: baseHttpHeaders(),
      body: body,
    );
    return handleResponseNoData(response, kAPIAuthRegisterURL);
  }

  @override
  Future<SuccessResponse> requestOtpForResetPassword(String username) async {
    final response = await _client.get(
      baseUri(
        path: kAPICustomerForgotPasswordURL,
        queryParameters: {'username': username},
      ),
      headers: baseHttpHeaders(),
    );

    return handleResponseNoData(response, kAPICustomerForgotPasswordURL);
  }

  @override
  Future<SuccessResponse> resetPassword({
    required String username,
    required String otp,
    required String newPassword,
  }) async {
    final body = {
      'username': username,
      'otp': otp,
      'newPassword': newPassword,
    };

    // send request
    final response = await _client.post(
      baseUri(path: kAPICustomerResetPasswordURL),
      headers: baseHttpHeaders(),
      body: jsonEncode(body),
    );

    return handleResponseNoData(response, kAPICustomerResetPasswordURL);
  }

  @override
  Future<SuccessResponse> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    final body = {
      'username': username,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };

    // send request
    final response = await _client.patch(
      baseUri(path: kAPICustomerChangePasswordURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: jsonEncode(body),
    );

    return handleResponseNoData(response, kAPICustomerChangePasswordURL);
  }

  @override
  Future<DataResponse<UserInfoModel>> editUserProfile({required UserInfoModel newInfo}) async {
    // send request
    final response = await _client.put(
      baseUri(path: kAPICustomerProfileURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
      body: newInfo.toJson(),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = DataResponse<UserInfoModel>(
        UserInfoModel.fromMap(decodedBody['customerDTO']),
        code: response.statusCode,
        message: decodedBody['message'],
      );
      return result;
    } else {
      throwException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: kAPIAuthLoginURL,
      );
    }

    // return handleResponseNoData(response, kAPICustomerProfileURL);
  }

  @override
  Future<DataResponse<AuthModel>> getUserProfile() async {
    // send request
    final response = await _client.get(
      baseUri(path: kAPICustomerProfileURL),
      headers: baseHttpHeaders(accessToken: await _secureStorageHelper.accessToken),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = DataResponse<AuthModel>(
        AuthModel.fromJsonMap(decodedBody),
        code: response.statusCode,
        message: decodedBody['message'],
      );
      return result;
    } else {
      throwException(
        code: response.statusCode,
        message: jsonDecode(utf8BodyMap)['message'],
        url: kAPICustomerProfileURL,
      );
    }
  }
}
