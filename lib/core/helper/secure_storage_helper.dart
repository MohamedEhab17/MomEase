import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageHelper {
  final FlutterSecureStorage _secureStorage;

  SecureStorageHelper(this._secureStorage);

  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    return await _secureStorage.containsKey(key: key);
  }
}
