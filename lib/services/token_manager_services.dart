import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/services/shared_storage_services.dart';

class TokenManagerServices {
  String? userId;
  String? uniqueId;
  String? nickName;
  String? name;
  String? phone;
  String? image;
  String? email;
  String? runningLevel;
  String? broadcastingLevel;
  String? badge;
  String? badgecategory;
  String? loginStatus;
  String? deviceId;
  String? talent;
  String? countryId;
  String? countryName;
  String? token;

  saveData(json) async {
    userId = json['user_id'].toString();
    uniqueId = json['unique_id'].toString();
    nickName = json['nick_name'].toString();
    name = json['name'].toString();

    phone = json['phone'].toString();
    image = json['image'] == false ? "" : json['image'].toString();
    email = json['email'].toString();
    runningLevel = json['running_level'].toString();
    broadcastingLevel = json['broadcasting_level'].toString();
    badge = json['badge'].toString();
    badgecategory = json['badgecategory'].toString();
    loginStatus = json['login_status'].toString();
    deviceId = json['device_id'].toString();
    talent = json['talent'].toString();
    countryId = json['country_id'].toString();
    countryName = json['country_name'].toString();

    token = json['token'].toString();
    print('LOCAL STORAGE TOKEN =$token');
    await LocalStorageHelper.save("userId", userId);
    await LocalStorageHelper.save("uniqueId", uniqueId);
    await LocalStorageHelper.save("nickName", nickName);
    await LocalStorageHelper.save("name", name);
    await LocalStorageHelper.save("phone", phone);
    await LocalStorageHelper.save("image", image);
    await LocalStorageHelper.save("email", email);
    await LocalStorageHelper.save("runningLevel", runningLevel);
    await LocalStorageHelper.save("broadcastingLevel", broadcastingLevel);
    await LocalStorageHelper.save("badge", badge);
    await LocalStorageHelper.save("badgecategory", badgecategory);
    await LocalStorageHelper.save("loginStatus", loginStatus);
    await LocalStorageHelper.save("deviceId", deviceId);
    await LocalStorageHelper.save("talent", talent);
    await LocalStorageHelper.save("countryId", countryId);
    await LocalStorageHelper.save("countryName", countryName);
    await LocalStorageHelper.save("token", token);
  }

  Future<CurrentUserModel> getData() async {
    userId = await LocalStorageHelper.read("userId");
    uniqueId = await LocalStorageHelper.read("uniqueId");
    nickName = await LocalStorageHelper.read("nickName");
    name = await LocalStorageHelper.read("name");
    phone = await LocalStorageHelper.read("phone");
    image = await LocalStorageHelper.read("image");
    email = await LocalStorageHelper.read("email");
    runningLevel = await LocalStorageHelper.read("runningLevel");
    broadcastingLevel = await LocalStorageHelper.read("broadcastingLevel");
    badge = await LocalStorageHelper.read("badge");
    badgecategory = await LocalStorageHelper.read("badgecategory");
    loginStatus = await LocalStorageHelper.read("loginStatus");
    deviceId = await LocalStorageHelper.read("deviceId");
    talent = await LocalStorageHelper.read("talent");
    countryId = await LocalStorageHelper.read("countryId");
    countryName = await LocalStorageHelper.read("countryName");
    token = await LocalStorageHelper.read("token");

    CurrentUserModel user = CurrentUserModel(
        token: token??"",
        countryId: countryId??"",
        countryName: countryName??"",
        talent: talent??"",
        deviceId: deviceId??"",
        loginStatus: loginStatus??"",
        badge: badge??"",
        badgecategory: badgecategory??"",
        broadcastingLevel: broadcastingLevel??"",
        runningLevel: runningLevel!,
        email: email!,
        image: image??"",

        phone: phone??"",
        name: name??"",
        nickName: nickName??"",
        uniqueId: uniqueId??"",
        userId: userId??"");

    return user;
  }

  saveAgoraAppId(String appId) async {
    await LocalStorageHelper.save("AgoraAppId", appId);
  }

   Future<String>  getAgoraAppId() async {
    return  await LocalStorageHelper.read("AgoraAppId");
   }
}
