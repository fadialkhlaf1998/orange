import 'dart:convert';
import 'package:orange/model/banner.dart';
import 'package:orange/model/brand.dart';
import 'package:orange/model/category.dart';
import 'package:orange/model/company_category.dart';
import 'package:orange/model/search_suggestions.dart';
import 'package:orange/model/section.dart';

class StartUpDecoder {
  StartUpDecoder({
    required this.categories,
    required this.brands,
    required this.sections,
    required this.banners,
    required this.search_suggestions,
  });

  List<Category> categories;
  List<Brand> brands;
  List<Section> sections;
  List<MyBanner> banners;
  List<SearchSuggestion> search_suggestions;

  factory StartUpDecoder.fromJson(String str) => StartUpDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StartUpDecoder.fromMap(Map<String, dynamic> json) => StartUpDecoder(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromMap(x))),
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromMap(x))),
    sections: List<Section>.from(json["sections"].map((x) => Section.fromMap(x))),
    banners: List<MyBanner>.from(json["banners"].map((x) => MyBanner.fromMap(x))),
    search_suggestions:List<SearchSuggestion>.from(json["search_suggestions"].map((x) => SearchSuggestion.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
    "brands": List<dynamic>.from(brands.map((x) => x.toMap())),
    "sections": List<dynamic>.from(sections.map((x) => x.toMap())),
    "banners": List<dynamic>.from(banners.map((x) => x.toMap())),
  };
}
