import 'dart:convert';
import 'dart:io';
import '../models/Brodcast_Model.dart';
import '../models/Brodscastmodel.dart';
import '../models/livedatamodel.dart';
import '../screens/shared/urls.dart';

class BrodcastService {
  Future<Brodcastmodel?> BrodcastServicee(String id) async {
    //   DeviceInfoModel deviceInfo = await HelperServices.getDeviceInfo();

    try {
      Map payload = {
        "user_id": id,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(checkBroadcastPermission));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      return brodcastmodelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }

  Future<BrodcastTimeModel?> BrodcastTimeService(String id) async {
    //   DeviceInfoModel deviceInfo = await HelperServices.getDeviceInfo();

    try {
      Map payload = {"user_id": id, "type": "12", "report_type": "today"};
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(getBroadcastingTimer));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('BrodcastTimeService========${reply}');
      return brodcastTimeModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }


  Future<LiveDataModel?> getLiveData(String id) async {
    try {
      Map payload = {"user_id": id};
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(getAudiovideoBeans));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('getLiveData========${reply}');
      return liveDataModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }
}
