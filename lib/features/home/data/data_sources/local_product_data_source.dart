import 'package:vtv_common/vtv_common.dart';

String _keyRecentProduct = 'RECENT_PRODUCT';
int _maxRecentProduct = 10;

abstract class LocalProductDataSource {
  Future<void> cacheProductId(int productId);
  Future<List<String>> getRecentProductIds();
  Future<void> removeAllRecentProduct();
}

class LocalProductDataSourceImpl extends LocalProductDataSource {
  LocalProductDataSourceImpl(this._pref);

  final SharedPreferencesHelper _pref;

  @override
  Future<void> cacheProductId(int productId) async {
    final id = productId.toString();
    List<String> recentProductIds = await getRecentProductIds();
    if (recentProductIds.contains(id)) {
      recentProductIds.remove(id);
    }
    recentProductIds.insert(0, id);
    if (recentProductIds.length > _maxRecentProduct) {
      recentProductIds.removeLast();
    }
    await _pref.I.setStringList(_keyRecentProduct, recentProductIds);
  }

  @override
  Future<List<String>> getRecentProductIds() async {
    List<String> recentProductIds = _pref.I.getStringList(_keyRecentProduct) ?? [];
    return recentProductIds;
  }

  @override
  Future<void> removeAllRecentProduct() async {
    await _pref.I.remove(_keyRecentProduct);
  }
}
