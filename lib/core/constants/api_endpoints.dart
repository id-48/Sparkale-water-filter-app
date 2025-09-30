class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://4wjn4k6yxc.execute-api.ap-south-1.amazonaws.com/development';

  // Auth
  static const String login = '/v1/login';
  static const String signup = '/v1/signup';
  static const String verifySignUpOtp = '/v1/verifySignUpOtp';
  static const String verifyLogin = '/v1/verifyLogin';
  static const String verifyLoginWithToken = '/v1/verifyLogin';
  static const String resendLoginOtp = '/v1/resendLoginOtp';
  static const String resendSignUpOtp = '/v1/resendSignUpOtp';
  static const String logout = '/v1/logout';
  static const String getCustomer = '/v1/getCustomer';
}


