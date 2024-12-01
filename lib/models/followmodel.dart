// To parse this JSON data, do
//
//     final followModel = followModelFromJson(jsonString);

import 'dart:convert';

FollowModel followModelFromJson(String str) => FollowModel.fromJson(json.decode(str));

String followModelToJson(FollowModel data) => json.encode(data.toJson());

class FollowModel {
  FollowModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory FollowModel.fromJson(Map<String, dynamic> json) => FollowModel(
    error: json["error"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.following,
  });

  bool? following;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    following: json["following"],
  );

  Map<String, dynamic> toJson() => {
    "following": following,
  };
}
