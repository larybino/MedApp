import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    } else if (Platform.isAndroid) {
      return 'http://192.168.1.22:8080';
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
  static String memberById(int masterId, int memberId) =>
      '/users/$masterId/members/$memberId';

  static const String medications = '/medications';
  static String medicationById(int id) => '/medications/$id';
  static String confirmAcquisition(int id) =>
      '/medications/$id/confirm-acquisition';
  static String endTreatment(int id) => '/medications/$id/end-treatment';
  static String medicationsByUser(int userId) => '/medications?userId=$userId';

  static const String scheduleToday = '/schedule/today';
  static const String scheduleDoses = '/schedule/doses';
  static String confirmDose(int id) => '/schedule/doses/$id/confirm';

  static const String adherence = '/adherence';
  static const String adherencePeriod = '/adherence/period';
}
