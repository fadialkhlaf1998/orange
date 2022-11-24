// To parse this JSON data, do
//
//     final ordersDecoder = ordersDecoderFromMap(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:orange/model/line_items.dart';

class OrdersDecoder {
  OrdersDecoder({
    required this.orders,
  });

  List<Order> orders;

  factory OrdersDecoder.fromJson(String str) => OrdersDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrdersDecoder.fromMap(Map<String, dynamic> json) => OrdersDecoder(
    orders: List<Order>.from(json["orders"].map((x) => Order.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toMap())),
  };
}

class Order {
  Order({
    required this.id,
    required this.placedAt,
    required this.addressInfo,
    required this.subTotal,
    required this.shipping,
    required this.discount,
    required this.total,
    required this.vat,
    required this.invoice,
    required this.isPaid,
    required this.transactionId,
    required this.state,
    required this.discountCode,
    required this.customerId,
    required this.changeState,
    required this.name,
    required this.email,
    required this.def,
    required this.lineItems,
  });

  int id;
  DateTime placedAt;
  String addressInfo;
  double subTotal;
  double shipping;
  double discount;
  double total;
  double vat;
  String invoice;
  int isPaid;
  int def;
  String transactionId;
  int state;
  String discountCode;
  int customerId;
  String changeState;
  String name;
  String email;
  List<LineItem> lineItems;
  RxBool loading = false.obs;

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    id: json["id"],
    placedAt: DateTime.parse(json["placed_at"]),
    addressInfo: json["address_info"],
    subTotal: double.parse(json["sub_total"].toString()),
    shipping: double.parse(json["shipping"].toString()),
    discount: double.parse(json["discount"].toString()),
    total: double.parse(json["total"].toString()),
    vat: json["vat"].toDouble(),
    invoice: json["invoice"],
    def: json["def"],
    isPaid: json["is_paid"],
    transactionId: json["transaction_id"],
    state: json["state"],
    discountCode: json["discount_code"],
    customerId: json["customer_id"],
    changeState: json["change_state"],
    name: json["name"],
    email: json["email"],
    lineItems: json["line_items"]==null?<LineItem>[]: List<LineItem>.from(json["line_items"].map((x) => LineItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "placed_at": placedAt.toIso8601String(),
    "address_info": addressInfo,
    "sub_total": subTotal,
    "shipping": shipping,
    "discount": discount,
    "total": total,
    "vat": vat,
    "invoice": invoice,
    "is_paid": isPaid,
    "transaction_id": transactionId,
    "state": state,
    "discount_code": discountCode,
    "customer_id": customerId,
    "change_state": changeState,
    "name": name,
    "email": email,
  };
}
