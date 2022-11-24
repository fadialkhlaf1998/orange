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
  });

  Filter filter;
  List<Product> products;

  factory FilterResult.fromJson(String str) => FilterResult.fromMap(json.decode(str));

  factory FilterResult.fromMap(Map<String, dynamic> json) => FilterResult(
    filter: Filter.fromMap(json["filter"]),
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
  });

  List<String> categories;
  List<String> brands;
  List<String> subCategories;
  List<String> products;
  int? sort;
  int? limit;
  int? lazyLoad;
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
