import 'dart:convert';

class SearchSuggestionDecoder {
  SearchSuggestionDecoder({
    required this.SearchSuggestions,
  });

  List<SearchSuggestion> SearchSuggestions;

  factory SearchSuggestionDecoder.fromJson(String str) => SearchSuggestionDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchSuggestionDecoder.fromMap(Map<String, dynamic> json) => SearchSuggestionDecoder(
    SearchSuggestions: List<SearchSuggestion>.from(json["search_suggestions"].map((x) => SearchSuggestion.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "SearchSuggestions": List<dynamic>.from(SearchSuggestions.map((x) => x.toMap())),
  };
}

class SearchSuggestion {
  SearchSuggestion({
    required this.slug,
    required this.title,
    required this.image,
  });

  String slug;
  String title;
  String image;

  factory SearchSuggestion.fromJson(String str) => SearchSuggestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchSuggestion.fromMap(Map<String, dynamic> json) => SearchSuggestion(
    slug: json["slug"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "slug": slug,
    "title": title,
  };
}
