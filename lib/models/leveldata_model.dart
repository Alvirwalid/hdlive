// To parse this JSON data, do
//
//     final leveldatamodel = leveldatamodelFromJson(jsonString);

import 'dart:convert';

Leveldatamodel leveldatamodelFromJson(String str) =>
    Leveldatamodel.fromJson(json.decode(str));

String leveldatamodelToJson(Leveldatamodel data) => json.encode(data.toJson());

class Leveldatamodel {
  Leveldatamodel({
    this.error,
    this.msg,
    this.data,
    this.nextLevel,
    this.currentLevel,
    this.neededXpForLevelup,
    this.sentForNewLevel,
    this.currentLevelName,
    this.currentLevelIcon,
  });

  bool? error;
  String? msg;
  List<Datum> ?data;
  String ?nextLevel;
  String ?currentLevel;
  String ?neededXpForLevelup;
  String ?sentForNewLevel;
  String ?currentLevelName;
  String ?currentLevelIcon;

  factory Leveldatamodel.fromJson(Map<String, dynamic> json) => Leveldatamodel(
        error: json["error"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        nextLevel: json["next_level"],
        currentLevel: json["current_level"],
        neededXpForLevelup: json["needed_xp_for_levelup"],
        sentForNewLevel: json["sent_for_new_level"],
        currentLevelName: json["current_level_name"],
        currentLevelIcon: json["current_level_icon"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_level": nextLevel,
        "current_level": currentLevel,
        "needed_xp_for_levelup": neededXpForLevelup,
        "sent_for_new_level": sentForNewLevel,
        "current_level_name": currentLevelName,
        "current_level_icon": currentLevelIcon,
      };
}

class Datum {
  Datum({
    this.levelId,
    this.levelType,
    this.name,
    this.levelName,
    this.xpNeeded,
    this.icon,
    this.colorCode,
  });

  String? levelId;
  LevelType ?levelType;
  String? name;
  String? levelName;
  String? xpNeeded;
  String ?icon;
  String ?colorCode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        levelId: json["level_id"],
        levelType: levelTypeValues.map![json["level_type"]],
        name: json["name"],
        levelName: json["level_name"],
        xpNeeded: json["xp_needed"],
        icon: json["icon"],
        colorCode: json["color_code"],
      );

  Map<String, dynamic> toJson() => {
        "level_id": levelId,
        "level_type": levelTypeValues.reverse[levelType],
        "name": name,
        "level_name": levelName,
        "xp_needed": xpNeeded,
        "icon": icon,
        "color_code": colorCode,
      };
}

enum LevelType { BROADCASTING_LEVEL }

final levelTypeValues =
    EnumValues({"broadcasting_level": LevelType.BROADCASTING_LEVEL});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
