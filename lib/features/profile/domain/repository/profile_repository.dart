import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

abstract class ProfileRepository {
  //! location
  FRespData<List<ProvinceEntity>> getProvinces();
  FRespData<List<DistrictEntity>> getDistrictsByProvinceCode(String provinceCode);
  FRespData<List<WardEntity>> getWardsByDistrictCode(String districtCode);
  FRespData<String> getFullAddressByWardCode(String wardCode);

  //! address-controller
  FRespEither updateAddressStatus(int addressId);
  FRespData<List<AddressEntity>> getAllAddress();
  FRespData<AddressEntity> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);
  FRespData<AddressEntity> updateAddress(AddOrUpdateAddressParam addOrUpdateAddressParam);

  //# loyalty-point-controller
  FRespData<LoyaltyPointEntity> getLoyaltyPoint();
}
