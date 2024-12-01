
import 'package:hdlive/models/preference_country_model.dart';
import 'package:hdlive/models/tags_model.dart';

import 'cover_photo_model.dart';

class CurrentUserModel {
  final String? userId;
  final String? uniqueId;
  final String? nickName;
  String? name;
  final String ?phone;
  final String ?image;
  final String ?email;
  final String ?runningLevel;
  final String ?broadcastingLevel;
  final String? badge;
  final String? badgecategory;
  final String ?loginStatus;
  final String ?deviceId;
  final String ?talent;
  final String ?color_code;
  final String ?bl_color_code;
  final String? users_verify;

  String ?countryId;
  String? countryName;
  final String ?token;
  String? gender;
  final String ?dob;
  String ?bio;
  String ?countryCode;
  final List<GetCoverModel>? coverPhotos;
  final List<PreferenceCountryModel>? preferenceCountries;
  final List<TagsModel>? tags;
  var fanCount;
  var followCount;
  var friendCount;
  final String ?diamondcount;
  final String ?beansCount;
  final String? coinCount;
  bool? isFollowing;
  bool? isFriend;
  CurrentUserModel(
      {this.userId,
      this.coverPhotos,
      this.diamondcount,
      this.beansCount,
      this.coinCount,
      this.tags,
      this.preferenceCountries,
      this.gender,
      this.color_code,
        this.users_verify,
      this.bl_color_code,
      this.bio,
      this.dob,
      this.uniqueId,
      this.nickName,
      this.name,
      this.phone,
      this.image,
      this.email,
      this.runningLevel,
      this.broadcastingLevel,
      this.badge,
      this.badgecategory,
      this.loginStatus,
      this.deviceId,
      this.talent,
      this.countryCode,
      this.countryId,
      this.countryName,
      this.token,
      this.fanCount,
      this.followCount,
      this.friendCount,
      this.isFollowing,
      this.isFriend});
}
