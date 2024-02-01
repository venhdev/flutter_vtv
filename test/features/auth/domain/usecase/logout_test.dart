import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/core/error/failures.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/logout.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/dummy_data/auth_test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LogoutUC logoutUC;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logoutUC = LogoutUC(mockAuthRepository);
  });

  test('should return [void] when logout is successful', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.logout(tRefreshToken)).thenAnswer((_) async => const Right(null));
    when(mockAuthRepository.deleteAuth()).thenAnswer((_) async => const Right(null));
    // Act
    final result = await logoutUC(tRefreshToken);

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.logout(tRefreshToken));
    verify(mockAuthRepository.deleteAuth());
    // --expect something equals, isA, throwsA
    expect(result, const Right(null));
  });
  test('should return [ClientFailure] when logout is unsuccessful --Res code !=200', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.logout(tRefreshToken)).thenAnswer((_) async => const Left(ClientFailure()));
    when(mockAuthRepository.deleteAuth()).thenAnswer((_) async => const Right(null));
    // Act
    final result = await logoutUC(tRefreshToken);

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.logout(tRefreshToken));
    verifyNever(mockAuthRepository.deleteAuth());
    // --expect something equals, isA, throwsA
    expect(result, const Left(ClientFailure()));
  });
}
