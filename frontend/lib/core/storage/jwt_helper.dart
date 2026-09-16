import 'dart:convert';

class JwtHelper {
  static bool isExpired(String token) {
    final payload = _decodePayload(token);
    if (payload == null) return true;

    final exp = payload['exp'];
    if (exp is! int) return true;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(
      exp * 1000,
      isUtc: true,
    );
    return DateTime.now().toUtc().isAfter(expiryDate);
  }

  static Map<String, dynamic>? _decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      var normalized = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      switch (normalized.length % 4) {
        case 2:
          normalized += '==';
          break;
        case 3:
          normalized += '=';
          break;
      }

      final decoded = utf8.decode(base64.decode(normalized));
      final data = jsonDecode(decoded);
      return data is Map<String, dynamic> ? data : null;
    } catch (_) {
      return null;
    }
  }
}
