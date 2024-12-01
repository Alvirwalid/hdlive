import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/level_model.dart';
import 'package:hdlive_latest/models/leveldata_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

import '../models/checklevel_model.dart';
import 'helper_services.dart';

class LevelService {
  Future<Levelmodel?> level() async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();

    try {
      Map payload = {
        "user_id": i.userId,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request =
          await httpClient.postUrl(Uri.parse(checkLevel));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      return levelmodelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }

  Future<Levelmodel?> getUserLevel(String Id) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();

    try {
      Map payload = {
        "user_id": Id,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request =
          await httpClient.postUrl(Uri.parse(checkLevel));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('getUserLevel======${reply}');
      return levelmodelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }

  Future<Leveldatamodel> runniglevel() async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();

    Map payload = {"level_type": "run", "user_id": i.userId};
    print('payloadddd====$payload');
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(getLevelsMaster));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(payload)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    print('Runniglevel ==================${reply}');
    return leveldatamodelFromJson(reply);
  }

  Future<Leveldatamodel?> broadLevel() async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();

    try {
      Map payload = {"level_type": "broad", "user_id": i.userId};
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request =
          await httpClient.postUrl(Uri.parse(getLevelsMaster));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      return leveldatamodelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }

  Future<GetLevelModelbroad?> getlevel(type) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();
    String reply;
    Map payload = {"user_id": i.userId, "level_type": type};

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(getLevels));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(payload)));
    HttpClientResponse response = await request.close();
    reply = await response.transform(utf8.decoder).join();
    httpClient.close();

    var data = jsonDecode(reply);

    if (data['error'] == false) {
      print("getlevel -- ${reply}");
      return getLevelModelbroadFromJson(reply);
    }
  }
}
