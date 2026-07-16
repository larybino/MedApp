import 'package:dio/dio.dart';
import 'package:frontend/core/utils/error_handler.dart';
import 'package:frontend/features/models/schedule_dose_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';

class ScheduleService {
  final Dio _dio = ApiClient.instance;

  Future<List<ScheduledDoseModel>> getTodayDoses(int userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.scheduleToday,
        queryParameters: {'userId': userId},
      );
      return (response.data as List)
          .map((e) => ScheduledDoseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<ScheduledDoseModel>> getDosesByDate(
    int userId,
    String date,
  ) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.scheduleDoses,
        queryParameters: {'userId': userId, 'date': date},
      );
      return (response.data as List)
          .map((e) => ScheduledDoseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<ScheduledDoseModel> confirmDose(int doseId) async {
    try {
      final response = await _dio.put(ApiEndpoints.confirmDose(doseId));
      return ScheduledDoseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
