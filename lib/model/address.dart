import 'dart:convert';

class AddressDecoder {
  AddressDecoder({
    required this.address,
  });

  List<Address> address;

  factory AddressDecoder.fromJson(String str) => AddressDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddressDecoder.fromMap(Map<String, dynamic> json) => AddressDecoder(
    address: List<Address>.from(json["address"].map((x) => Address.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "address": List<dynamic>.from(address.map((x) => x.toMap())),
  };
}

class Address {
  Address({
    required this.id,
    required this.nickName,
    required this.stretName,
    required this.building,
    required this.floor,
    required this.flat,
    required this.phone,
    required this.addetionalDescription,
    required this.isDefault,
    required this.dailCode,
    required this.isoCode,
    required this.customerId,
  });

  int id;
  String nickName;
  String stretName;
  String building;
  int floor;
  int flat;
  String phone;
  String addetionalDescription;
  int isDefault;
  String dailCode;
  String isoCode;
  int customerId;

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    id: json["id"],
    nickName: json["nick_name"],
    stretName: json["stret_name"],
    building: json["building"],
    floor: json["floor"],
    flat: json["flat"],
    phone: json["phone"],
    addetionalDescription: json["addetional_description"],
    isDefault: json["is_default"],
    dailCode: json["dail_code"],
    isoCode: json["iso_code"],
    customerId: json["customer_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nick_name": nickName,
    "stret_name": stretName,
    "building": building,
    "floor": floor,
    "flat": flat,
    "phone": phone,
    "addetional_description": addetionalDescription,
    "is_default": isDefault,
    "dail_code": dailCode,
    "iso_code": isoCode,
    "customer_id": customerId,
  };
}
