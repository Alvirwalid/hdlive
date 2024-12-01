class ViewerModel {
  final String?  uid;
  final String?  name;
  final String?  countryFlag;
  final String?  photoUrl;
  final String?  gifturl;
  final String ? gender;
  final int?  age;
  final bool ? isMute;
  final bool?  broadcaster_mute;
  final bool?  broadcaster_video_mute;
   bool ? isCamera;
  final  int? status;
  final  int? seatno;
  final  bool? isSpeak;
  ViewerModel(
      {this.uid,
      this.name,
      this.countryFlag,
      this.gifturl,
      this.isMute,
      this.isCamera,
      this.photoUrl,
      this.gender,
      this.age,
      this.status,
      this.seatno,
      this.broadcaster_video_mute,
      this.broadcaster_mute,
      this.isSpeak});
}
