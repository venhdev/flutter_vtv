import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

void main() {
  test('description', () {
    const s =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ2MSIsImlhdCI6MTcwODU4NTI4MiwiZXhwIjoxNzA4NjQ1MjgyfQ.QNKAS4hHV45rM_0AK_pt5dP9juBq7gL71gxmBsGoWK0';

    final isValid = JwtDecoder.isExpired(s);

    if (isValid) {
      Logger().i('token isValid: $isValid');
    } else {
      Logger().i('token not isValid $isValid');
    }

    final rs = JwtDecoder.getExpirationDate(s);


    final now = DateTime.now();

    if (rs.isAfter(now)) {
      Logger().i('token is not expired');
    } else {
       Logger().i('token is expired');
    }

    // expect(isValid, true);
  });
}
