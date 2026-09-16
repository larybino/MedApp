import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  static const _publicPaths = [ApiEndpoints.login, ApiEndpoints.register];

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final isPublic = _publicPaths.any(
                (path) => options.path.startsWith(path),
              );

              if (!isPublic) {
                String? token;
                try {
                  token = await SecureStorage.getToken().timeout(
                    const Duration(seconds: 3),
                  );
                } catch (_) {
                  token = null;
                }
                if (token != null) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
              }

              return handler.next(options);
            },
            onError: (error, handler) {
              if (error.response?.statusCode == 401) {
                SecureStorage.clear();
              }
              return handler.next(error);
            },
          ),
        );

  static Dio get instance => _dio;
}
