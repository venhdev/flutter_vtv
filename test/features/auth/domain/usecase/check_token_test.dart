import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/check_token.dart';
import 'package:mockito/mockito.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late CheckTokenUC checkTokenUC;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    checkTokenUC = CheckTokenUC(mockAuthRepository);
  });

  test('should return new token when get refresh token success', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.isExpiredToken(any)).thenAnswer((_) async => const Right(true));
    when(mockAuthRepository.getNewAccessToken()).thenAnswer((_) async => const Right(SuccessResponse(data:'new_token')));
    // Act

    final result = await checkTokenUC('any');

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.isExpiredToken('any'));
    verify(mockAuthRepository.getNewAccessToken());
    // --expect something equals, isA, throwsA
    expect(result, const Right('new_token'));
  });
  test('should do nothing when get token is not expired (token still valid)', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.isExpiredToken(any)).thenAnswer((_) async => const Right(false));
    // Act

    final result = await checkTokenUC('any');

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.isExpiredToken('any'));
    verifyNever(mockAuthRepository.getNewAccessToken());
    // --expect something equals, isA, throwsA
    expect(result, const Right(null));
  });
  test('should return [Failure] when get token format is invalid', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.isExpiredToken(any)).thenAnswer((_) async => const Left(UnexpectedFailure()));
    // Act

    final result = await checkTokenUC('any');

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.isExpiredToken('any'));
    verifyNever(mockAuthRepository.getNewAccessToken());
    // --expect something equals, isA, throwsA
    expect(result, const Left(UnexpectedFailure()));
  });
}
