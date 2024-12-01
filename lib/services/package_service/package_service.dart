import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/package_model.dart';

import '../helper_services.dart';

class PackageService {

  Future<Packagemodel> Packageservicec(String id) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    try {
      Map<String, String> payload = {
        "user_id": id,
        "device_id": deviceInfo?.identifier??"",
      };

      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse("http://hdlive.cc/index.php/Apis/homes/rechargePlans"));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));

      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      print('Response: $reply');

      if (response.statusCode == 200) {
        return packagemodelFromJson(reply);
      } else {
        throw Exception('Failed to load packages, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in Packageservicec: $e');
      throw Exception('Failed to load packages: $e');
    }
  }

// Future<Packagemodel> Packageservicec(String id) async {
  //   DeviceInfoModel deviceInfo = await HelperServices.getDeviceInfo();
  //   try {
  //     Map payload = {
  //       "user_id": id,
  //       "device_id": deviceInfo.identifier,
  //     };
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.postUrl(
  //         Uri.parse("http://hdlive.cc/index.php/Apis/homes/rechargePlans"));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(payload)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     httpClient.close();
  //     print('RESPONCEEEEEE======= $reply');
  //     return packagemodelFromJson(reply);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
