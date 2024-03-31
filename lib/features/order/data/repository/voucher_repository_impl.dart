
import '../../../../core/constants/typedef.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/repository/voucher_repository.dart';
import '../../domain/entities/voucher_entity.dart';
import '../data_sources/voucher_data_source.dart';

class VoucherRepositoryImpl extends VoucherRepository {
  VoucherRepositoryImpl(this._voucherDataSource);

  final VoucherDataSource _voucherDataSource;

  @override
  FRespData<List<VoucherEntity>> listAll() async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.listAll());
  }

  @override
  FRespData<List<VoucherEntity>> listOnShop(String shopId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.listOnShop(shopId));
  }

  @override
  FRespData<List<VoucherEntity>> listOnSystem() async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.listOnSystem());
  }
}
