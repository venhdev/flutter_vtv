import 'dart:async';

import 'package:vtv_common/vtv_common.dart';

import '../../features/home/domain/repository/product_repository.dart';
import '../../service_locator.dart';

class CustomerHandler {
  static Future<int?> handleFollowShop(int shopId) async {
    final rsEither = await sl<ProductRepository>().followedShopAdd(shopId);

    return rsEither.fold(
      (error) => null,
      (ok) => ok.data?.followedShopId,
    );
  }

  static Future<int?> handleUnFollowShop(int followedShopId) async {
    final rsEither = await sl<ProductRepository>().followedShopDelete(followedShopId);

    return rsEither.fold(
      (error) => followedShopId, // if delete failed, return the same id
      (ok) => null,
    );
  }

  static FutureOr<bool> sendCodeForResetPassword(String username) async {
    return sl<AuthRepository>().sendOTPForResetPassword(username).then((resultEither) {
      return resultEither.fold(
        (error) => false,
        (ok) => true,
      );
    });
  }

  static FutureOr<bool> resetPassword(String username, String otp, String newPass) async {
    return sl<AuthRepository>().resetPasswordViaOTP(username, otp, newPass).then((resultEither) {
      return resultEither.fold(
        (error) => false,
        (ok) => true,
      );
    });
  }

  static FutureOr<bool> registerCustomer(RegisterParams params) async {
    return sl<AuthRepository>().register(params).then((resultEither) {
      return resultEither.fold(
        (error) => false,
        (ok) => true,
      );
    });
  }

  static FutureOr<bool> changePassword(String oldPass, String newPass) async {
    return sl<AuthRepository>().changePassword(oldPass, newPass).then((resultEither) {
      return resultEither.fold(
        (error) => false,
        (ok) => true,
      );
    });
  }
}
