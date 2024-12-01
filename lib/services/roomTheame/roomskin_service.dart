import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/roomskin_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';

import '../helper_services.dart';

class RoomskinService {
  Future<Roomskinmodel> Roomscreen({userId}) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();

    var url =
        Uri.parse(getAudioScreenData);
    Map payloadMap = {
      "user_id": userId.toString(),
      "device_id": deviceInfo?.identifier??"",
    };

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(url);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(payloadMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("RoomskinService $reply");
    httpClient.close();
    return roomskinmodelFromJson(reply);
  }
}
