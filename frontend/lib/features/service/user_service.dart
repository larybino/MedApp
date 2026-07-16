import 'package:dio/dio.dart';
import 'package:frontend/core/utils/error_handler.dart';
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
      throw ApiErrorHandler.handle(e);
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
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> changePassword(Map<String, dynamic> data) async {
    try {
      await _dio.post(ApiEndpoints.changePassword, data: data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> deleteAccount(int userId) async {
    try {
      await _dio.delete(ApiEndpoints.userById(userId));
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<UserModel>> getMembers(int masterId) async {
    try {
      final response = await _dio.get(ApiEndpoints.members(masterId));
      return (response.data as List).map((e) => UserModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> createMember({
    required int masterId,
    required String mode,
    String? name,
    String? email,
    String? password,
    String? memberCode,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.members(masterId),
        data: {
          'mode': mode,
          if (name != null && name.isNotEmpty) 'name': name,
          if (email != null && email.isNotEmpty) 'email': email,
          if (password != null && password.isNotEmpty) 'password': password,
          if (memberCode != null && memberCode.isNotEmpty)
            'memberCode': memberCode,
        },
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> removeMember(int masterId, int memberId) async {
    try {
      await _dio.delete(ApiEndpoints.memberById(masterId, memberId));
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
