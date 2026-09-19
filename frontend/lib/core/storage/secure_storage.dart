import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'jwt_helper.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (_) {
      await clear();
      return null;
    }
  }

  static Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  static Future<void> saveUserId(int id) =>
      _storage.write(key: _userIdKey, value: id.toString());

  static Future<int?> getUserId() async {
    try {
      final value = await _storage.read(key: _userIdKey);
      return value != null ? int.tryParse(value) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveRole(String role) =>
      _storage.write(key: 'user_role', value: role);

  static Future<String?> getRole() async {
    try {
      return await _storage.read(key: 'user_role');
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() => _storage.deleteAll();

  static Future<bool> isLoggedIn() async {
    final token = await getToken(); 
    if (token == null || token.isEmpty) return false;
    return !JwtHelper.isExpired(token);
  }
}