import 'package:dio/dio.dart';
import 'package:frontend/features/models/user_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';

class UserService {
  final Dio _dio = ApiClient.instance;

  Future<UserModel> getProfile(int userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.userById(userId));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateProfile(int userId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.userById(userId),
        data: data,
      );
      return UserModel.fromJson(response.data);
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