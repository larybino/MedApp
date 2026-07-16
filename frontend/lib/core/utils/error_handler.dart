import 'package:dio/dio.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static String handle(DioException e) {
    final data = e.response?.data;

    if (data is Map) {
      final details = data['details'];
      if (details is List && details.isNotEmpty) {
        return details.map((d) => d.toString()).join('\n');
      }
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'Erro desconhecido';
    }

    switch (e.type) {
      case DioExceptionType.connectionError:
        return 'Sem conexão com o servidor';
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'O servidor demorou para responder. Tente novamente';
      default:
        return 'Erro inesperado';
    }
  }
}
