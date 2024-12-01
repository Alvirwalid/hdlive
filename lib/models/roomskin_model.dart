// To parse this JSON data, do
//
//     final roomskinmodel = roomskinmodelFromJson(jsonString);

import 'dart:convert';

Roomskinmodel roomskinmodelFromJson(String str) =>
    Roomskinmodel.fromJson(json.decode(str));

String roomskinmodelToJson(Roomskinmodel data) => json.encode(data.toJson());

class Roomskinmodel {
  Roomskinmodel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  List<Datum> ?data;

  factory Roomskinmodel.fromJson(Map<String, dynamic> json) => Roomskinmodel(
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
    this.screenId,
    this.image,
    this.type,
    this.useType,
    this.value,
    this.liveDay,
  });

  String? screenId;
  String? image;
  String? type;
  String? useType;
  String? value;
  String? liveDay;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        screenId: json["screen_id"],
        image: json["image"],
        type: json["type"],
        useType: json["use_type"],
        value: json["value"],
        liveDay: json["live_day"],
      );

  Map<String, dynamic> toJson() => {
        "screen_id": screenId,
        "image": image,
        "type": type,
        "use_type": useType,
        "value": value,
        "live_day": liveDay,
      };
}
