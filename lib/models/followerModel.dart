// To parse this JSON data, do
//
//     final followerModel = followerModelFromJson(jsonString);

import 'dart:convert';

FollowerModel followerModelFromJson(String str) =>
    FollowerModel.fromJson(json.decode(str));

String followerModelToJson(FollowerModel data) => json.encode(data.toJson());

class FollowerModel {
  FollowerModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory FollowerModel.fromJson(Map<String, dynamic> json) => FollowerModel(
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
    this.totalPages,
    this.nextPage,
    this.following,
  });

  int? totalPages;
  int ?nextPage;
  List<Following>? following;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalPages: json["total_pages"],
        nextPage: json["next_page"],
        following: List<Following>.from(
            json["following"].map((x) => Following.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "next_page": nextPage,
        "following": List<dynamic>.from(following!.map((x) => x.toJson())),
      };
}

class Following {
  Following({
    this.userId,
    this.nickName,
    this.name,
    this.image,
    this.runningLevel,
    this.broadcastingLevel,
    this.badge,
    this.badgeCategory,
    this.colorCode,
    this.rlIcon,
    this.blColorCode,
    this.blIcon,
    this.isFollowing,
    this.isFollower,
  });

  String ?userId;
  String ?nickName;
  String ?name;
  String ?image;
  String ?runningLevel;
  String ?broadcastingLevel;
  dynamic badge;
  dynamic badgeCategory;
  String? colorCode;
  String ?rlIcon;
  String ?blColorCode;
  String ?blIcon;
  String ?isFollowing;
  String ?isFollower;

  factory Following.fromJson(Map<String, dynamic> json) => Following(
        userId: json["user_id"],
        nickName: json["nick_name"],
        name: json["name"],
        image: json["image"],
        runningLevel: json["running_level"],
        broadcastingLevel: json["broadcasting_level"],
        badge: json["badge"],
        badgeCategory: json["badge_category"],
        colorCode: json["color_code"],
        rlIcon: json["rl_icon"],
        blColorCode: json["bl_color_code"],
        blIcon: json["bl_icon"],
        isFollowing: json["isFollowing"],
        isFollower: json["isFollower"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nick_name": nickName,
        "name": name,
        "image": image,
        "running_level": runningLevel,
        "broadcasting_level": broadcastingLevel,
        "badge": badge,
        "badge_category": badgeCategory,
        "color_code": colorCode,
        "rl_icon": rlIcon,
        "bl_color_code": blColorCode,
        "bl_icon": blIcon,
        "isFollowing": isFollowing,
        "isFollower": isFollower,
      };
}
