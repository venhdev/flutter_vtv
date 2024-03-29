import '../../../../core/constants/typedef.dart';
import '../entities/voucher_entity.dart';

abstract class VoucherRepository {
  FRespData<List<VoucherEntity>> listAll();
  FRespData<List<VoucherEntity>> listOnSystem();
  FRespData<List<VoucherEntity>> listOnShop(String shopId);
}