// To parse this JSON data, do
//
//     final packagemodel = packagemodelFromJson(jsonString);

import 'dart:convert';

Packagemodel packagemodelFromJson(String str) =>
    Packagemodel.fromJson(json.decode(str));

String packagemodelToJson(Packagemodel data) => json.encode(data.toJson());

class Packagemodel {
  Packagemodel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory Packagemodel.fromJson(Map<String, dynamic> json) => Packagemodel(
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
    this.plans,
    this.availableDiamonds,
  });

  Plans? plans;
  String? availableDiamonds;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        plans: Plans.fromJson(json["plans"]),
        availableDiamonds: json["available_diamonds"],
      );

  Map<String, dynamic> toJson() => {
        "plans": plans!.toJson(),
        "available_diamonds": availableDiamonds,
      };
}

class Plans {
  Plans({
    this.paypal,
    this.google,
    this.bank,
  });

  List<Bank>? paypal;
  List<Bank>? google;
  List<Bank>? bank;

  factory Plans.fromJson(Map<String, dynamic> json) => Plans(
        paypal: List<Bank>.from(json["paypal"].map((x) => Bank.fromJson(x))),
        google: List<Bank>.from(json["google"].map((x) => Bank.fromJson(x))),
        bank: List<Bank>.from(json["bank"].map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "paypal": List<dynamic>.from(paypal!.map((x) => x.toJson())),
        "google": List<dynamic>.from(google!.map((x) => x.toJson())),
        "bank": List<dynamic>.from(bank!.map((x) => x.toJson())),
      };
}

class Bank {
  Bank({
    this.planId,
    this.planName,
    this.price,
    this.type,
    this.diamonds,
    this.extra,
    this.image,
  });

  String? planId;
  String ?planName;
  String? price;
  Type? type;
  String? diamonds;
  String? extra;
  String? image;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        planId: json["plan_id"],
        planName: json["plan_name"],
        price: json["price"],
        type: typeValues.map?[json["type"]],
        diamonds: json["diamonds"],
        extra: json["extra"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "plan_name": planName,
        "price": price,
        "type": typeValues.reverse[type],
        "diamonds": diamonds,
        "extra": extra,
        "image": image,
      };
}

enum Type { DIAMONDS }

final typeValues = EnumValues({"diamonds": Type.DIAMONDS});

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
