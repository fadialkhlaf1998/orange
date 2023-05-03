import 'dart:convert';

import 'package:get/get.dart';
class ProductListDecoder {
  ProductListDecoder({
    required this.products,
  });

  List<Product> products;

  factory ProductListDecoder.fromJson(String str) => ProductListDecoder.fromMap(json.decode(str));

  factory ProductListDecoder.fromMap(Map<String, dynamic> json) => ProductListDecoder(
    products:  List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
  );

}
class ProductDecoder {
  ProductDecoder({
    required this.product,
  });

  Product product;

  factory ProductDecoder.fromJson(String str) => ProductDecoder.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductDecoder.fromMap(Map<String, dynamic> json) => ProductDecoder(
    product: Product.fromMap(json["product_details"]),
  );

  Map<String, dynamic> toMap() => {
    "product_details": product.toMap(),
  };
}

class Product {
  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.ProductSlug,
    required this.slug,
    required this.locale,
    required this.subCategoryId,
    required this.brandId,
    required this.images,
    required this.description,
    required this.metaTitle,
    required this.metaDescription,
    required this.publish,
    required this.oldPrice,
    required this.price,
    required this.availbilty,
    required this.tag,
    required this.languageParent,
    required this.wishlist,
    required this.rate,
    required this.myRate,
    required this.checkout,
    required this.rateReview,
    required this.option,
    required this.colors,
    required this.rams,
    required this.hards,
    required this.additionatlOptions,
    required this.ram,
    required this.hard,
    required this.additionatl_option,
    required this.addetional_price,
    required this.color_id,
    required this.color_image,
    required this.color_name,
    required this.stock,
    required this.selected_option_id,
  });

  int id;
  String title;
  String image;
  String ProductSlug;
  String slug;
  String locale;
  int subCategoryId;
  int brandId;
  String images;
  String description;
  String metaTitle;
  String metaDescription;
  int publish;
  double? oldPrice;
  double price;
  int availbilty;
  String tag;
  int languageParent;
  RxInt wishlist;
  double rate;
  double myRate;
  int checkout;
  List<RateReview> rateReview;
  Option? option;
  List<MyColor> colors;
  List<Ram> rams;
  List<Hard> hards;
  List<AdditionatlOption> additionatlOptions;

  String ram;
  String hard;
  String additionatl_option;
  double addetional_price;
  int stock;
  int color_id;
  int selected_option_id;
  String color_name;
  String color_image;
  
  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"],

    ram: json["ram"]==null?"":json["ram"],
    hard: json["hard"]==null?"":json["hard"],
    additionatl_option: json["additionatl_option"]==null?"":json["additionatl_option"],
    color_name: json["color_name"]==null?"":json["color_name"],
    color_image: json["color_image"]==null?"":json["color_image"],
    addetional_price: json["addetional_price"]==null?0.0:double.parse(json["addetional_price"].toString()),
    stock: json["stock"]==null?0:json["stock"],
    selected_option_id: json["selected_option_id"]==null?-1:json["selected_option_id"],
    color_id: json["color_id"]==null?-1:json["color_id"],
    
    title: json["title"],
    image: json["image"],
    ProductSlug: json["slug"],
    slug: json["_slug"],
    locale: json["locale"],
    subCategoryId: json["sub_category_id"],
    brandId: json["brand_id"],
    images: json["images"],
    description: json["description"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    publish: json["publish"],
    oldPrice: json["old_price"]==null?0.0:double.parse(json["old_price"].toString()),
    price: json["price"]==null?0.0:double.parse(json["price"].toString()),
    availbilty: json["availbilty"],
    tag: json["tag"],
    languageParent: json["language_parent"],
    wishlist: (int.parse(json["wishlist"].toString())).obs,
    rate: json["rate"]==null?0:double.parse(json["rate"].toString()),
    myRate: json["my_rate"]==null?0:double.parse(json["my_rate"].toString()),
    checkout: json["checkout"],
    rateReview: json["rate_review"] == null?<RateReview>[]:List<RateReview>.from(json["rate_review"].map((x) => RateReview.fromMap(x))),
    option: json["option"] == null?null:Option.fromMap(json["option"]),
    colors: json["colors"] == null?<MyColor>[]:List<MyColor>.from(json["colors"].map((x) => MyColor.fromMap(x))),
    rams: json["rams"] == null?<Ram>[]:List<Ram>.from(json["rams"].map((x) => Ram.fromMap(x))),
    hards: json["hards"] == null?<Hard>[]:List<Hard>.from(json["hards"].map((x) => Hard.fromMap(x))),
    additionatlOptions: json["additionatl_options"] == null?<AdditionatlOption>[]:List<AdditionatlOption>.from(json["additionatl_options"].map((x) => AdditionatlOption.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "slug": ProductSlug,
    "_slug": slug,
    "locale": locale,
    "sub_category_id": subCategoryId,
    "brand_id": brandId,
    "images": images,
    "description": description,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "publish": publish,
    "old_price": oldPrice,
    "price": price,
    "availbilty": availbilty,
    "tag": tag,
    "language_parent": languageParent,
    "wishlist": wishlist,
    "rate": rate,
    "my_rate": myRate,
    "checkout": checkout,
    "rate_review": List<dynamic>.from(rateReview.map((x) => x.toMap())),
    "option": option!.toMap(),
    "colors": List<dynamic>.from(colors.map((x) => x.toMap())),
    "ram": List<dynamic>.from(rams.map((x) => x.toMap())),
    "hard": List<dynamic>.from(hards.map((x) => x.toMap())),
    "additionatl_options": List<dynamic>.from(additionatlOptions.map((x) => x.toMap())),
  };
}

class AdditionatlOption {
  AdditionatlOption({
    required this.additionatlOption,
    required this.selected,
  });

  String additionatlOption;
  RxBool selected;

  factory AdditionatlOption.fromJson(String str) => AdditionatlOption.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdditionatlOption.fromMap(Map<String, dynamic> json) => AdditionatlOption(
    additionatlOption: json["additionatl_option"]==null?"":json["additionatl_option"],
    selected: json["selected"]?true.obs:false.obs,
  );

  Map<String, dynamic> toMap() => {
    "additionatl_option": additionatlOption,
    "selected": selected,
  };
}

class MyColor {
  MyColor({
    required this.colorId,
    required this.id,
    required this.title,
    required this.image,
    required this.selected,
  });

  int colorId;
  int id;
  String title;
  String image;
  RxBool selected;

  factory MyColor.fromJson(String str) => MyColor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyColor.fromMap(Map<String, dynamic> json) => MyColor(
    colorId: json["color_id"],
    id: json["id"],
    title: json["title"],
    image: json["image"],
    selected: json["selected"]?true.obs:false.obs,
  );

  Map<String, dynamic> toMap() => {
    "color_id": colorId,
    "id": id,
    "title": title,
    "image": image,
    "selected": selected,
  };
}

class Option {
  Option({
    required this.id,
    required this.hard,
    required this.ram,
    required this.additionatlOption,
    required this.stock,
    required this.addetionalPrice,
    required this.images,
    required this.colorId,
    required this.productId,
    required this.color,
    required this.colorImage,
  });

  int id;
  String hard;
  String ram;
  String additionatlOption;
  int stock;
  int addetionalPrice;
  String images;
  int colorId;
  int productId;
  String color;
  String colorImage;

  factory Option.fromJson(String str) => Option.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Option.fromMap(Map<String, dynamic> json) => Option(
    id: json["id"],
    hard: json["hard"]==null?"":json["hard"],
    ram: json["ram"]==null?"":json["ram"],
    additionatlOption: json["additionatl_option"]==null?"":json["additionatl_option"],
    stock: json["stock"],
    addetionalPrice: json["addetional_price"],
    images: json["images"],
    colorId: json["color_id"]==null?-1:json["color_id"],
    productId: json["product_id"],
    color: json["color"]==null?"":json["color"],
    colorImage: json["color_image"]==null?"":json["color"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "hard": hard,
    "ram": ram,
    "additionatl_option": additionatlOption,
    "stock": stock,
    "addetional_price": addetionalPrice,
    "images": images,
    "color_id": colorId,
    "product_id": productId,
    "color": color,
    "color_image": colorImage,
  };
}

class Hard {
  Hard({
    required this.hard,
    required this.selected,
  });

  String hard;
  RxBool selected;

  factory Hard.fromJson(String str) => Hard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hard.fromMap(Map<String, dynamic> json) => Hard(
    hard: json["hard"]==null?"":json["hard"],
    selected: json["selected"]?true.obs:false.obs,
  );

  Map<String, dynamic> toMap() => {
    "hard": Hard,
    "selected": selected,
  };
}

class Ram {
  Ram({
    required this.ram,
    required this.selected,
  });

  String ram;
  RxBool selected;

  factory Ram.fromJson(String str) => Ram.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ram.fromMap(Map<String, dynamic> json) => Ram(
    ram: json["ram"]==null?"":json["ram"],
    selected: json["selected"]?true.obs:false.obs,
  );

  Map<String, dynamic> toMap() => {
    "ram": ram,
    "selected": selected,
  };
}

class RateReview {
  RateReview({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.rate,
    required this.review,
    required this.name,
    required this.image,
  });

  int id;
  int productId;
  int customerId;
  double rate;
  String review;
  String name;
  String? image;

  factory RateReview.fromJson(String str) => RateReview.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RateReview.fromMap(Map<String, dynamic> json) => RateReview(
    id: json["id"],
    productId: json["product_id"],
    customerId: json["customer_id"],
    rate: json["rate"]==null?0.0:double.parse(json["rate"].toString()),
    review: json["review"]==null?"":json["review"].toString(),
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "product_id": productId,
    "customer_id": customerId,
    "rate": rate,
    "review": review,
    "name": name,
    "image": image,
  };
}
