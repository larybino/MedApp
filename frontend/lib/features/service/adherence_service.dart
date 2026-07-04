import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/adherence_history_model.dart';

class AdherenceService {
  final Dio _dio = ApiClient.instance;

  Future<List<AdherenceHistoryModel>> getLast30Days(int userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.adherence,
        queryParameters: {'userId': userId},
      );
      return (response.data as List)
          .map((e) => AdherenceHistoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<AdherenceHistoryModel>> getByPeriod(
    int userId,
    String startDate,
    String endDate,
  ) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.adherencePeriod,
        queryParameters: {
          'userId': userId,
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      return (response.data as List)
          .map((e) => AdherenceHistoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['error']?.toString() ?? 'Erro desconhecido';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Sem conexão com o servidor';
    }
    return 'Erro inesperado';
  }
}
