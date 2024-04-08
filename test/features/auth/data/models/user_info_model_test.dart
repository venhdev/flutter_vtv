import 'package:flutter_test/flutter_test.dart';
import 'package:vtv_common/vtv_common.dart';
import '../../../../helpers/dummy_data/auth_test_data.dart';

void main() {
  test('[UserInfoModel] should be a subclass of auth entity', () async {
    //assert
    expect(tUserInfoEntity, isA<UserInfoEntity>());
  });
}
