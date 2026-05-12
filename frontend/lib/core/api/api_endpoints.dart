import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    } else if (Platform.isIOS) {
      return 'http://localhost:8080';
    } else {
      return 'http://localhost:8080';
    }
  }

  static const String login = '/auth/login';

  static const String register = '/users/register';
  static const String forgotPassword = '/users/forgot-password';
  static const String resetPassword = '/users/reset-password';
  static const String changePassword = '/users/change-password';
  static String userById(int id) => '/users/$id';
  static String members(int masterId) => '/users/$masterId/members';
  static String memberById(int masterId, int memberId) => '/users/$masterId/members/$memberId';
}