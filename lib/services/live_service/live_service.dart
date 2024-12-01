import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hdlive_latest/models/Gifts_model.dart';
import 'package:hdlive_latest/models/agora_app_model.dart';
import 'package:hdlive_latest/models/banner_model.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/gift_category.dart';
import 'package:hdlive_latest/models/response_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';

import '../../models/gift_category.dart';
import '../../screens/shared/urls.dart';
import '../helper_services.dart';
import '../token_manager_services.dart';

class LiveService {


  Future<GiftCategory> giftCategory() async {
    try {
      Map<String, dynamic> body = Map();
      Dio dio = Dio();
      Response response = await dio.get(
        giftCategoryAPI,
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode == 200) {
        // Return the parsed GiftCategory if the response is successful
        return GiftCategory.fromJson(json.decode(response.data));
      } else {
        // Handle the case where the status code is not 200
        print('Failed to load gift categories: ${response.statusCode}');
        throw Exception('Failed to load gift categories');
      }
    } catch (e) {
      // Handle any errors (network issues, JSON parsing errors, etc.)
      print('Error fetching gift categories: $e');
      // Return a fallback value or rethrow the error based on your requirements
      return GiftCategory(); // Assuming GiftCategory has a default constructor
    }
  }


  // Future<GiftCategory> giftCategory() async {
  //   Map<String, dynamic> body = Map();
  //   Dio dio = Dio();
  //   Response response = await dio.get(giftCategoryAPI, options: Options(contentType: 'application/json'),);
  //
  //   if (response.statusCode == 200) {
  //     return GiftCategory.fromJson(json.decode(response.data));
  //   }
  // }

  Future<Giftsmodel> fetchallGift({String? catid, userid}) async {
    // try {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();

    Map body = {
      "user_id": userid,
      "device_id": deviceInfo?.identifier??"",
      "category_id": catid,
    };
    // final response = await http.post(Uri.parse("http://hdlive.cc/index.php/Apis/homes/gifts"), body: body);

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient
        .postUrl(Uri.parse(gifts));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return giftsmodelFromJson(reply);
  }

  Future<BannerModel> getBanner() async {
    try {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(getBannersAPI));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      // Ensure that the response is valid before proceeding
      if (response.statusCode == 200) {
        return bannerModelFromJson(reply); // Parse and return BannerModel
      } else {
        print('Error: Failed to load banner. Status Code: ${response.statusCode}');
        throw Exception('Failed to load banner');
      }
    } catch (e) {
      print('Error in Banner fetching: $e');
      // Return a default BannerModel object if there's an error
      // Or throw an exception if that's what your app logic requires
      throw Exception('Failed to fetch banner: $e');
    }
  }


  // Future<BannerModel> getBanner() async {
  //    try {
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.getUrl(
  //         Uri.parse(getBannersAPI));
  //     //  request.headers.set('content-type', 'application/json');
  //     // request.add(utf8.encode(jsonEncode(body)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     httpClient.close();
  //
  //     return bannerModelFromJson(reply);
  //   } catch (e) {
  //     print('Error ion Banner === $e');
  //   }
  // }

  Future<bool> isTimeLiveCall(String callType, String isCall) async {
    var i = await TokenManagerServices().getData();
    try {
      Map payload = {
        "type": isCall,
        "user_id": i.userId,
        "broadcasting_type": callType,
      };

      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(startBroadcasting));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print("isTimeLiveCall data===${reply}");

      // Here you can parse the response and determine if it's a valid live call
      // For example, you might check if `reply` contains an error or success message.
      if (response.statusCode == 200) {
        // Parse the response and return true or false based on the actual data
        // (You can add your logic here, like checking if 'reply' indicates success)
        // if (!responseModelFromJson(reply).error) {
        //   return false;
        // } else {
        return true;  // Assuming the call was successful, return true
        // }
      } else {
        // If the status code is not 200, return false or handle accordingly
        return false;
      }
    } catch (e) {
      print('Error in isTimeLiveCall: $e');
      // Handle error and return false in case of failure
      return false;
    }
  }

  // Future<bool> isTimeLiveCall(String callType,String isCall) async {
  //   var i = await TokenManagerServices().getData();
  //   try {
  //     Map payload = {
  //       "type": isCall,
  //       "user_id": i.userId,
  //       "broadcasting_type": callType,
  //     };
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.postUrl(Uri.parse(startBroadcasting));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(payload)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     httpClient.close();
  //     print("isTimeLiveCall data===${reply}");
  //
  //     // if(!responseModelFromJson(reply).error){
  //     //   return false;
  //     // }else{
  //     //   return true;
  //     // }
  //   } catch (e) {
  //     print(e);
  //     // return true;
  //   }
  // }

  getAgoraId() async {
    var i = await TokenManagerServices().getData();
    try {
      Map payload = {
        "user_id": i.userId,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(broadcaster_info));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      if(!agoraAppModelFromJson(reply).error!){
        print('getAgoraId === ${agoraAppModelFromJson(reply).data!.broadcasterValue}');
        await TokenManagerServices().saveAgoraAppId(agoraAppModelFromJson(reply).data!.broadcasterValue!);
      }else{
        await TokenManagerServices().saveAgoraAppId("");
      }

    } catch (e) {
      print('Error getAgoraId === $e');
      await TokenManagerServices().saveAgoraAppId("");
    }
  }



  Future<bool> getLoginStatus() async {
    var i = await TokenManagerServices().getData();
    try {
      Map payload = {
        "user_id": i.userId,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(checkLoginStatusNew));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      if(responseModelFromJson(reply).error!){
        return true;
      }else{
        return false;
      }

    } catch (e) {
      print('Error getLoginStatus === $e');
      return true;
    }
  }


}
