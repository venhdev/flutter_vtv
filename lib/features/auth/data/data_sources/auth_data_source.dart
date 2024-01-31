import 'dart:convert';

import 'package:flutter_vtv/core/constants/api.dart';
import 'package:flutter_vtv/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/auth_model.dart';

abstract class AuthDataSource {
  Future<AuthModel> loginWithUsernameAndPassword(String username, String password);
  Future<void> logout();
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

    // handle response
    if (response.statusCode == 200) {
      final model = AuthModel.fromJson(response.body);
      // await _secureStorage.cacheAuth(model); // cache into secure storage

      return model;
    } else if (response.statusCode == 400) {
      throw ClientException(
        code: 400,
        message: 'Sai tên đăng nhập hoặc mật khẩu',
        uri: Uri.parse(kAPIAuthLoginURL),
      );
    } else if (response.statusCode == 404) {
      throw ClientException(
        code: 404,
        message: 'Tài khoản không tồn tại',
        uri: Uri.parse(kAPIAuthLoginURL),
      );
    } else {
      throw Exception('Lỗi không xác định. [login]');
    }
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
