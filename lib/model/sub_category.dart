// To parse this JSON data, do
//
//     final SubCategoryDecoder = SubCategoryDecoderFromMap(jsonString);

import 'dart:convert';

class SubCategoryDecoder {
  SubCategoryDecoder({
    required this.sub_categories,
  });

  List<SubCategory> sub_categories;

  factory SubCategoryDecoder.fromJson(String str) => SubCategoryDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategoryDecoder.fromMap(Map<String, dynamic> json) => SubCategoryDecoder(
    sub_categories: List<SubCategory>.from(json["sub_categories"].map((x) => SubCategory.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "sub_categories": List<dynamic>.from(sub_categories.map((x) => x.toMap())),
  };
}

class SubCategory {
  SubCategory({
    required this.id,
    required this.title,
    required this.image,
    required this.subCategorySlug,
    required this.slug,
    required this.locale,
  });

  int id;
  String title;
  String image;
  String subCategorySlug;
  String slug;
  String locale;

  factory SubCategory.fromJson(String str) => SubCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategory.fromMap(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    subCategorySlug: json["slug"],
    slug: json["_slug"],
    locale: json["locale"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "slug": subCategorySlug,
    "_slug": slug,
    "locale": locale,
  };

  isCheckedFilter(List<String> categories){
    for(String slug in categories){
      if(slug == subCategorySlug){
        return true;
      }
    }
    return false;
  }
}
