import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/sendgift_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

import 'helper_services.dart';

class GiftService {
  Future<SendgiftModel?> sendGift(value) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();

    try {
      Map payload = {
        "user_id": i.userId.toString(),
        "login_user_id": i.userId.toString(),
        "device_id": deviceInfo!.identifier.toString(),
        "beans_point": value,
      };
      print('payload ==== ${payload}');
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(addUserBeans));
      request.headers.set('content-type', 'text/plain');
      request.add(utf8.encode(json.encode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print("addUserBeans ---- ${reply}");
      return sendgiftModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }
}
