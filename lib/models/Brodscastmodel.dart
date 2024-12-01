// To parse this JSON data, do
//
//     final brodcastmodel = brodcastmodelFromJson(jsonString);

import 'dart:convert';

Brodcastmodel brodcastmodelFromJson(String str) =>
    Brodcastmodel.fromJson(json.decode(str));

String brodcastmodelToJson(Brodcastmodel data) => json.encode(data.toJson());

class Brodcastmodel {
  Brodcastmodel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory Brodcastmodel.fromJson(Map<String, dynamic> json) => Brodcastmodel(
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
    this.allowBroadcasting,
  });

  String? allowBroadcasting;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        allowBroadcasting: json["allow_broadcasting"],
      );

  Map<String, dynamic> toJson() => {
        "allow_broadcasting": allowBroadcasting,
      };
}
