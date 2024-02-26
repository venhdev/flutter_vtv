import 'dart:convert';

import 'package:flutter_vtv/features/auth/data/models/user_info_model.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/dto/register_params.dart';
import '../models/auth_model.dart';

// <https://pub.dev/packages/jwt_decoder>

abstract class AuthDataSource {
  // ======================  Auth controller ======================
  Future<DataResponse<AuthModel>> loginWithUsernameAndPassword(String username, String password);
  Future<SuccessResponse> register(RegisterParams registerDTO);
  Future<SuccessResponse> revokeRefreshToken(String refreshToken); // use for logout
  Future<DataResponse<String>> getNewAccessToken(String refreshToken); // handing expired token
  // ======================  Auth controller ======================

  // ======================  Customer controller ======================
  // Get user's profile
  Future<DataResponse<AuthModel>> getUserProfile({required String accessToken});
  // Edit user's profile
  Future<SuccessResponse> editUserProfile({required String accessToken, required UserInfoModel newInfo});

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

  AuthDataSourceImpl(this._client);

  @override
  Future<DataResponse<AuthModel>> loginWithUsernameAndPassword(String username, String password) async {
    final body = {
      'username': username,
      'password': password,
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
  Future<SuccessResponse> revokeRefreshToken(String refreshToken) async {
    // send request
    final response = await _client.post(
      baseUri(path: kAPIAuthLogoutURL),
      headers: baseHttpHeaders(refreshToken: refreshToken),
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
    final response = await _client.post(
      baseUri(path: kAPICustomerChangePasswordURL),
      headers: baseHttpHeaders(),
      body: jsonEncode(body),
    );

    return handleResponseNoData(response, kAPICustomerChangePasswordURL);
  }

  @override
  Future<SuccessResponse> editUserProfile({required String accessToken, required UserInfoModel newInfo}) async {
    // send request
    final response = await _client.put(
      baseUri(path: kAPICustomerProfileURL),
      headers: baseHttpHeaders(accessToken: accessToken),
      body: newInfo.toJson(),
    );

    return handleResponseNoData(response, kAPICustomerProfileURL);
  }

  @override
  Future<DataResponse<AuthModel>> getUserProfile({required String accessToken}) async {
    // send request
    final response = await _client.get(
      baseUri(path: kAPICustomerProfileURL),
      headers: baseHttpHeaders(accessToken: accessToken),
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