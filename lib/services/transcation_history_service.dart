import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/Transation_model.dart';
import 'package:hdlive_latest/models/device_info_model.dart';

import 'helper_services.dart';

class TranscationService {
  Future<TransactionModel?> diamomndTrascation(String id) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();

    try {
      Map payload = {
        "user_id": id,
        "device_id": deviceInfo?.identifier??"",
        "page_no": "1"
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(
          "http://hdlive.cc/index.php/Apis/homes/getTransactionHistory"));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print(' replsy == $reply');
      return transactionModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }
}
