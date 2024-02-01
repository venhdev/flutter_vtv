import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/core/error/exceptions.dart';
import 'package:flutter_vtv/core/error/failures.dart';
import 'package:flutter_vtv/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/dummy_data/auth_test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockConnectivity mockConnectivity;
  late MockSecureStorageHelper mockSecureStorageHelper;
  late MockAuthDataSource mockAuthDataSource;

  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockSecureStorageHelper = MockSecureStorageHelper();
    mockAuthDataSource = MockAuthDataSource();

    authRepositoryImpl = AuthRepositoryImpl(
      mockAuthDataSource,
      mockConnectivity,
      mockSecureStorageHelper,
    );
  });

  group('login', () {
    test('should return [AuthEntity] when login success', () async {
      // Arrange (setup @mocks)
      when(mockAuthDataSource.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      )).thenAnswer((_) async => tAuthModel);

      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);

      // Act
      final result = await authRepositoryImpl.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      );

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(result, equals(Right(tAuthEntity)));
    });
    test('should return [ConnectionFailure] when ConnectivityResult is none', () async {
      // Arrange (setup @mocks)
      when(mockAuthDataSource.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      )).thenAnswer((_) async => tAuthModel);

      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);

      // Act
      final result = await authRepositoryImpl.loginWithUsernameAndPassword(
        tUsername,
        tPassword,
      );

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(result, equals(const Left(ConnectionFailure(message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.'))));
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
      when(mockSecureStorageHelper.readAuth()).thenThrow(CacheException());

      // Act
      final result = await authRepositoryImpl.retrieveAuth();

      // Assert
      // --verify something should(not) happen/call
      // --expect something equals, isA, throwsA
      expect(result, equals(const Left(CacheFailure(message: 'Lỗi lấy thông tin người dùng!'))));
    });
  });

  test('should return [void] when logout successfully', () async {
    // Arrange (setup @mocks)
    when(mockAuthDataSource.disableRefreshToken(tRefreshToken)).thenAnswer((_) async {});

    // Act
    final result = await authRepositoryImpl.logout(tRefreshToken);

    // Assert
    // --verify something should(not) happen/call
    // --expect something equals, isA, throwsA
    expect(result, equals(const Right(null)));
  });
}
