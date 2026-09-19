import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  static const _publicPaths = [ApiEndpoints.login, ApiEndpoints.register];

  static const _retriedFlag = 'apiClientRetried';

  static Future<String?> _readTokenWithRetry() async {
    try {
      return await SecureStorage.getToken().timeout(const Duration(seconds: 5));
    } catch (_) {
      try {
        return await SecureStorage.getToken().timeout(const Duration(seconds: 3));
      } catch (_) {
        return null;
      }
    }
  }

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
                final token = await _readTokenWithRetry();
                if (token != null) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
              }

              return handler.next(options);
            },
            onError: (error, handler) async {
              final isPublic = _publicPaths.any(
                (path) => (error.requestOptions.path).startsWith(path),
              );
              final alreadyRetried =
                  error.requestOptions.extra[_retriedFlag] == true;
              final hadAuthHeader =
                  error.requestOptions.headers['Authorization'] != null;

              if (error.response?.statusCode == 401 &&
                  !isPublic &&
                  !alreadyRetried) {
              
                final token = await _readTokenWithRetry();

                if (token != null) {
                  final retryOptions = error.requestOptions;
                  retryOptions.headers['Authorization'] = 'Bearer $token';
                  retryOptions.extra[_retriedFlag] = true;
                  try {
                    final response = await _dio.fetch(retryOptions);
                    return handler.resolve(response);
                  } catch (_) {
                  }
                }

            
                if (hadAuthHeader || token != null) {
                  await SecureStorage.clear();
                }
              }
              return handler.next(error);
            },
          ),
        );

  static Dio get instance => _dio;
}