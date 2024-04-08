import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../helpers/dummy_data/auth_test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  // late MockConnectivity mockConnectivity;
  late MockSecureStorageHelper mockSecureStorageHelper;
  late MockAuthDataSource mockAuthDataSource;

  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    // mockConnectivity = MockConnectivity();
    mockSecureStorageHelper = MockSecureStorageHelper();
    mockAuthDataSource = MockAuthDataSource();

    authRepositoryImpl = AuthRepositoryImpl(
      mockAuthDataSource,
      mockSecureStorageHelper,
    );
  });

  group('login', () {
    test('should return [AuthEntity] when login success', () async {
      // Arrange (setup @mocks)
      when(mockAuthDataSource.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      )).thenAnswer((_) async => DataResponse(tAuthModel));

      // when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);

      // Act
      final result = await authRepositoryImpl.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      );

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(result, equals(Right(DataResponse(tAuthEntity))));
    });
    test('should return [void] when cache success', () async {
      // Arrange (setup @mocks)
      when(mockSecureStorageHelper.cacheAuth(any)).thenAnswer((_) async {});

      // Act
      final result = await authRepositoryImpl.cacheAuth(tAuthEntity);

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(result, equals(const Right(null)));
    });
  });

  group('retrieve auth', () {
    test('should return [AuthEntity] when retrieving data successfully', () async {
      // Arrange (setup @mocks)
      when(mockSecureStorageHelper.readAuth()).thenAnswer((_) async => tAuthEntity);

      // Act
      final result = await authRepositoryImpl.retrieveAuth();

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(result, equals(Right(tAuthEntity)));
    });
    test('should return [UnexpectedFailure] when retrieving data unsuccessfully', () async {
      // Arrange (setup @mocks)
      when(mockSecureStorageHelper.readAuth())
          .thenThrow(CacheException(message: 'Không có dữ liệu người dùng được lưu!'));

      // Act
      final result = await authRepositoryImpl.retrieveAuth();

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(result, equals(const Left(CacheFailure(message: 'Không có dữ liệu người dùng được lưu!'))));
    });
  });

  group('logout', () {
    test('should return [void] when logout successfully', () async {
      // Arrange (setup @mocks)
      when(mockAuthDataSource.logoutAndRevokeRefreshToken(tRefreshToken)).thenAnswer((_) async => tSuccessResponse);

      // Act
      final result = await authRepositoryImpl.logout(tRefreshToken);

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(result, equals(const Right(tSuccessResponse)));
    });
  });

  group('register', () {
    final tRegisterParams = RegisterParams(
      username: 'username',
      password: 'password',
      email: 'email',
      gender: true,
      fullName: 'fullName',
      birthday: DateTime(2000, 1, 1),
    );
    // register success
    test('should return [SuccessResponse] when {register} success', () async {
      // Arrange (setup @mocks)
      when(mockAuthDataSource.register(tRegisterParams)).thenAnswer((_) async => tSuccessResponse);

      // Act
      final result = await authRepositoryImpl.register(tRegisterParams);

      // Assert
      // --verify something should(not) happen/call
      verify(mockAuthDataSource.register(tRegisterParams));
      // --expect something equals, isA, throwsA
      // expect(future, completes);
      expect(result, equals(const Right(tSuccessResponse)));
    });

    // register failure
    test('should return [Failure] when register fail', () async {
      // Arrange (setup @mocks)
      when(mockAuthDataSource.register(any)).thenThrow(
        ServerException(code: 500, message: 'Đăng ký thất bại!'),
      );
      // Act
      final result = await authRepositoryImpl.register(tRegisterParams);

      // Assert
      // --verify something should(not) happen/call
      verify(mockAuthDataSource.register(tRegisterParams));
      // --expect something equals, isA, throwsA
      expect(result, equals(const Left(ServerError(code: 500, message: 'Đăng ký thất bại!'))));
    });
  });
}
