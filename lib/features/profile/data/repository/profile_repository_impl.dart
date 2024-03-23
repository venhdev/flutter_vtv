import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/network/response_handler.dart';
import 'package:flutter_vtv/features/profile/domain/dto/add_address_param.dart';
import 'package:flutter_vtv/features/profile/domain/entities/address_dto.dart';
import 'package:flutter_vtv/features/profile/domain/entities/district_entity.dart';
import 'package:flutter_vtv/features/profile/domain/entities/province_entity.dart';
import 'package:flutter_vtv/features/profile/domain/entities/ward_entity.dart';
import 'package:flutter_vtv/features/profile/domain/repository/profile_repository.dart';

import '../data_sources/profile_data_source.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(this._profileDataSource);
  final ProfileDataSource _profileDataSource;

  @override
  FRespEither addAddress(AddAddressParam addAddressParam) async {
    return await handleSuccessResponseFromDataSource(
      noDataCallback: () async => await _profileDataSource.addAddress(addAddressParam),
    );
  }

  @override
  FRespData<List<AddressEntity>> getAllAddress() async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.getAllAddress(),
    );
  }

  @override
  FRespData<List<DistrictEntity>> getDistrictsByProvinceCode(String provinceCode) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.getDistrictsByProvinceCode(provinceCode),
    );
  }

  @override
  FRespData<String> getFullAddressByWardCode(String wardCode) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.getFullAddressByWardCode(wardCode),
    );
  }

  @override
  FRespData<List<ProvinceEntity>> getProvinces() async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.getProvinces(),
    );
  }

  @override
  FRespData<List<WardEntity>> getWardsByDistrictCode(String districtCode) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.getWardsByDistrictCode(districtCode),
    );
  }

  @override
  FRespEither updateAddressStatus(int addressId) async {
    return await handleSuccessResponseFromDataSource(
      noDataCallback: () async => await _profileDataSource.updateAddressStatus(addressId),
    );
  }
}
