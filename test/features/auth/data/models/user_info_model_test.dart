import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/features/auth/domain/entities/user_info_entity.dart';

import '../../../../helpers/dummy_data/auth_test_data.dart';

void main() {
  test('[UserInfoModel] should be a subclass of auth entity', () async {
    //assert
    expect(tUserInfoEntity, isA<UserInfoEntity>());
  });
}
