import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

abstract class ProfileRepository {
  //! address-controller
  FRespEither updateAddressStatus(int addressId);
  FRespData<List<AddressEntity>> getAllAddress();
  FRespData<bool> hasAddress();
  FRespData<AddressEntity> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);
  FRespData<AddressEntity> updateAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);

  //# loyalty-point-controller
  FRespData<LoyaltyPointEntity> getLoyaltyPoint();

  //# loyalty-point-history-controller
  FRespData<List<LoyaltyPointHistoryEntity>> getLoyaltyPointHistory(int loyaltyPointId);
}
