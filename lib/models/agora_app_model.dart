// To parse this JSON data, do
//
//     final agoraAppModel = agoraAppModelFromJson(jsonString);

import 'dart:convert';

AgoraAppModel agoraAppModelFromJson(String str) => AgoraAppModel.fromJson(json.decode(str));

String agoraAppModelToJson(AgoraAppModel data) => json.encode(data.toJson());

class AgoraAppModel {
  AgoraAppModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory AgoraAppModel.fromJson(Map<String, dynamic> json) => AgoraAppModel(
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
    this.broadcasterId,
    this.broadcasterName,
    this.broadcasterValue,
    this.broadcasterStatus,
  });

  String? broadcasterId;
  String? broadcasterName;
  String? broadcasterValue;
  String? broadcasterStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    broadcasterId: json["broadcaster_id"],
    broadcasterName: json["broadcaster_name"],
    broadcasterValue: json["broadcaster_value"],
    broadcasterStatus: json["broadcaster_status"],
  );

  Map<String, dynamic> toJson() => {
    "broadcaster_id": broadcasterId,
    "broadcaster_name": broadcasterName,
    "broadcaster_value": broadcasterValue,
    "broadcaster_status": broadcasterStatus,
  };
}
