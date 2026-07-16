import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:frontend/core/utils/error_handler.dart';
import 'package:http_parser/http_parser.dart';
import 'package:frontend/features/models/extracted_medication_model.dart';
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
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<MedicationModel> getById(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.medicationById(id));
      return MedicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<MedicationModel> create(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.medications, data: data);
      return MedicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
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
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _dio.delete(ApiEndpoints.medicationById(id));
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<MedicationModel> confirmAcquisition(int id) async {
    try {
      final response = await _dio.put(ApiEndpoints.confirmAcquisition(id));
      return MedicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<MedicationModel> endTreatment(int id) async {
    try {
      final response = await _dio.put(ApiEndpoints.endTreatment(id));
      return MedicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<ExtractedMedicationModel>> extractFromPrescription(
    Uint8List fileBytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.extractMedication,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final medications = response.data['medications'] as List;
      return medications
          .map((e) => ExtractedMedicationModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
