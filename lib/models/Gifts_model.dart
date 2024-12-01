// To parse this JSON data, do
//
//     final giftsmodel = giftsmodelFromJson(jsonString);

import 'dart:convert';

Giftsmodel giftsmodelFromJson(String str) =>
    Giftsmodel.fromJson(json.decode(str));

String giftsmodelToJson(Giftsmodel data) => json.encode(data.toJson());

class Giftsmodel {
  Giftsmodel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  List<Datum>? data;

  factory Giftsmodel.fromJson(Map<String, dynamic> json) => Giftsmodel(
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
    this.giftId,
    this.giftName,
    this.image,
    this.icon,
    this.valueType,
    this.value,
  });

  String? giftId;
  String? giftName;
  String? image;
  String? icon;
  ValueType? valueType;
  String? value;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        giftId: json["gift_id"],
        giftName: json["gift_name"],
        image: json["image"],
        icon: json["icon"],
        valueType: valueTypeValues.map![json["value_type"]],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "gift_id": giftId,
        "gift_name": giftName,
        "image": image,
        "icon": icon,
        "value_type": valueTypeValues.reverse[valueType],
        "value": value,
      };
}

enum ValueType { DIAMONDS, STARS }

final valueTypeValues =
    EnumValues({"diamonds": ValueType.DIAMONDS, "stars": ValueType.STARS});

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
