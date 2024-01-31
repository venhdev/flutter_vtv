import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/core/constants/api.dart';
import 'package:flutter_vtv/core/error/exceptions.dart';
import 'package:flutter_vtv/features/auth/data/data_sources/auth_data_source.dart';
import 'package:flutter_vtv/features/auth/data/models/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../helpers/dummy_data/auth_test_data.dart';
import '../../../../helpers/dummy_data/test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late AuthDataSourceImpl authDataSourceImpl;
  late MockSecureStorageHelper mockSecureStorageHelper;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSecureStorageHelper = MockSecureStorageHelper();
    authDataSourceImpl = AuthDataSourceImpl(mockHttpClient);
  });

  group('login with username and password', () {
    test('should throw [ClientException] when status code is 404', () async {
      // Arrange (setup @mocks)
      when(
        mockHttpClient.post(
          Uri.parse(kAPIAuthLoginURL),
          body: jsonEncode({
            'username': tUsername,
            'password': tPassword,
          }),
          headers: testHeaders,
        ),
      ).thenAnswer((_) async => http.Response(
            json.encode(dummyLoginFailPassRes),
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
          Uri.parse(kAPIAuthLoginURL),
          body: jsonEncode({
            'username': tUsername,
            'password': tPassword,
          }),
          headers: testHeaders,
        ),
      ).thenAnswer((_) async => http.Response(
            json.encode(dummyLoginFailPassRes),
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
          Uri.parse(kAPIAuthLoginURL),
          body: jsonEncode({
            'username': tUsername,
            'password': tPassword,
          }),
          headers: testHeaders,
        ),
      ).thenAnswer((_) async => http.Response(
            json.encode(dummyLoginSuccessRes),
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
      expect(result, isA<AuthModel>());
    });
  });
}
