// To parse this JSON data, do
//
//     final cashoutModel = cashoutModelFromJson(jsonString);

import 'dart:convert';

CashoutModel cashoutModelFromJson(String str) =>
    CashoutModel.fromJson(json.decode(str));

String cashoutModelToJson(CashoutModel data) => json.encode(data.toJson());

class CashoutModel {
  CashoutModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data? data;

  factory CashoutModel.fromJson(Map<String, dynamic> json) => CashoutModel(
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
    this.totalReceivedPearls,
    this.onePearlInDiamond,
    this.cashouts,
    this.isCashoutSet,
    this.isCashoutRequest,
  });

  String? totalReceivedPearls;
  String ?onePearlInDiamond;
  List<Cashout>? cashouts;
  bool? isCashoutSet;
  bool? isCashoutRequest;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalReceivedPearls: json["total_received_pearls"],
        onePearlInDiamond: json["one_pearl_in_diamond"],
        cashouts: List<Cashout>.from(
            json["cashouts"].map((x) => Cashout.fromJson(x))),
        isCashoutSet: json["is_cashout_set"],
        isCashoutRequest: json["is_cashout_request"],
      );

  Map<String, dynamic> toJson() => {
        "total_received_pearls": totalReceivedPearls,
        "one_pearl_in_diamond": onePearlInDiamond,
        "cashouts": List<dynamic>.from(cashouts!.map((x) => x.toJson())),
        "is_cashout_set": isCashoutSet,
        "is_cashout_request": isCashoutRequest,
      };
}

class Cashout {
  Cashout({
    this.cashoutId,
    this.pearls,
    this.valueInDollar,
  });

  String? cashoutId;
  String? pearls;
  String? valueInDollar;

  factory Cashout.fromJson(Map<String, dynamic> json) => Cashout(
        cashoutId: json["cashout_id"],
        pearls: json["pearls"],
        valueInDollar: json["value_in_dollar"],
      );

  Map<String, dynamic> toJson() => {
        "cashout_id": cashoutId,
        "pearls": pearls,
        "value_in_dollar": valueInDollar,
      };
}
