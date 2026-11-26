import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_shelf_auth_module/core/storage/secure_storage/secure_storage_keys.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppSecureStorage {
  final FlutterSecureStorage _storage;

  AppSecureStorage(this._storage);

  Future<void> saveToken(String token) async =>
      await _storage.write(key: SecureStorageKeys.tokenKey, value: token);

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: SecureStorageKeys.tokenKey);
    } catch (e) {
      await _storage.deleteAll();
      return null;
    }
  }

  Future<void> deleteToken() async =>
      await _storage.delete(key: SecureStorageKeys.tokenKey);
}
