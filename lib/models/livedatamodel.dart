import 'dart:convert';

LiveDataModel liveDataModelFromJson(String str) => LiveDataModel.fromJson(json.decode(str));

String liveDataModelToJson(LiveDataModel data) => json.encode(data.toJson());

class LiveDataModel {
  LiveDataModel({
    this.error,
    this.msg,
    this.data,
  });

  bool? error;
  String? msg;
  Data ?data;

  factory LiveDataModel.fromJson(Map<String, dynamic> json) => LiveDataModel(
    error: json["error"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.totalBaans,
    this.totalAudioDays,
    this.totalAudioHours,
    this.totalVideoDays,
    this.totalVideoHours,
  });

  String? totalBaans;
  String? totalAudioDays;
  String? totalAudioHours;
  String ?totalVideoDays;
  String ?totalVideoHours;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalBaans: json["total_baans"],
    totalAudioDays: json["total_audio_days"],
    totalAudioHours: json["total_audio_hours"],
    totalVideoDays: json["total_video_days"],
    totalVideoHours: json["total_video_hours"],
  );

  Map<String, dynamic> toJson() => {
    "total_baans": totalBaans,
    "total_audio_days": totalAudioDays,
    "total_audio_hours": totalAudioHours,
    "total_video_days": totalVideoDays,
    "total_video_hours": totalVideoHours,
  };
}
