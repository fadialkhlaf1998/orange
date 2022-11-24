import 'dart:convert';

class CustomerDecoder {
  CustomerDecoder({
    required this.customer,
  });

  Customer customer;

  factory CustomerDecoder.fromJson(String str) => CustomerDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerDecoder.fromMap(Map<String, dynamic> json) => CustomerDecoder(
    customer: Customer.fromMap(json["customer"]),
  );

  Map<String, dynamic> toMap() => {
    "customer": customer.toMap(),
  };
}

class Customer {
  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.code,
    required this.isActive,
    required this.image,
    required this.token,
  });

  int id;
  String name;
  String email;
  String password;
  String code;
  int isActive;
  String image;
  String token;

  factory Customer.fromJson(String str) => Customer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    code: json["code"],
    isActive: json["is_active"],
    image: json["image"] == null ?"":json["image"],
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "code": code,
    "is_active": isActive,
    "image": image,
    "token": token,
  };
}
