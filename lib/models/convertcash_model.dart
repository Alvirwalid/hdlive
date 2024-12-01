// To parse this JSON data, do
//
//     final convertcashModel = convertcashModelFromJson(jsonString);

import 'dart:convert';

ConvertcashModel convertcashModelFromJson(String str) =>
    ConvertcashModel.fromJson(json.decode(str));

String convertcashModelToJson(ConvertcashModel data) =>
    json.encode(data.toJson());

class ConvertcashModel {
  ConvertcashModel({
    this.error,
    this.msg,
  });

  bool? error;
  String? msg;

  factory ConvertcashModel.fromJson(Map<String, dynamic> json) =>
      ConvertcashModel(
        error: json["error"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
      };
}
