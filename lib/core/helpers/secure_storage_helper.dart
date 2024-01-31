import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/auth_model.dart';
import '../../features/auth/domain/entities/auth_entity.dart';
import '../error/exceptions.dart';

class SecureStorageHelper {
  SecureStorageHelper(this._storage);
  final FlutterSecureStorage _storage;

  FlutterSecureStorage get I => _storage;

  final _key = 'authentication';

  Future<bool> get isLogin => _storage.containsKey(key: _key);

  Future<AuthEntity> readAuth() async {
    final data = await _storage.read(key: _key);
    if (data?.isNotEmpty ?? false) {
      return AuthModel.fromJson(data!).toEntity();
    } else {
      throw CacheException(message: 'Không có dữ liệu người dùng được lưu!');
    }
  }

  Future<void> cacheAuth(String jsonData) async {
    await _storage.write(key: _key, value: jsonData);
  }

  Future<void> deleteAll() async => await _storage.deleteAll();
}
