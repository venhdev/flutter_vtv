import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vtv_common/vtv_common.dart';
import '../../../../helpers/dummy_data/auth_test_data.dart';

void main() {
  test('[AuthModel] should be a subclass of auth entity', () async {
    //assert
    expect(tAuthModel, isA<AuthEntity>());
  });

  test('should return a valid model from json', () async {
    //arrange
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
    //act
    final result = AuthModel.fromJson(json.encode(tResLoginSuccess));

    //assert
    expect(result, equals(tAuthModel));
  });

  // test(
  //   'should return a json map containing proper data',
  //   () async {
  //     // act
  //     final result = testAuthModel.toJson();

  //     // assert
  //     final expectedJsonMap = {
  //       'weather': [
  //         {
  //           'main': 'Clear',
  //           'description': 'clear sky',
  //           'icon': '01n',
  //         }
  //       ],
  //       'main': {
  //         'temp': 292.87,
  //         'pressure': 1012,
  //         'humidity': 70,
  //       },
  //       'name': 'New York',
  //     };

  //     expect(result, equals(expectedJsonMap));
  //   },
  // );
}
