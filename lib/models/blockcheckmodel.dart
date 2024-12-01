// To parse this JSON data, do
//
//     final blockCheckModel = blockCheckModelFromJson(jsonString);

import 'dart:convert';

BlockCheckModel blockCheckModelFromJson(String str) => BlockCheckModel.fromJson(json.decode(str));

String blockCheckModelToJson(BlockCheckModel data) => json.encode(data.toJson());

class BlockCheckModel {
  BlockCheckModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory BlockCheckModel.fromJson(Map<String, dynamic> json) => BlockCheckModel(
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
    this.hasBlocked,
  });

  bool? hasBlocked;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    hasBlocked: json["has_blocked"],
  );

  Map<String, dynamic> toJson() => {
    "has_blocked": hasBlocked,
  };
}
