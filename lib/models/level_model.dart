// To parse this JSON data, do
//
//     final levelmodel = levelmodelFromJson(jsonString);

import 'dart:convert';

Levelmodel levelmodelFromJson(String str) =>
    Levelmodel.fromJson(json.decode(str));

String levelmodelToJson(Levelmodel data) => json.encode(data.toJson());

class Levelmodel {
  Levelmodel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory Levelmodel.fromJson(Map<String, dynamic> json) => Levelmodel(
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
    this.runningLevel,
    this.broadcastingLevel,
    this.rlColorCode,
    this.rlIcon,
    this.blColorCode,
    this.blIcon,
  });

  String? runningLevel;
  String? broadcastingLevel;
  String? rlColorCode;
  String? rlIcon;
  String ?blColorCode;
  String? blIcon;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        runningLevel: json["running_level"],
        broadcastingLevel: json["broadcasting_level"],
        rlColorCode: json["rl_color_code"],
        rlIcon: json["rl_icon"],
        blColorCode: json["bl_color_code"],
        blIcon: json["bl_icon"],
      );

  Map<String, dynamic> toJson() => {
        "running_level": runningLevel,
        "broadcasting_level": broadcastingLevel,
        "rl_color_code": rlColorCode,
        "rl_icon": rlIcon,
        "bl_color_code": blColorCode,
        "bl_icon": blIcon,
      };
}
