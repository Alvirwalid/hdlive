// To parse this JSON data, do
//
//     final followerModel = followerModelFromJson(jsonString);

import 'dart:convert';

BlockedUserModel followerModelFromJson(String str) =>
    BlockedUserModel.fromJson(json.decode(str));

String followerModelToJson(BlockedUserModel data) => json.encode(data.toJson());

class BlockedUserModel {
  BlockedUserModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) => BlockedUserModel(
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
    this.blockedusers,
  });

  int ?totalPages;
  int? nextPage;
  List<BlockedUsers> ?blockedusers;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalPages: json["total_pages"],
        nextPage: json["next_page"],
    blockedusers: List<BlockedUsers>.from(
            json["blocked_users"].map((x) => BlockedUsers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "next_page": nextPage,
        "blocked_users": List<dynamic>.from(blockedusers!.map((x) => x.toJson())),
      };
}

class BlockedUsers {
  BlockedUsers({
    this.userId,
    this.nickName,
    this.name,
    this.image,
    this.runningLevel,
    this.broadcastingLevel,
    this.badge,
    this.badgeCategory,
  });

  String? userId;
  String? nickName;
  String? name;
  String? image;
  String? runningLevel;
  String ?broadcastingLevel;
  dynamic badge;
  dynamic badgeCategory;

  factory BlockedUsers.fromJson(Map<String, dynamic> json) => BlockedUsers(
        userId: json["user_id"],
        nickName: json["nick_name"],
        name: json["name"],
        image: json["image"],
        runningLevel: json["running_level"],
        broadcastingLevel: json["broadcasting_level"],
        badge: json["badge"],
        badgeCategory: json["badge_category"],

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
      };
}
