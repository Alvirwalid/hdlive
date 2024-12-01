// To parse this JSON data, do
//
//     final getLevelModelbroad = getLevelModelbroadFromJson(jsonString);

import 'dart:convert';

GetLevelModelbroad getLevelModelbroadFromJson(String str) =>
    GetLevelModelbroad.fromJson(json.decode(str));

String getLevelModelbroadToJson(GetLevelModelbroad data) =>
    json.encode(data.toJson());

class GetLevelModelbroad {
  GetLevelModelbroad({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory GetLevelModelbroad.fromJson(Map<String, dynamic> json) =>
      GetLevelModelbroad(
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
    this.currentLevel,
    this.nextLevel,
    this.neededXpForLevelup,
    this.yourTotalRecieveXp,
    this.recieveForNewLevel,
    this.sentfornewlevel,
    this.yourtotalsentxp,
    this.levels,
  });

  String? currentLevel;
  int? nextLevel;
  int? neededXpForLevelup;
  int? yourTotalRecieveXp;
  int? recieveForNewLevel;
  int? yourtotalsentxp;
  int? sentfornewlevel;
  List<Level>? levels;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentLevel: json["current_level"],
        nextLevel: json["next_level"],
        neededXpForLevelup: json["needed_xp_for_levelup"],
        yourTotalRecieveXp: json.containsKey('your_total_receive_xp')
            ? json["your_total_receive_xp"]
            : 0,
        recieveForNewLevel: json.containsKey('recieve_for_new_level')
            ? json["recieve_for_new_level"]
            : 0,
        yourtotalsentxp: json.containsKey('your_total_sent_xp')
            ? json["your_total_sent_xp"]
            : 0,
        sentfornewlevel: json.containsKey('sent_for_new_level')
            ? json["sent_for_new_level"]
            : 0,
        levels: List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_level": currentLevel,
        "next_level": nextLevel,
        "needed_xp_for_levelup": neededXpForLevelup,
        "your_total_recieve_xp": yourTotalRecieveXp,
        "recieve_for_new_level": recieveForNewLevel,
        "your_total_sent_xp": yourtotalsentxp,
        "sent_for_new_level": sentfornewlevel,
        "levels": List<dynamic>.from(levels!.map((x) => x.toJson())),
      };
}

class Level {
  Level({
    this.levelId,
    this.name,
    this.icon,
    this.level,
    this.xpNeeded,
  });

  String? levelId;
  String? name;
  String? icon;
  String? level;
  String? xpNeeded;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        levelId: json["level_id"],
        name: json["name"],
        icon: json["icon"],
        level: json["level"],
        xpNeeded: json["xp_needed"],
      );

  Map<String, dynamic> toJson() => {
        "level_id": levelId,
        "name": name,
        "icon": icon,
        "level": level,
        "xp_needed": xpNeeded,
      };
}
