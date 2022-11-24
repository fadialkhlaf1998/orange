import 'dart:convert';

class BrandDecoder {
  BrandDecoder({
    required this.brands,
  });

  List<Brand> brands;

  factory BrandDecoder.fromJson(String str) => BrandDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BrandDecoder.fromMap(Map<String, dynamic> json) => BrandDecoder(
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "brands": List<dynamic>.from(brands.map((x) => x.toMap())),
  };
}

class Brand {
  Brand({
    required this.id,
    required this.title,
    required this.image,
    required this.brandSlug,
    required this.slug,
    required this.locale,
  });

  int id;
  String title;
  String image;
  String brandSlug;
  String slug;
  String locale;

  factory Brand.fromJson(String str) => Brand.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    brandSlug: json["slug"],
    slug: json["_slug"],
    locale: json["locale"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "slug": brandSlug,
    "_slug": slug,
    "locale": locale,
  };
  isCheckedFilter(List<String> list){
    for(String slug in list){
      if(slug == brandSlug){
        return true;
      }
    }
    return false;
  }
}
