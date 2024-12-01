import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/Dropdown_model.dart';
import 'package:hdlive_latest/models/device_info_model.dart';

import 'helper_services.dart';

class DropdownService {
  Future<DropdownModel?> agencyname() async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();

    try {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse("http://hdlive.cc/index.php/Apis/universal/getAgency"));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print(' replsy == $reply');
      return dropdownModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }
}
