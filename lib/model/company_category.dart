import 'dart:convert';

class CompanyCategoryDecoder {
  CompanyCategoryDecoder({
    required this.companyCategory,
  });

  List<CompanyCategory> companyCategory;

  factory CompanyCategoryDecoder.fromJson(String str) => CompanyCategoryDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CompanyCategoryDecoder.fromMap(Map<String, dynamic> json) => CompanyCategoryDecoder(
    companyCategory: List<CompanyCategory>.from(json["company_category"].map((x) => CompanyCategory.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "company_category": List<dynamic>.from(companyCategory.map((x) => x.toMap())),
  };
}

class CompanyCategory {
  CompanyCategory({
    required this.id,
    required this.title,
    required this.image,
    required this.locale,
    required this.companyCategorySlug,
    required this.slug,
  });

  int id;
  String title;
  String image;
  String locale;
  String companyCategorySlug;
  String slug;

  factory CompanyCategory.fromJson(String str) => CompanyCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CompanyCategory.fromMap(Map<String, dynamic> json) => CompanyCategory(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    locale: json["locale"],
    companyCategorySlug: json["slug"],
    slug: json["_slug"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "locale": locale,
    "slug": companyCategorySlug,
    "_slug": slug,
  };
}
