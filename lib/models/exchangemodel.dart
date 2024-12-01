// To parse this JSON data, do
//
//     final exdimondmodel = exdimondmodelFromJson(jsonString);

import 'dart:convert';

Exdimondmodel exdimondmodelFromJson(String str) =>
    Exdimondmodel.fromJson(json.decode(str));

String exdimondmodelToJson(Exdimondmodel data) => json.encode(data.toJson());

class Exdimondmodel {
  Exdimondmodel({
    this.error,
    this.msg,
    this.data,
  });

  bool ?error;
  String? msg;
  Data ?data;

  factory Exdimondmodel.fromJson(Map<String, dynamic> json) => Exdimondmodel(
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
    this.converters,
  });

  int? totalReceivedPearls;
  String? onePearlInDiamond;
  List<Converter>? converters;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalReceivedPearls: json["total_received_pearls"],
        onePearlInDiamond: json["one_pearl_in_diamond"],
        converters: List<Converter>.from(
            json["converters"].map((x) => Converter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_received_pearls": totalReceivedPearls,
        "one_pearl_in_diamond": onePearlInDiamond,
        "converters": List<dynamic>.from(converters!.map((x) => x.toJson())),
      };
}

class Converter {
  Converter({
    this.id,
    this.requiredPearls,
    this.valueInDiamond,
  });

  String ?id;
  String? requiredPearls;
  String ?valueInDiamond;

  factory Converter.fromJson(Map<String, dynamic> json) => Converter(
        id: json["id"],
        requiredPearls: json["required_pearls"],
        valueInDiamond: json["value_in_diamond"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "required_pearls": requiredPearls,
        "value_in_diamond": valueInDiamond,
      };
}
