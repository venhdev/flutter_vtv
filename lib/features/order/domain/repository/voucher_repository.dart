import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

abstract class VoucherRepository {
  FRespData<List<VoucherEntity>> listAll();
  FRespData<List<VoucherEntity>> listOnSystem();
  FRespData<List<VoucherEntity>> listOnShop(int shopId);

  //# customer-voucher-controller
  // const String kAPICustomerVoucherSaveURL = '/customer/voucher/save'; // POST /{voucherId}
  FRespData<VoucherEntity> customerVoucherSave(int voucherId);
  // const String kAPICustomerVoucherListURL = '/customer/voucher/list'; // GET
  FRespData<List<VoucherEntity>> customerVoucherList();
  // const String kAPICustomerVoucherDeleteURL = '/customer/voucher/delete'; // DELETE /{voucherId}
  FRespData<VoucherEntity> customerVoucherDelete(int voucherId);
}
