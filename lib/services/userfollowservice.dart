
import 'dart:convert';
import 'dart:io';
import 'package:hdlive_latest/models/blockcheckmodel.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/followmodel.dart';
import 'package:hdlive_latest/models/response_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

import 'helper_services.dart';


class UserFollowService{
  Future<FollowModel?> getFollowFollowing(String Id) async {

    var i = await TokenManagerServices().getData();
    try {
      Map payload = {
        "user_id": i.userId,
        "other_user_id": Id,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(followUrl));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print("getFollowFollowing data===${reply}");
      return followModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }


  Future<FollowModel?> checkFollowStatus(String Id) async {
    var i = await TokenManagerServices().getData();
    try {
      Map payload = {
        "user_id": i.userId,
        "other_user_id": Id,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(checkFollowUrl));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print("checkFollowStatus data===${reply}");
      return followModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }

  Future<FollowModel?> checkFriendStatus(String id) async {
    var i = await TokenManagerServices().getData();
    try {
      Map payload = {
        "user_id": id,
        "other_user_id": i.userId,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(checkFollowUrl));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print("checkFollowStatus data===${reply}");
      return followModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> blockUser(String id,String type ) async{
    var i = await TokenManagerServices().getData();
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    try {
      Map payload = {
        "user_id": i.userId,
        "device_id": deviceInfo?.identifier??"",
        "type": type,
        "blocked": id,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(broadcasterBlockUser));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      print("blockUser ${reply}");
    if(!responseModelFromJson(reply).error!){
      return false;
    }else{
      return true;
    }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> getBlockedList() async {
    try {
      CurrentUserModel user = await TokenManagerServices().getData();
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      Map body = {
        "user_id": user.userId,
        "device_id": deviceInfo?.identifier??"",
        "page_no": "1"
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(getBlockedUsers));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(body)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print("getBlockedList ==$body");
      httpClient.close();

      if (response.statusCode == 200) {
        print('getBlockedList  === ${reply}');
        return reply;
      }
    } catch (e) {
      print('ERROR IN FOLLOWER LST : $e');
    }
  }

  Future<BlockCheckModel?> callCheckBlockUser(String otherId) async {
    try {
      CurrentUserModel user = await TokenManagerServices().getData();
      Map body = {
        "user_id": user.userId,
        "blocked": otherId
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(checkBlockUser));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(body)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print("checkBlockUser ==$body");
      httpClient.close();

      if (response.statusCode == 200) {
        print('checkBlockUser  === ${reply}');
        return blockCheckModelFromJson(reply);
      }
    } catch (e) {
      print('ERROR IN checkBlockUser : $e');
    }
  }


}