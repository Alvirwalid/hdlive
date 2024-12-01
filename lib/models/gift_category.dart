// To parse this JSON data, do
//
//     final giftCategory = giftCategoryFromJson(jsonString);

import 'dart:convert';

GiftCategory giftCategoryFromJson(String str) =>
    GiftCategory.fromJson(json.decode(str));

String giftCategoryToJson(GiftCategory data) => json.encode(data.toJson());

class GiftCategory {
  GiftCategory({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  List<Datum>? data;

  factory GiftCategory.fromJson(Map<String, dynamic> json) => GiftCategory(
        error: json["error"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.categoryId,
    this.name,
  });

  String ?categoryId;
  String? name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json["category_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "name": name,
      };
}
