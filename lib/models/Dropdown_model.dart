// To parse this JSON data, do
//
//     final dropdownModel = dropdownModelFromJson(jsonString);

import 'dart:convert';

DropdownModel dropdownModelFromJson(String str) =>
    DropdownModel.fromJson(json.decode(str));

String dropdownModelToJson(DropdownModel data) => json.encode(data.toJson());

class DropdownModel {
  DropdownModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  List<Datum>? data;

  factory DropdownModel.fromJson(Map<String, dynamic> json) => DropdownModel(
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
    this.agencyId,
    this.agencyName,
  });

  String ?agencyId;
  String ?agencyName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        agencyId: json["agency_id"],
        agencyName: json["agency_name"],
      );

  Map<String, dynamic> toJson() => {
        "agency_id": agencyId,
        "agency_name": agencyName,
      };
}
