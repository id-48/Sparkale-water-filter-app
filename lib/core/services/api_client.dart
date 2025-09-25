import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';

class ApiClient {
  ApiClient._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {"Content-Type": "application/json"},
            // Allow reading body for non-2xx responses (e.g., 401 with JSON error)
            validateStatus: (status) => true,
          ),
        );

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  final Dio _dio;

  Future<Response<T>> postJson<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    final Response<T> response = await _dio.post<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
    );
    return response;
  }
}


