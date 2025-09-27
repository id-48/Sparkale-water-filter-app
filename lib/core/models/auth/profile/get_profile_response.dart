import 'dart:convert';
import 'customer.dart';

GetProfileResponse getProfileResponseFromJson(String str) => GetProfileResponse.fromJson(json.decode(str));

String getProfileResponseToJson(GetProfileResponse data) => json.encode(data.toJson());

class GetProfileResponse {
  bool success;
  String error;
  String reasonCode;
  Customer customer;

  GetProfileResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.customer,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) => GetProfileResponse(
    success: json["success"],
    error: json["error"],
    reasonCode: json["reasonCode"],
    customer: Customer.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "reasonCode": reasonCode,
    "customer": customer.toJson(),
  };
}
