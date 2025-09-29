import 'package:dio/dio.dart';

class ApiErrorHandler {
  /// Handle Dio exceptions and return appropriate user-friendly error messages
  static String handleError(dynamic error) {
    String defaultErrorMessage = 'Something went wrong. Please try again.';

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Network timeout. Please check your internet connection.';
      } else if (error.response?.data != null) {
        try {
          final responseData = error.response!.data;
          if (responseData is Map<String, dynamic>) {
            if (responseData['error'] != null && responseData['error'].toString().isNotEmpty) {
              return responseData['error'].toString();
            }
          }
        } catch (_) {
        }
      } else if (error.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please check your network.';
      } else if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode != null) {
          final statusCode = error.response!.statusCode!;
          if (statusCode >= 400 && statusCode < 500) {
            return 'Invalid request. Please check your input.';
          } else if (statusCode >= 500) {
            return 'Server error. Please try again later.';
          }
        }
      }
      
      return error.message ?? defaultErrorMessage;
    } else if (error is Exception) {
      final exceptionMessage = error.toString();
      if (exceptionMessage.startsWith('Exception: ')) {
        return exceptionMessage.replaceFirst('Exception: ', '');
      } else {
        return exceptionMessage;
      }
    }

    return defaultErrorMessage;
  }

  /// Extract error message from DioException response
  static String? extractErrorMessageFromResponse(DioException dioException) {
    if (dioException.response?.data == null) return null;

    try {
      final responseData = dioException.response!.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('error') && responseData['error'] != null) {
          return responseData['error'].toString();
        }
        if (responseData.containsKey('message') && responseData['message'] != null) {
          return responseData['message'].toString();
        }
        if (responseData.containsKey('errors') && responseData['errors'] != null) {
          final errors = responseData['errors'];
          if (errors is List && errors.isNotEmpty) {
            return errors.first.toString();
          }
        }
      }
    } catch (_) {
    }
    
    return null;
  }
}
