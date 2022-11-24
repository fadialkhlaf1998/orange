// To parse this JSON data, do
//
//     final CartModel = CartModelFromMap(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

class CartModel {
  CartModel({
    required this.discountCode,
    required this.discount,
    required this.subTotal,
    required this.total,
    required this.shipping,
    required this.vat,
    required this.cart,
  });

  String discountCode;
  double discount;
  double subTotal;
  double total;
  double shipping;
  double vat;
  List<CartItem> cart;

  factory CartModel.fromJson(String str) => CartModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartModel.fromMap(Map<String, dynamic> json) => CartModel(
    discountCode: json["discountCode"],
    discount: double.parse(json["discount"].toString()),
    subTotal: double.parse(json["sub_total"].toString()),
    total:double.parse(json["total"].toString()) ,
    shipping: double.parse(json["shipping"].toString()),
    vat: json["vat"].toDouble(),
    cart: List<CartItem>.from(json["cart"].map((x) => CartItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "discountCode": discountCode,
    "discount": discount,
    "sub_total": subTotal,
    "total": total,
    "shipping": shipping,
    "vat": vat,
    "cart": List<dynamic>.from(cart.map((x) => x.toMap())),
  };
}

class CartItem {
  CartItem({
    required this.id,
    required this.optionId,
    required this.customerId,
    required this.count,
    required this.createdAt,
    required this.hard,
    required this.ram,
    required this.additionatlOption,
    required this.stock,
    required this.addetionalPrice,
    required this.images,
    required this.colorId,
    required this.productId,
    required this.title,
    required this.image,
    required this.cartSlug,
    required this.slug,
    required this.locale,
    required this.subCategoryId,
    required this.brandId,
    required this.description,
    required this.metaTitle,
    required this.metaDescription,
    required this.publish,
    required this.oldPrice,
    required this.price,
    required this.availbilty,
    required this.tag,
    required this.languageParent,
    required this.categoryId,
    required this.cartId,
    required this.canDiscount,
    required this.discount,
    required this.color,
  });

  int id;
  int optionId;
  int customerId;
  int count;
  DateTime createdAt;
  String hard;
  String ram;
  String additionatlOption;
  int stock;
  double addetionalPrice;
  String images;
  int colorId;
  int productId;
  String title;
  String image;
  String cartSlug;
  String color;
  String slug;
  String locale;
  int subCategoryId;
  int brandId;
  String description;
  String metaTitle;
  String metaDescription;
  int publish;
  double? oldPrice;
  double price;
  int availbilty;
  String tag;
  int languageParent;
  int categoryId;
  int cartId;
  bool canDiscount;
  int discount;
  RxBool loading = false.obs;
  factory CartItem.fromJson(String str) => CartItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartItem.fromMap(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    optionId: json["option_id"],
    customerId: json["customer_id"],
    count: json["count"],
    createdAt: DateTime.parse(json["created_at"]),
    hard: json["hard"],
    ram: json["ram"],
    additionatlOption: json["additionatl_option"],
    stock: json["stock"],
    addetionalPrice: json["addetional_price"]==null ?0.0:double.parse(json["addetional_price"].toString()),
    images: json["images"],
    colorId: json["color_id"],
    productId: json["product_id"],
    title: json["title"],
    image: json["image"],
    cartSlug: json["slug"],
    slug: json["_slug"],
    locale: json["locale"],
    subCategoryId: json["sub_category_id"],
    brandId: json["brand_id"],
    color: json["color"]==null?"":json["color"],
    description: json["description"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    publish: json["publish"],
    oldPrice: json["old_price"]==null ?null:double.parse(json["old_price"].toString()),
    price: json["price"]==null ?0.0:double.parse(json["price"].toString()),
    availbilty: json["availbilty"],
    tag: json["tag"],
    languageParent: json["language_parent"],
    categoryId: json["category_id"],
    cartId: json["cart_id"],
    canDiscount: json["can_discount"],
    discount: json["discount"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "option_id": optionId,
    "customer_id": customerId,
    "count": count,
    "created_at": createdAt.toIso8601String(),
    "hard": hard,
    "ram": ram,
    "additionatl_option": additionatlOption,
    "stock": stock,
    "addetional_price": addetionalPrice,
    "images": images,
    "color_id": colorId,
    "product_id": productId,
    "title": title,
    "image": image,
    "slug": cartSlug,
    "_slug": slug,
    "locale": locale,
    "sub_category_id": subCategoryId,
    "brand_id": brandId,
    "description": description,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "publish": publish,
    "old_price": oldPrice,
    "price": price,
    "availbilty": availbilty,
    "tag": tag,
    "language_parent": languageParent,
    "category_id": categoryId,
    "cart_id": cartId,
    "can_discount": canDiscount,
    "discount": discount,
  };
}
