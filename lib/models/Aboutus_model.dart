// To parse this JSON data, do
//
//     final aboutusModel = aboutusModelFromJson(jsonString);

import 'dart:convert';

AboutusModel aboutusModelFromJson(String str) =>
    AboutusModel.fromJson(json.decode(str));

String aboutusModelToJson(AboutusModel data) => json.encode(data.toJson());

class AboutusModel {
  AboutusModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  List<Datum>? data;

  factory AboutusModel.fromJson(Map<String, dynamic> json) => AboutusModel(
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
    this.id,
    this.image,
    this.name,
    this.slug,
    this.description,
    this.status,
    this.isDelete,
  });

  String? id;
  String? image;
  String? name;
  String? slug;
  String? description;
  String? status;
  String? isDelete;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        status: json["status"],
        isDelete: json["is_delete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "slug": slug,
        "description": description,
        "status": status,
        "is_delete": isDelete,
      };
}
