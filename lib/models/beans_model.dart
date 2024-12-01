// To parse this JSON data, do
//
//     final beansModel = beansModelFromJson(jsonString);

import 'dart:convert';

BeansModel beansModelFromJson(String str) => BeansModel.fromJson(json.decode(str));

String beansModelToJson(BeansModel data) => json.encode(data.toJson());

class BeansModel {
  BeansModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory BeansModel.fromJson(Map<String, dynamic> json) => BeansModel(
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
    this.totalReceive,
    this.ledger,
  });

  String? totalReceive;
  List<Ledger>? ledger;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalReceive: json["total_receive"],
    ledger: List<Ledger>.from(json["ledger"].map((x) => Ledger.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_receive": totalReceive,
    "ledger": List<dynamic>.from(ledger!.map((x) => x.toJson())),
  };
}

class Ledger {
  Ledger({
    this.userId,
    this.userName,
    this.picture,
    this.quantity,
  });

  String? userId;
  String? userName;
  String? picture;
  String? quantity;

  factory Ledger.fromJson(Map<String, dynamic> json) => Ledger(
    userId: json["user_id"],
    userName: json["user_name"],
    picture: json["picture"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "picture": picture,
    "quantity": quantity,
  };
}
