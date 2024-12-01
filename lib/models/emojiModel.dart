import 'dart:convert';

EmojiModel emojiModelFromJson(String str) => EmojiModel.fromJson(json.decode(str));

String emojiModelToJson(EmojiModel data) => json.encode(data.toJson());

class EmojiModel {
  EmojiModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  List<Datum>? data;

  factory EmojiModel.fromJson(Map<String, dynamic> json) => EmojiModel(
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
    this.emojiId,
    this.name,
    this.file,
    this.type,
    this.fileSupport,
    this.status,
    this.createdOn,
    this.updateOn,
  });

  String? emojiId;
  String ?name;
  String ?file;
  String ?type;
  String ?fileSupport;
  String ?status;
  DateTime? createdOn;
  DateTime ?updateOn;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    emojiId: json["emoji_id"],
    name: json["name"],
    file: json["file"],
    type: json["type"],
    fileSupport: json["file_support"],
    status: json["status"],
    createdOn: DateTime.parse(json["created_on"]),
    updateOn: DateTime.parse(json["update_on"]),
  );

  Map<String, dynamic> toJson() => {
    "emoji_id": emojiId,
    "name": name,
    "file": file,
    "type": type,
    "file_support": fileSupport,
    "status": status,
    "created_on": createdOn!.toIso8601String(),
    "update_on": updateOn!.toIso8601String(),
  };
}
