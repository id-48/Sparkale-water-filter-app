import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../utils/logger.dart';

class ApiClient {
  ApiClient._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {"Content-Type": "application/json"},
            validateStatus: (status) => true,
          ),
        ) {
    _setupInterceptors();
  }

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  final Dio _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.api(
            'Request: ${options.method} ${options.path}',
            endpoint: options.path,
            data: options.data,
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.network(
            'Response received',
            url: response.requestOptions.path,
            statusCode: response.statusCode,
          );
          Logger.api(
            'Response data',
            endpoint: response.requestOptions.path,
            data: response.data,
          );
          handler.next(response);
        },
        onError: (error, handler) {
          Logger.e(
            'API Error: ${error.message}',
            error: error,
          );
          handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> postJson<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      Logger.api(
        'Making POST request to: $path',
        endpoint: path,
        data: data,
      );

      final Response<T> response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: query,
        options: options,
      );

      return response;
    } catch (e, st) {
      Logger.e('API call failed for: $path', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Logger.api('Making GET request to: $path', endpoint: path,);

      final requestOptions = options ?? Options();
      if (headers != null) {
        requestOptions.headers = headers;
      }

      final Response<T> response = await _dio.get<T>(
        path,
        queryParameters: query,
        options: requestOptions,
      );

      return response;
    } catch (e, st) {
      Logger.e('API call failed for: $path', error: e, stackTrace: st);
      rethrow;
    }
  }
}


