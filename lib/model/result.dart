import 'dart:convert';

class Result {
  Result({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
  };
}
