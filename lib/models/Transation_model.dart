// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    this.error,
    this.msg,
    this.data,
  });

  bool ?error;
  String? msg;
  Data? data;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
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
    this.transactions,
    this.nextPage,
    this.totalPages,
    this.totalCoins,
  });

  List<Transaction>? transactions;
  int? nextPage;
  int ?totalPages;
  int? totalCoins;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalCoins: json["total_coins"],
      );

  Map<String, dynamic> toJson() => {
        "transactions": List<dynamic>.from(transactions!.map((x) => x.toJson())),
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_coins": totalCoins,
      };
}

class Transaction {
  Transaction({
    this.transactionId,
    this.title,
    this.type,
    this.offerType,
    this.value,
    this.addedOn,
  });

  String ?transactionId;
  String ?title;
  String? type;
  String? offerType;
  String? value;
  DateTime? addedOn;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json["transaction_id"],
        title: json["title"],
        type: json["type"],
        offerType: json["offer_type"],
        value: json["value"],
        addedOn: DateTime.parse(json["added_on"]),
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "title": title,
        "type": type,
        "offer_type": offerType,
        "value": value,
        "added_on": addedOn!.toIso8601String(),
      };
}
