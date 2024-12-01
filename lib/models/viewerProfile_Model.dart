// To parse this JSON data, do
//
//     final viewerprofileModel = viewerprofileModelFromJson(jsonString);

import 'dart:convert';

ViewerprofileModel viewerprofileModelFromJson(String str) =>
    ViewerprofileModel.fromJson(json.decode(str));

String viewerprofileModelToJson(ViewerprofileModel data) =>
    json.encode(data.toJson());

class ViewerprofileModel {
  ViewerprofileModel({
    this.error,
    this.msg,
    this.data,
  });

  bool ?error;
  String? msg;
  Data? data;

  factory ViewerprofileModel.fromJson(Map<String, dynamic> json) =>
      ViewerprofileModel(
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
    this.name,
    this.countryCode,
    this.phone,
    this.email,
    this.designation,
    this.organization,
    this.gender,
    this.profileHashtag,
    this.dob,
    this.countryId,
    this.region,
    this.bio,
    this.tag,
  });

  String ?name;
  String? countryCode;
  String? phone;
  String? email;
  String ?designation;
  String ?organization;
  String ?gender;
  String? profileHashtag;
  DateTime? dob;
  String? countryId;
  String ?region;
  String ?bio;
  String ?tag;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        countryCode: json["country_code"],
        phone: json["phone"],
        email: json["email"],
        designation: json["designation"],
        organization: json["organization"],
        gender: json["gender"],
        profileHashtag: json["profile_hashtag"],
        dob: DateTime.parse(json["dob"]),
        countryId: json["country_id"],
        region: json["region"],
        bio: json["bio"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "country_code": countryCode,
        "phone": phone,
        "email": email,
        "designation": designation,
        "organization": organization,
        "gender": gender,
        "profile_hashtag": profileHashtag,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "country_id": countryId,
        "region": region,
        "bio": bio,
        "tag": tag,
      };
}
