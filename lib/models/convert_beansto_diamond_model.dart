// To parse this JSON data, do
//
//     final convertBeanstoDiamond = convertBeanstoDiamondFromJson(jsonString);

import 'dart:convert';

ConvertBeanstoDiamond convertBeanstoDiamondFromJson(String str) =>
    ConvertBeanstoDiamond.fromJson(json.decode(str));

String convertBeanstoDiamondToJson(ConvertBeanstoDiamond data) =>
    json.encode(data.toJson());

class ConvertBeanstoDiamond {
  ConvertBeanstoDiamond({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory ConvertBeanstoDiamond.fromJson(Map<String, dynamic> json) =>
      ConvertBeanstoDiamond(
        error: json["error"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.walletId,
    this.userId,
    this.stars,
    this.pearls,
    this.diamonds,
    this.receivedStars,
    this.receivedPearls,
    this.receivedDiamonds,
  });

  String? walletId;
  String? userId;
  String? stars;
  String? pearls;
  String? diamonds;
  String? receivedStars;
  String? receivedPearls;
  String ?receivedDiamonds;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        walletId: json["wallet_id"],
        userId: json["user_id"],
        stars: json["stars"],
        pearls: json["pearls"],
        diamonds: json["diamonds"],
        receivedStars: json["received_stars"],
        receivedPearls: json["received_pearls"],
        receivedDiamonds: json["received_diamonds"],
      );

  Map<String, dynamic> toJson() => {
        "wallet_id": walletId,
        "user_id": userId,
        "stars": stars,
        "pearls": pearls,
        "diamonds": diamonds,
        "received_stars": receivedStars,
        "received_pearls": receivedPearls,
        "received_diamonds": receivedDiamonds,
      };
}
