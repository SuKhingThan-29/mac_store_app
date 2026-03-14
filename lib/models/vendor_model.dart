// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Vendor {
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String id;
  final String token;
  final String role;
  final String? storeImage;
  final String? storeDescription;

  Vendor(
      {required this.fullName,
        required this.email,
        required this.state,
        required this.city,
        required this.locality,
        required this.password,
        required this.id,
        required this.token,
        required this.role,
        required this.storeImage,
        required this.storeDescription

      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
      'id': id,
      'token': token,
      'role':role,
      'storeImage':storeImage,
      'storeDescription':storeDescription
    };
  }

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
        fullName: map['fullName'] as String? ?? "",
        email: map['email'] as String? ?? "",
        state: map['state'] as String? ?? "",
        city: map['city'] as String? ?? "",
        locality: map['locality'] as String? ?? "",
        password: map['password'] as String? ?? "",
        id: map['_id'] as String? ?? "",
        token: map['token'] as String? ?? "",
        role: map['role'] as String? ?? "",
        storeImage: map['storeImage'] as String? ?? "",
        storeDescription: map['storeDescription'] as String? ?? ""
    );
  }

  String toJson() => json.encode(toMap());

  factory Vendor.fromJson(String source) =>
      Vendor.fromMap(json.decode(source) as Map<String, dynamic>);
}
