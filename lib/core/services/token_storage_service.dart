import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

class TokenStorageService {

  static const String _jwtTokenKey = 'jwt_token';
  static const String _loginTokenKey = 'login_token';
  static const String _loginTokenIdKey = 'login_token_id';

  Future<void> saveJWTToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_jwtTokenKey, token);
      Logger.i('JWT token saved successfully');
      Logger.d('JWT token value: ${token.substring(0, 20)}...');
    } catch (e, st) {
      Logger.e('Failed to save JWT token', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<String?> getJWTToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_jwtTokenKey);
      if (token != null) {
        Logger.d('JWT token retrieved: ${token.substring(0, 20)}...');
      } else {
        Logger.d('No JWT token found in storage');
      }
      return token;
    } catch (e, st) {
      Logger.e('Failed to get JWT token', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> saveLoginTokens(String loginToken, String loginTokenId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_loginTokenKey, loginToken);
      await prefs.setString(_loginTokenIdKey, loginTokenId);
      Logger.i('Login tokens saved successfully');
    } catch (e, st) {
      Logger.e('Failed to save login tokens', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Map<String, String?>> getLoginTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'loginToken': prefs.getString(_loginTokenKey),
        'loginTokenId': prefs.getString(_loginTokenIdKey),
      };
    } catch (e, st) {
      Logger.e('Failed to get login tokens', error: e, stackTrace: st);
      return {'loginToken': null, 'loginTokenId': null};
    }
  }

  Future<void> clearAllTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_jwtTokenKey);
      await prefs.remove(_loginTokenKey);
      await prefs.remove(_loginTokenIdKey);
      Logger.i('All tokens cleared successfully');
    } catch (e, st) {
      Logger.e('Failed to clear tokens', error: e, stackTrace: st);
      rethrow;
    }
  }
}
