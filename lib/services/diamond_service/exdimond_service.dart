import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/cashout_model.dart';
import 'package:hdlive_latest/models/convert_beansto_diamond_model.dart';
import 'package:hdlive_latest/models/convertcash_model.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/exchangemodel.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

import '../helper_services.dart';

class ExdimondService {

  Future<Exdimondmodel> exchangedimond({String? id}) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    try {
      Map<String, String> payload = {
        "user_id": id ?? '',
        "device_id": deviceInfo?.identifier??""
      };
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(getConverterstoDiamond));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('getConverterstoDiamond == $reply');
      return exdimondmodelFromJson(reply);
    } catch (e) {
      print('Error: $e');
      // Throw an exception to indicate failure
      throw Exception('Failed to exchange diamond: $e');
    }
  }

  // Future<Exdimondmodel> exchangedimond({String? id}) async {
  //   DeviceInfoModel deviceInfo = await HelperServices.getDeviceInfo();
  //   try {
  //     Map payload = {"user_id": id??'', "device_id": deviceInfo.identifier};
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.postUrl(Uri.parse(getConverterstoDiamond));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(payload)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     httpClient.close();
  //     print('getConverterstoDiamond == $reply');
  //     return exdimondmodelFromJson(reply);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<ConvertBeanstoDiamond> BeansToDiamondConvert(
      {String? convertId}) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();

    Map payload = {
      "user_id": i.userId,
      "device_id": deviceInfo?.identifier??"",
      "converter_id": convertId
    };

    print("convert iddd${convertId}");
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(convertBeansToDiamond));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(payload)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    print('convertBeansToDiamond ----- $reply');
    return convertBeanstoDiamondFromJson(reply);
  }

  Future<CashoutModel> cashout({required String id}) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    try {
      Map<String, String> payload = {
        "user_id": id,
        "device_id": deviceInfo?.identifier??""
      };
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(getCashout));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('Response getCashout --- $reply');
      return cashoutModelFromJson(reply);
    } catch (e) {
      print('Error in cashout: $e');
      // Ensure that you throw an exception or handle the error properly
      throw Exception('Failed to process cashout: $e');
    }
  }


  // Future<CashoutModel> cashout({String id}) async {
  //   DeviceInfoModel deviceInfo = await HelperServices.getDeviceInfo();
  //   try {
  //     Map payload = {"user_id": id, "device_id": deviceInfo.identifier};
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.postUrl(
  //         Uri.parse(getCashout));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(payload)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     httpClient.close();
  //     print('responc getCashout --- $reply');
  //     return cashoutModelFromJson(reply);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<ConvertcashModel> cashoutdoller({String? convertId, bankid}) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    var i = await TokenManagerServices().getData();

    Map payload = {
      "user_id": i.userId,
      "device_id": deviceInfo?.identifier??"",
      "bank_id": bankid,
      "cashout_id": convertId,
    };

    print("convert iddd${convertId}");
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse(cashoutRequest));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(payload)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    print('respon cashoutRequest----- $reply');
    return convertcashModelFromJson(reply);
  }
}
