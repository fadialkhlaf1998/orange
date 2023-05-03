import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orange/model/product.dart';

class SectionDecoder {
  SectionDecoder({
    required this.sections,
  });

  List<Section> sections;

  factory SectionDecoder.fromJson(String str) => SectionDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SectionDecoder.fromMap(Map<String, dynamic> json) => SectionDecoder(
    sections: List<Section>.from(json["sections"].map((x) => Section.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "sections": List<dynamic>.from(sections.map((x) => x.toMap())),
  };
}

class Section {
  Section({
    required this.id,
    required this.title,
    required this.locale,
    required this.languageParent,
    // required this.position,
    required this.type,
    required this.backgroundImage,
    required this.products,
    required this.bannerItems,
  });

  int id;
  String title;
  String locale;
  int languageParent;
  // int? position;
  int type;
  String backgroundImage;
  List<Product> products;
  List<BannerItem> bannerItems;


  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Section.fromMap(Map<String, dynamic> json) => Section(
    id: json["id"],
    title: json["title"],
    locale: json["locale"],
    languageParent: json["language_parent"],
    // position: json["position"],
    type: json["type"],
    backgroundImage: json["background_image"],
    products: List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
    bannerItems: List<BannerItem>.from(json["banner_items"].map((x) => BannerItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "locale": locale,
    "language_parent": languageParent,
    // "position": position,
    "type": type,
    "background_image": backgroundImage,
    "products": List<dynamic>.from(products.map((x) => x.toMap())),
    "banner_items": List<dynamic>.from(bannerItems.map((x) => x.toMap())),
  };
}

class BannerItem {
  BannerItem({
    required this.id,
    required this.sectionId,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.productId,
    required this.position,
    required this.image,
    required this.locale,
    required this.languageParent,
    required this.categorySlug,
    required this.subCategorySlug,
    required this.brandSlug,
    required this.productSlug,
  });

  int id;
  int sectionId;
  int? categoryId;
  int? subCategoryId;
  int? brandId;
  int? productId;
  int position;
  String image;
  String locale;
  int languageParent;
  String categorySlug;
  String subCategorySlug;
  String brandSlug;
  String productSlug;

  factory BannerItem.fromJson(String str) => BannerItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BannerItem.fromMap(Map<String, dynamic> json) => BannerItem(
    id: json["id"],
    sectionId: json["section_id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    brandId: json["brand_id"],
    productId: json["product_id"],
    position: json["position"],
    image: json["image"],
    locale: json["locale"],
    languageParent: json["language_parent"],
    categorySlug: json["category_slug"] == null ?"":json["category_slug"],
    subCategorySlug: json["sub_category_slug"] == null ?"":json["sub_category_slug"],
    brandSlug: json["brand_slug"] == null ?"":json["brand_slug"],
    productSlug: json["product_slug"] == null ?"":json["product_slug"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "section_id": sectionId,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "brand_id": brandId,
    "product_id": productId,
    "position": position,
    "image": image,
    "locale": locale,
    "language_parent": languageParent,
    "category_slug": categorySlug,
    "sub_category_slug": subCategorySlug,
    "brand_slug": brandSlug,
    "product_slug": productSlug,
  };
}
