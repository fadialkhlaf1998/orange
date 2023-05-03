// To parse this JSON data, do
//
//     final categoryDecoder = categoryDecoderFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:orange/model/sub_category.dart';

class CategoryDecoder {
  CategoryDecoder({
    required this.categories,
  });

  List<Category> categories;

  factory CategoryDecoder.fromJson(String str) => CategoryDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryDecoder.fromMap(Map<String, dynamic> json) => CategoryDecoder(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
  };
}

class Category {
  Category({
    required this.id,
    required this.title,
    required this.image,
    required this.categorySlug,
    required this.slug,
    required this.locale,
    required this.subCategories,
    required this.productCount,
  });

  int id;
  String title;
  String image;
  String categorySlug;
  String slug;
  String locale;
  int productCount;
  List<SubCategory> subCategories;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
    productCount: json["product_count"],
    image: json["image"],
    categorySlug: json["slug"],
    slug: json["_slug"],
    locale: json["locale"],
    subCategories: List<SubCategory>.from(json["sub_categories"].map((x) => SubCategory.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "slug": categorySlug,
    "_slug": slug,
    "locale": locale,
    "product_count":productCount
  };

  isCheckedFilter(List<String> categories){
    for(String slug in categories){
      if(slug == categorySlug){
        return true;
      }
    }
    return false;
  }
}
