import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/auth_model.dart';
import '../../features/auth/domain/entities/auth_entity.dart';
import '../error/exceptions.dart';

class SecureStorageHelper {
  SecureStorageHelper(this._storage);
  final FlutterSecureStorage _storage;

  FlutterSecureStorage get I => _storage;

  final _keyAuth = 'authentication';

  Future<bool> get isLogin => _storage.containsKey(key: _keyAuth);

  /// get access token from local storage.
  /// - return null if not found (not login yet)
  Future<String?> get accessToken async {
    try {
      final auth = await readAuth();
      return auth.accessToken;
    } catch (e) {
      return null;
    }
  }

  /// get username from local storage.
  /// - return null if not found
  Future<String?> get username async {
    final auth = await readAuth();
    return auth.userInfo.username;
  }

  Future<AuthEntity> readAuth() async {
    final data = await _storage.read(key: _keyAuth);
    if (data?.isNotEmpty ?? false) {
      return AuthModel.fromJson(data!).toEntity();
    } else {
      throw CacheException(message: 'Không có dữ liệu người dùng được lưu!');
    }
  }

  Future<void> cacheAuth(String jsonData) async {
    try {
      await _storage.write(key: _keyAuth, value: jsonData);
    } catch (e) {
      throw CacheException(message: 'Có lỗi xảy ra khi lưu thông tin người dùng!');
    }
  }

  Future<void> deleteAuth() async => await _storage.delete(key: _keyAuth);

  Future<void> deleteAll() async => await _storage.deleteAll();
}
