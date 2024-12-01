import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/viewerProfile_Model.dart';
import 'package:hdlive_latest/services/helper_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

class ViewProfileService {
  Future<ViewerprofileModel?> viewprofile(id) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();
    Map paylad = {
      "user_id": id,
      "device_id": deviceInfo?.identifier??"",
    };

    try {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse("http://hdlive.cc/index.php/Apis/homes/viewProfile"));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      request.add(utf8.encode(jsonEncode(paylad)));
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('responceeee == $reply');
      return viewerprofileModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }
}
