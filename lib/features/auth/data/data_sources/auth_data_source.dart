import 'dart:convert';

import 'package:flutter_vtv/core/constants/api.dart';
import 'package:flutter_vtv/core/error/exceptions.dart';
import 'package:http/http.dart' as http show Client;

import '../../domain/dto/register_params.dart';
import '../models/auth_model.dart';

// <https://pub.dev/packages/jwt_decoder>

abstract class AuthDataSource {
  Future<AuthModel> loginWithUsernameAndPassword(String username, String password);
  Future<void> register(RegisterParams registerDTO);
  Future<void> disableRefreshToken(String refreshToken); // use for logout
  Future<String> getAccessToken(String refreshToken); // handing expired token
}

class AuthDataSourceImpl implements AuthDataSource {
  final http.Client _client;

  AuthDataSourceImpl(this._client);

  @override
  Future<AuthModel> loginWithUsernameAndPassword(String username, String password) async {
    // prepare body
    final body = {
      'username': username,
      'password': password,
    };

    // send request
    final response = await _client.post(
      Uri.parse(kAPIAuthLoginURL),
      headers: baseHeaders,
      body: jsonEncode(body),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);

    // handle response
    if (response.statusCode == 200) {
      return AuthModel.fromJson(utf8BodyMap);
    } else {
      throwException(
        code: response.statusCode,
        message: jsonDecode(utf8BodyMap)['message'],
        url: kAPIAuthLoginURL,
      );
    }
  }

  @override
  Future<void> disableRefreshToken(String refreshToken) async {
    // prepare headers

    // send request
    final response = await _client.post(
      Uri.parse(kAPIAuthLogoutURL),
      headers: headersWithRefreshToken(refreshToken),
    );

    // handle response
    if (response.statusCode == 200) {
      return;
    } else {
      // decode response using utf8
      final utf8BodyMap = utf8.decode(response.bodyBytes);
      final decodedBody = jsonDecode(utf8BodyMap);
      throwException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: kAPIAuthRegisterURL,
      );
    }
  }

  @override
  Future<String> getAccessToken(String refreshToken) async {
    // send request
    final response = await _client.post(
      Uri.parse(kAPIAuthRefreshTokenURL),
      headers: headersWithRefreshToken(refreshToken),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      return decodedBody['accessToken'];
    } else {
      throwException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: kAPIAuthRegisterURL,
      );
    }
  }

  @override
  Future<void> register(RegisterParams registerParams) async {
    // prepare body
    final body = registerParams.toJson();

    // send request
    final response = await _client.post(
      Uri.parse(kAPIAuthRegisterURL),
      headers: baseHeaders,
      body: body,
    );

    // handle response
    if (response.statusCode == 200) {
      return;
    } else {
      // decode response using utf8
      final utf8BodyMap = utf8.decode(response.bodyBytes);
      final decodedBody = jsonDecode(utf8BodyMap);
      throwException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: kAPIAuthRegisterURL,
      );
    }
  }
}
