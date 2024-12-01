// To parse this JSON data, do
//
//     final covermodel = covermodelFromJson(jsonString);

import 'dart:convert';

Covermodel covermodelFromJson(String str) =>
    Covermodel.fromJson(json.decode(str));

String covermodelToJson(Covermodel data) => json.encode(data.toJson());

class Covermodel {
  Covermodel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory Covermodel.fromJson(Map<String, dynamic> json) => Covermodel(
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
    this.image,
  });

  String? image;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}

class GetCoverModel {
  GetCoverModel({this.image, this.position});
  final int? position;
  final String? image;
}
