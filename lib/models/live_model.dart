class LiveModel {
  final String? liveId;
  final String? name;
  final String? userId;
  final String ?photoUrl;
  final bool? live;
  final DateTime? startTime;
  final String? liveName;
  final String ?liveType;
  final int? seats;
  final String ?uniqid;
  final String? gender;
  final String? beanscount;
  final String? starcount;
  final String? bio;

  LiveModel(
      {this.live,
      this.uniqid,
      this.name,
      this.userId,
      this.liveId,
      this.startTime,
      this.liveName,
      this.photoUrl,
      this.liveType,
      this.seats,
      this.gender,
      this.bio,
      this.beanscount,
      this.starcount});
}
