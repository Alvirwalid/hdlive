// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  ResponseModel({
    this.error,
    this.msg,
  });

  bool? error;
  String? msg;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    error: json["error"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "msg": msg,
  };
}
