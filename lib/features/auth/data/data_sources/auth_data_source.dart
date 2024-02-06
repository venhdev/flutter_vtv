import 'dart:convert';

import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/base_response.dart';
import '../../domain/dto/register_params.dart';
import '../models/auth_model.dart';

// <https://pub.dev/packages/jwt_decoder>

abstract class AuthDataSource {
  Future<DataResponse<AuthModel>> loginWithUsernameAndPassword(String username, String password);
  Future<SuccessResponse> register(RegisterParams registerDTO);
  Future<SuccessResponse> disableRefreshToken(String refreshToken); // use for logout
  Future<DataResponse<String>> getNewAccessToken(String refreshToken); // handing expired token
}

class AuthDataSourceImpl implements AuthDataSource {
  final http.Client _client;

  AuthDataSourceImpl(this._client);

  @override
  Future<DataResponse<AuthModel>> loginWithUsernameAndPassword(String username, String password) async {
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
  Future<SuccessResponse> disableRefreshToken(String refreshToken) async {
    // prepare headers

    // send request
    final response = await _client.post(
      Uri.parse(kAPIAuthLogoutURL),
      headers: headersWithRefreshToken(refreshToken),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      return SuccessResponse(
        code: response.statusCode,
        message: decodedBody['message'],
      );
    } else {
      throwException(
        code: response.statusCode,
        message: decodedBody['message'],
        url: kAPIAuthLogoutURL,
      );
    }
  }

  @override
  Future<DataResponse<String>> getNewAccessToken(String refreshToken) async {
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
      // return decodedBody['accessToken'];
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
    // prepare body
    final body = registerParams.toJson();

    // send request
    final response = await _client.post(
      Uri.parse(kAPIAuthRegisterURL),
      headers: baseHeaders,
      body: body,
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      return SuccessResponse(
        code: response.statusCode,
        message: decodedBody['message'],
      );
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
