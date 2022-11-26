import 'dart:convert';

class LineItemsDecoder {
  LineItemsDecoder({
    required this.lineItems,
  });

  List<LineItem> lineItems;

  factory LineItemsDecoder.fromJson(String str) => LineItemsDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LineItemsDecoder.fromMap(Map<String, dynamic> json) => LineItemsDecoder(
    lineItems: List<LineItem>.from(json["line_items"].map((x) => LineItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "line_items": List<dynamic>.from(lineItems.map((x) => x.toMap())),
  };
}

class LineItem {
  LineItem({
    required this.id,
    required this.orderId,
    required this.optionId,
    required this.count,
    required this.priceOnePiece,
    required this.returned,
    required this.hard,
    required this.ram,
    required this.additionatlOption,
    required this.stock,
    required this.addetionalPrice,
    required this.images,
    required this.colorId,
    required this.productId,
    required this.title,
    required this.image,
    required this.lineItemSlug,
    required this.slug,
    required this.locale,
    required this.subCategoryId,
    required this.brandId,
    required this.description,
    required this.metaTitle,
    required this.metaDescription,
    required this.publish,
    required this.oldPrice,
    required this.price,
    required this.availbilty,
    required this.tag,
    required this.languageParent,
    required this.def,
    required this.color,
    required this.categoryId,
    required this.lineItemsId,
    required this.colorImage,
  });

  int id;
  int orderId;
  int optionId;
  int count;
  double priceOnePiece;
  int returned;
  String hard;
  String ram;
  String additionatlOption;
  int stock;
  double addetionalPrice;
  String images;
  int colorId;
  int productId;
  String title;
  String image;
  String lineItemSlug;
  String slug;
  String locale;
  int subCategoryId;
  int brandId;
  String description;
  String metaTitle;
  String metaDescription;
  int publish;
  double? oldPrice;
  double price;
  int availbilty;
  String tag;
  int languageParent;
  int def;
  String color;
  String colorImage;
  int categoryId;
  int lineItemsId;

  factory LineItem.fromJson(String str) => LineItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LineItem.fromMap(Map<String, dynamic> json) => LineItem(
    id: json["id"],
    orderId: json["order_id"],
    optionId: json["option_id"],
    count: json["count"],
    priceOnePiece: double.parse(json["price_one_piece"].toString()),
    returned: json["returned"],
    hard: json["hard"]==null?"":json["hard"],
    ram: json["ram"]==null?"":json["ram"],
    additionatlOption: json["additionatl_option"]==null?"":json["additionatl_option"],
    stock: json["stock"],
    addetionalPrice: json["addetional_price"]==null ?0.0:double.parse(json["addetional_price"].toString()),
    images: json["images"],
    colorId: json["color_id"]==null?-1:json["color_id"],
    productId: json["product_id"],
    title: json["title"],
    image: json["image"],
    lineItemSlug: json["slug"],
    slug: json["_slug"],
    locale: json["locale"],
    subCategoryId: json["sub_category_id"],
    brandId: json["brand_id"],
    description: json["description"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    publish: json["publish"],
    oldPrice:json["old_price"] == null? null: double.parse(json["old_price"].toString()),
    price:double.parse(json["price"].toString()),
    availbilty: json["availbilty"],
    tag: json["tag"],
    languageParent: json["language_parent"],
    def: json["def"],
    color: json["color"]==null?"":json["color"],
    categoryId: json["category_id"],
    lineItemsId: json["line_items_id"],
    colorImage: json["color_image"]==null?"":json["color_image"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "order_id": orderId,
    "option_id": optionId,
    "count": count,
    "price_one_piece": priceOnePiece,
    "returned": returned,
    "hard": hard,
    "ram": ram,
    "additionatl_option": additionatlOption,
    "stock": stock,
    "addetional_price": addetionalPrice,
    "images": images,
    "color_id": colorId,
    "product_id": productId,
    "title": title,
    "image": image,
    "slug": lineItemSlug,
    "_slug": slug,
    "locale": locale,
    "sub_category_id": subCategoryId,
    "brand_id": brandId,
    "description": description,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "publish": publish,
    "old_price": oldPrice,
    "price": price,
    "availbilty": availbilty,
    "tag": tag,
    "language_parent": languageParent,
    "def": def,
    "color": color,
    "category_id": categoryId,
    "line_items_id": lineItemsId,
  };
}
