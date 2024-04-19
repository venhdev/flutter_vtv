import 'package:vtv_common/vtv_common.dart';

abstract class VoucherRepository {
  FRespData<List<VoucherEntity>> listAll();
  FRespData<List<VoucherEntity>> listOnSystem();
  FRespData<List<VoucherEntity>> listOnShop(String shopId);
}
