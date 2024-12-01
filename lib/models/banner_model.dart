// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  BannerModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  List<Datum>? data;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
    this.bannerId,
    this.type,
    this.name,
    this.image,
    this.link,
  });

  String? bannerId;
  String? type;
  String? name;
  String? image;
  String? link;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        bannerId: json["banner_id"],
        type: json["type"],
        name: json["name"],
        image: json["image"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "banner_id": bannerId,
        "type": type,
        "name": name,
        "image": image,
        "link": link,
      };
}
