import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/features/auth/data/data_sources/auth_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../helpers/dummy_data/auth_test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late MockFirebaseCloudMessagingManager mockFCMManager;
  late MockSecureStorageHelper mockSecureStorageHelper;
  late AuthDataSourceImpl authDataSourceImpl;

  setUp(() {
    mockFCMManager = MockFirebaseCloudMessagingManager();
    mockHttpClient = MockHttpClient();
    mockSecureStorageHelper = MockSecureStorageHelper();
    authDataSourceImpl = AuthDataSourceImpl(mockHttpClient, mockFCMManager, mockSecureStorageHelper);
  });

  group('login with username and password', () {
    const tResLoginFail = {
      "code": 400,
      "status": "BAD_REQUEST",
      "message": "message",
    };
    const tResLoginSuccess = {
      "status": "string",
      "message": "string",
      "code": 0,
      "customerDTO": {
        "customerId": 0,
        "username": "username",
        "email": "email",
        "gender": true,
        "fullName": "fullName",
        "birthday": "2000-01-01",
        "status": "ACTIVE",
        "roles": ["CUSTOMER"]
      },
      "access_token": "accessToken",
      "refresh_token": "refreshToken"
    };

    when(mockFCMManager.currentFCMToken).thenReturn('fcmTokenSample');

    test('should throw [ClientException] when status code is 404', () async {
      // Arrange (setup @mocks)

      when(
        mockHttpClient.post(
          // Uri.parse(kAPIAuthLoginURL),
          baseUri(path: kAPIAuthLoginURL),
          body: jsonEncode({
            'username': tUsername,
            'password': tPassword,
          }),
          headers: baseHttpHeaders(),
        ),
      ).thenAnswer((_) async => http.Response(
            json.encode(tResLoginFail),
            404,
          ));
      // Act
      final future = authDataSourceImpl.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      );

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(future, throwsA(isA<ClientException>()));
    });
    test('should throw [ClientException] when status code is 400', () async {
      // Arrange (setup @mocks)
      when(
        mockHttpClient.post(
          // Uri.parse(kAPIAuthLoginURL),
          baseUri(path: kAPIAuthLoginURL),
          body: jsonEncode({
            'username': tUsername,
            'password': tPassword,
          }),
          headers: baseHttpHeaders(),
        ),
      ).thenAnswer((_) async => http.Response(
            json.encode(tResLoginFail),
            400,
          ));
      // Act
      final future = authDataSourceImpl.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      );

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(future, throwsA(isA<ClientException>()));
    });
    test('should return [AuthModel] when status code is 200', () async {
      // Arrange (setup @mocks)

      when(mockSecureStorageHelper.cacheAuth(any)).thenAnswer((_) async => {});
      when(
        mockHttpClient.post(
          // Uri.parse(kAPIAuthLoginURL),
          baseUri(path: kAPIAuthLoginURL),
          body: jsonEncode({
            'username': tUsername,
            'password': tPassword,
          }),
          headers: baseHttpHeaders(),
        ),
      ).thenAnswer((_) async => http.Response(
            json.encode(tResLoginSuccess),
            200,
          ));
      // Act
      final result = await authDataSourceImpl.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      );

      // Assert
      // --verify something should(not) happen/call
      // verify(mockSecureStorageHelper.cacheAuth(result)); // should call secure storage
      // --expect something equals, isA, throwsA
      expect(result, isA<DataResponse>());
    });
  });

  test('should completes when logout is successful', () async {
    const tRes = {
      "status": "Success",
      "message": "message",
      "code": 200,
    };
    when(mockFCMManager.currentFCMToken).thenReturn('fcmTokenSample');
    when(mockHttpClient.post(
      // Uri.parse(kAPIAuthLogoutURL),
      baseUri(path: kAPIAuthLogoutURL),
      headers: anyNamed("headers"),
      body: anyNamed("body"),
    )).thenAnswer((_) async => http.Response(jsonEncode(tRes), 200));
    // Act
    final future = authDataSourceImpl.logoutAndRevokeRefreshToken(tRefreshToken);

    // Assert
    // --verify something should(not) happen/call
    // --expect something equals, isA, throwsA
    expect(future, completes);
  });

  test('should return new respOK with data [String] when call {getAccessToken}', () async {
    // Arrange (setup @mocks)
    var tRes = {
      "accessToken": "string",
      "status": "string",
      "message": "string",
      "code": 200,
    };

    when(mockHttpClient.post(
      // Uri.parse(kAPIAuthRefreshTokenURL),
      baseUri(path: kAPIAuthRefreshTokenURL),
      headers: baseHttpHeaders(refreshToken: tRefreshToken),
    )).thenAnswer((_) async => http.Response(jsonEncode(tRes), 200));

    // Act
    final result = await authDataSourceImpl.getNewAccessToken(tRefreshToken);

    // Assert
    // --verify something should(not) happen/call
    // --expect something equals, isA, throwsA
    expect(result, isA<SuccessResponse>());
    // has data
    expect(result.data, isA<String>());
  });

  group('register', () {
    const tRegisterFailRes = {
      "status": "BAD_REQUEST",
      "message": "fail",
      "code": 400,
    };
    const tRegisterFailRes2 = {
      "status": "CONFLICT",
      "message": "fail",
      "code": 409,
    };
    const tRegisterSuccess = {
      "username": "v1",
      "email": "v1@gmail.com",
      "status": "success",
      "message": "ok",
    };

    final tRegisterParams = RegisterParams(
      username: 'username',
      password: 'password',
      email: 'email',
      gender: true,
      fullName: 'fullName',
      birthday: DateTime(2000, 1, 1),
    );

    // register success
    test('should completes when register success', () async {
      // Arrange (setup @mocks)
      when(mockHttpClient.post(
        // Uri.parse(kAPIAuthRegisterURL),
        baseUri(path: kAPIAuthRegisterURL),
        headers: baseHttpHeaders(),
        body: tRegisterParams.toJson(),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(tRegisterSuccess),
            200,
          ));
      // Act
      final future = authDataSourceImpl.register(tRegisterParams);

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(future, completes);
    });

    // register fail
    test('should throw [ClientException] when status code is 400', () async {
      // Arrange (setup @mocks)
      when(mockHttpClient.post(
        // Uri.parse(kAPIAuthRegisterURL),
        baseUri(path: kAPIAuthRegisterURL),
        headers: baseHttpHeaders(),
        body: tRegisterParams.toJson(),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(tRegisterFailRes),
            400,
          ));
      // Act
      final future = authDataSourceImpl.register(tRegisterParams);

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(future, throwsA(isA<ClientException>()));
    });
    test('should throw [ClientException] when status code is 409', () async {
      // Arrange (setup @mocks)
      when(mockHttpClient.post(
        // Uri.parse(kAPIAuthRegisterURL),
        baseUri(path: kAPIAuthRegisterURL),
        headers: baseHttpHeaders(),
        body: tRegisterParams.toJson(),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(tRegisterFailRes2),
            400,
          ));
      // Act
      final future = authDataSourceImpl.register(tRegisterParams);

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(future, throwsA(isA<ClientException>()));
    });
  });
}
