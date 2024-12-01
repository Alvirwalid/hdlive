// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) =>
    SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  SearchModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  List<Datum> ?data;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
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
    this.userId,
    this.uniqueId,
    this.nickName,
    this.name,
    this.image,
    this.isFollowing,
  });

  String? userId;
  String? uniqueId;
  String? nickName;
  String? name;
  String? image;
  bool? isFollowing;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        uniqueId: json["unique_id"],
        nickName: json["nick_name"],
        name: json["name"],
        image: json["image"],
        isFollowing: json["is_following"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "unique_id": uniqueId,
        "nick_name": nickName,
        "name": name,
        "image": image,
        "is_following": isFollowing,
      };
}
