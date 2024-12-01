class ChatModel{
  final String? userId;
  final String? name;
  final DateTime? time;
  final String? message;
  final String? defaultMessageId;
  String? runningLevel;
  String? rlColorCode;
  String? rlIcon;
  String? giftUrl;

  ChatModel({this.userId,this.name,this.time,this.message,this.defaultMessageId,this.runningLevel,this.rlColorCode,this.rlIcon,this.giftUrl});
}