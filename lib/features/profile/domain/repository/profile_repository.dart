import 'package:vtv_common/vtv_common.dart';

abstract class ProfileRepository {
  //! location
  FRespData<List<ProvinceEntity>> getProvinces();
  FRespData<List<DistrictEntity>> getDistrictsByProvinceCode(String provinceCode);
  FRespData<List<WardEntity>> getWardsByDistrictCode(String districtCode);
  FRespData<String> getFullAddressByWardCode(String wardCode);
  FRespEither updateAddressStatus(int addressId);

  //! address
  FRespData<List<AddressEntity>> getAllAddress();
  FRespData<AddressEntity> addAddress(AddAddressParam addAddressParam);
}
