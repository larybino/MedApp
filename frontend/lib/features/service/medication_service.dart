import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../models/medication_model.dart';

class MedicationService {
  final Dio _dio = ApiClient.instance;

  Future<List<MedicationModel>> getMedications(int userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.medications,
        queryParameters: {'userId': userId},
      );
      return (response.data as List)
          .map((e) => MedicationModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicationModel> getById(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.medicationById(id));
      return MedicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicationModel> create(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.medications, data: data);
      return MedicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicationModel> update(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.medicationById(id),
        data: data,
      );
      return MedicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _dio.delete(ApiEndpoints.medicationById(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicationModel> confirmAcquisition(int id) async {
    try {
      final response = await _dio.put(ApiEndpoints.confirmAcquisition(id));
      return MedicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MedicationModel> endTreatment(int id) async {
    try {
      final response = await _dio.put(ApiEndpoints.endTreatment(id));
      return MedicationModel.fromJson(response.data);
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
