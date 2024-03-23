import '../../../../core/constants/typedef.dart';
import '../dto/add_address_param.dart';
import '../entities/address_dto.dart';
import '../entities/district_entity.dart';
import '../entities/province_entity.dart';
import '../entities/ward_entity.dart';

abstract class ProfileRepository {
  //! location
  FRespData<List<ProvinceEntity>> getProvinces();
  FRespData<List<DistrictEntity>> getDistrictsByProvinceCode(String provinceCode);
  FRespData<List<WardEntity>> getWardsByDistrictCode(String districtCode);
  FRespData<String> getFullAddressByWardCode(String wardCode);
  FRespEither updateAddressStatus(int addressId);

  //! address
  FRespData<List<AddressEntity>> getAllAddress();
  FRespEither addAddress(AddAddressParam addAddressParam);
}
