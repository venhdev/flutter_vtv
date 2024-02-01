import 'dart:convert';

import 'package:flutter_vtv/core/constants/api.dart';
import 'package:flutter_vtv/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/auth_model.dart';

abstract class AuthDataSource {
  Future<AuthModel> loginWithUsernameAndPassword(String username, String password);
  Future<void> disableRefreshToken(String refreshToken);
}

class AuthDataSourceImpl implements AuthDataSource {
  final http.Client _client;

  AuthDataSourceImpl(this._client);

  @override
  Future<AuthModel> loginWithUsernameAndPassword(String username, String password) async {
    // prepare headers
    final headers = {
      'Content-Type': 'application/json',
    };
    // prepare body
    final body = {
      'username': username,
      'password': password,
    };

    // send request
    final response = await _client.post(
      Uri.parse(kAPIAuthLoginURL),
      headers: headers,
      body: jsonEncode(body),
    );
    // decode response using utf8
    final utf8Body = utf8.decode(response.bodyBytes);

    // handle response
    if (response.statusCode == 200) {
      final model = AuthModel.fromJson(utf8Body);

      return model;
    } else if (response.statusCode == 400) {
      throw ClientException(
        code: 400,
        message: jsonDecode(utf8Body)['message'],
        uri: Uri.parse(kAPIAuthLoginURL),
      );
    } else if (response.statusCode == 404) {
      throw ClientException(
        code: 404,
        message: jsonDecode(utf8Body)['message'],
        uri: Uri.parse(kAPIAuthLoginURL),
      );
    } else {
      throw ServerException(message: 'Lỗi không xác định. [loginWithUsernameAndPassword]');
    }
  }

  @override
  Future<void> disableRefreshToken(String refreshToken) async {
    // prepare headers
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Cookie': 'refreshToken=$refreshToken',
    };

    // send request
    final response = await _client.post(
      Uri.parse(kAPIAuthLogoutURL),
      headers: headers,
    );

    // decode response using utf8
    final utf8Body = utf8.decode(response.bodyBytes);

    // handle response
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 403 || response.statusCode == 400) {
      final message = jsonDecode(utf8Body)['message'];
      Logger().i('logout message: $message');
      throw ClientException(
        code: response.statusCode,
        message: jsonDecode(utf8Body)['message'],
        uri: Uri.parse(kAPIAuthLogoutURL),
      );
    }
  }
}
