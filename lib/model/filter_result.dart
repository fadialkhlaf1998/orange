// To parse this JSON data, do
//
//     final filterResult = filterResultFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:orange/model/product.dart';

class FilterResult {
  FilterResult({
    required this.filter,
    required this.products,
    required this.priceRange,
  });

  Filter filter;
  PriceRange priceRange;
  List<Product> products;

  factory FilterResult.fromJson(String str) => FilterResult.fromMap(json.decode(str));

  factory FilterResult.fromMap(Map<String, dynamic> json) => FilterResult(
    filter: Filter.fromMap(json["filter"]),
    priceRange: PriceRange.fromMap(json["price_range"]),
    products:  List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
  );


}
class Filter {
  Filter({
    required this.categories,
    required this.brands,
    required this.subCategories,
    required this.products,
    required this.sort,
    required this.limit,
    required this.lazyLoad,
    required this.locale,
    required this.customerId,
    required this.option,
    required this.min_price,
    required this.max_price,
  });

  List<String> categories;
  List<String> brands;
  List<String> subCategories;
  List<String> products;
  int? sort;
  int? limit;
  int? lazyLoad;
  double? min_price;
  double? max_price;
  String locale;
  String option;
  int customerId;

  factory Filter.fromJson(String str) => Filter.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Filter.fromMap(Map<String, dynamic> json) => Filter(
    categories: List<String>.from(json["categories"].map((x) => x)),
    brands: List<String>.from(json["brands"].map((x) => x)),
    subCategories: List<String>.from(json["sub_categories"].map((x) => x)),
    products: List<String>.from(json["products"].map((x) => x)),
    sort: json["sort"],
    limit: json["limit"],
    lazyLoad: json["lazy_load"],
    locale: json["locale"],
    customerId: json["customer_id"],
    option: json["option"],
    min_price: json["min_price"] == null?null:double.parse(json["min_price"].toString()),
    max_price: json["max_price"] == null?null:double.parse(json["max_price"].toString()),
  );

  Map<String, dynamic> toMap() => {
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "brands": List<dynamic>.from(brands.map((x) => x)),
    "sub_categories": List<dynamic>.from(subCategories.map((x) => x)),
    "products": List<dynamic>.from(products.map((x) => x)),
    "sort": sort,
    "limit": limit,
    "lazy_load": lazyLoad,
    "locale": locale,
    "customer_id": customerId,
  };
}

class PriceRange {
  PriceRange({
    required this.min_price,
    required this.max_price,
  });

  double? min_price;
  double? max_price;

  factory PriceRange.fromJson(String str) => PriceRange.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PriceRange.fromMap(Map<String, dynamic> json) => PriceRange(
    min_price: json["min_price"]!= null?double.parse(json["min_price"].toString()):null,
    max_price: json["max_price"]!= null?double.parse(json["max_price"].toString()):null,
  );

  Map<String, dynamic> toMap() => {
    "min_price": min_price,
    "max_price": max_price,
  };
}