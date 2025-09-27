import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  String id;
  String firstName;
  String lastName;
  String mobileNo;
  String countryCode;
  String createdAt;
  String updatedAt;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.countryCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    mobileNo: json["mobileNo"],
    countryCode: json["countryCode"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "mobileNo": mobileNo,
    "countryCode": countryCode,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };

  // Helper methods
  String get fullName => '$firstName $lastName';
  String get formattedMobileNo => '+$countryCode $mobileNo';
}
