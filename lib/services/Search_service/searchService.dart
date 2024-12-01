import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/Search_model.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

import '../helper_services.dart';

class SearchService {
  Future<SearchModel?> search(String key) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();

    try {
      Map payload = {
        "user_id": i.userId,
        "device_id": deviceInfo?.identifier??"",
        "search_key": key,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(searchProfile));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('searchProfile == $reply');
      return searchModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }
}
