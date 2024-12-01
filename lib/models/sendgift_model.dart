// To parse this JSON data, do
//
//     final sendgiftModel = sendgiftModelFromJson(jsonString);

import 'dart:convert';

SendgiftModel sendgiftModelFromJson(String str) =>
    SendgiftModel.fromJson(json.decode(str));

String sendgiftModelToJson(SendgiftModel data) => json.encode(data.toJson());

class SendgiftModel {
  SendgiftModel({
    required this.error,
    required this.msg,
  });

  bool error;
  String msg;

  factory SendgiftModel.fromJson(Map<String, dynamic> json) => SendgiftModel(
        error: json["error"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
      };
}
