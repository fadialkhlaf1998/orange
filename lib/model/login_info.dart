import 'package:meta/meta.dart';
import 'dart:convert';

class LoginInfo {
  LoginInfo({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  factory LoginInfo.fromJson(String str) => LoginInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginInfo.fromMap(Map<String, dynamic> json) => LoginInfo(
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toMap() => {
    "email": email,
    "password": password,
  };
}
