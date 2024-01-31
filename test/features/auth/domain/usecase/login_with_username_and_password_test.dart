import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/login_with_username_and_password.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/dummy_data/auth_test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoginWithUsernameAndPasswordUC loginWithUsernameAndPasswordUC;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginWithUsernameAndPasswordUC = LoginWithUsernameAndPasswordUC(mockAuthRepository);
  });

  test('should return [AuthEntity] when login successful', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.loginWithUsernameAndPassword(
      tUsername,
      tPassword,
    )).thenAnswer(
      (_) async => Right(tAuthEntity),
    );
    when(mockAuthRepository.cacheAuth(tAuthEntity)).thenAnswer(
      (_) async => const Right(null),
    );

    // Act

    final result = await loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(username: tUsername, password: tPassword),
    );

    // Assert
    // --expect something equals, isA, throwsA
    expect(result, Right(tAuthEntity));
  });
  test('should return [Failure] when login fail', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.loginWithUsernameAndPassword(
      any,
      any,
    )).thenAnswer(
      (_) async => const Left(testServerFailure),
    );
    // Act

    final result = await loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(username: 'testUsername', password: 'testPassword'),
    );

    // Assert
    // --expect something equals, isA, throwsA
    expect(result, const Left(testServerFailure));
  });
}
