class SignupRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNo;
  final String image;
  final String countryCode;
  final String reCaptchaToken;
  final String platform;

  const SignupRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNo,
    required this.image,
    required this.countryCode,
    required this.reCaptchaToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNo': mobileNo,
      'image': image,
      'countryCode': countryCode,
      'reCaptchaToken': reCaptchaToken,
      'platform': platform,
    };
  }

  @override
  String toString() {
    return 'SignupRequest{firstName: $firstName, lastName: $lastName, email: $email, mobileNo: $mobileNo}';
  }
}
