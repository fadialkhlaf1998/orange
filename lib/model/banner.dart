import 'dart:convert';

class BannerDecoder {
  BannerDecoder({
    required this.banners,
  });

  List<MyBanner> banners;

  factory BannerDecoder.fromJson(String str) => BannerDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BannerDecoder.fromMap(Map<String, dynamic> json) => BannerDecoder(
    banners: List<MyBanner>.from(json["banners"].map((x) => MyBanner.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "banners": List<dynamic>.from(banners.map((x) => x.toMap())),
  };
}

class MyBanner {
  MyBanner({
    required this.id,
    required this.image,
    required this.languageParent,
    required this.locale,
    required this.products,
    required this.subCategory,
    required this.category,
    required this.brand,
  });

  int id;
  String image;
  int languageParent;
  String locale;
  List<String> products;
  List<String> subCategory;
  List<String> category;
  List<String> brand;

  factory MyBanner.fromJson(String str) => MyBanner.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyBanner.fromMap(Map<String, dynamic> json) => MyBanner(
    id: json["id"],
    image: json["image"],
    languageParent: json["language_parent"],
    locale: json["locale"],
    products: List<String>.from(json["products"].map((x) => x)),
    subCategory: List<String>.from(json["sub_category"].map((x) => x)),
    category: List<String>.from(json["category"].map((x) => x)),
    brand: List<String>.from(json["brand"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "image": image,
    "language_parent": languageParent,
    "locale": locale,
    "products": List<dynamic>.from(products.map((x) => x)),
    "sub_category": List<dynamic>.from(subCategory.map((x) => x)),
    "category": List<dynamic>.from(category.map((x) => x)),
    "brand": List<dynamic>.from(brand.map((x) => x)),
  };
}
