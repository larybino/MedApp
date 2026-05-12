import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/storage/secure_storage.dart';

class AuthService {
  final Dio _dio = ApiClient.instance;

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final token = response.data['token'];
      final userId = response.data['id'];
      final role = response.data['role'];
      if (token == null) {
        throw Exception('Token não recebido do servidor');
      }
      if (userId == null) {
        throw Exception('ID do usuário não recebido do servidor');
      }
      await SecureStorage.saveToken(token);
      await SecureStorage.saveUserId(userId);
      await SecureStorage.saveRole(role); 
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> register(String name, String email,
      String password, String confirmPassword) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
      await SecureStorage.saveUserId(response.data['id']);
      await SecureStorage.saveRole(response.data['role']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resetPassword(String token,
      String newPassword, String confirmPassword) async {
    try {
      await _dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'token': token,
          'newPassword': newPassword,
          'confirmNewPassword': confirmPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await SecureStorage.clear();
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