import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<String?> getToken() =>
      _storage.read(key: _tokenKey);

  static Future<void> deleteToken() =>
      _storage.delete(key: _tokenKey);

  static Future<void> saveUserId(int id) =>
      _storage.write(key: _userIdKey, value: id.toString());

  static Future<int?> getUserId() async {
    final value = await _storage.read(key: _userIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  static Future<void> clear() => _storage.deleteAll();

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}