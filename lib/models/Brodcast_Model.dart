// To parse this JSON data, do
//
//     final brodcastTimeModel = brodcastTimeModelFromJson(jsonString);

import 'dart:convert';

BrodcastTimeModel brodcastTimeModelFromJson(String str) =>
    BrodcastTimeModel.fromJson(json.decode(str));

String brodcastTimeModelToJson(BrodcastTimeModel data) =>
    json.encode(data.toJson());

class BrodcastTimeModel {
  BrodcastTimeModel({
    this.error,
    this.msg,
    this.data,
    this.totalVideoDaily,
    this.totalVideoWeek,
    this.totalVideoMonth,
  });

  bool? error;
  String? msg;
  Data ?data;
  String? totalVideoDaily;
  String? totalVideoWeek;
  String? totalVideoMonth;

  factory BrodcastTimeModel.fromJson(Map<String, dynamic> json) =>
      BrodcastTimeModel(
        error: json["error"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
        totalVideoDaily: json["total_video_daily"],
        totalVideoWeek: json["total_video_week"],
        totalVideoMonth: json["total_video_month"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "data": data!.toJson(),
        "total_video_daily": totalVideoDaily,
        "total_video_week": totalVideoWeek,
        "total_video_month": totalVideoMonth,
      };
}

class Data {
  Data({
    this.videoHours,
    this.audioHours,
  });

  OHours? videoHours;
  OHours? audioHours;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        videoHours: OHours.fromJson(json["video_hours"]),
        audioHours: OHours.fromJson(json["audio_hours"]),
      );

  Map<String, dynamic> toJson() => {
        "video_hours": videoHours!.toJson(),
        "audio_hours": audioHours!.toJson(),
      };
}

class OHours {
  OHours({
    this.hours,
  });

  String? hours;

  factory OHours.fromJson(Map<String, dynamic> json) => OHours(
        hours: json["hours"],
      );

  Map<String, dynamic> toJson() => {
        "hours": hours,
      };
}
