import 'dart:convert';
import 'dart:io';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import '../../models/cashout_model.dart';
import '../helper_services.dart';

class FollowService {
  Future<String> getFollowingList() async {
    try {
      CurrentUserModel user = await TokenManagerServices().getData();
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      Map<String, String> body = {
        "user_id": user.userId!,
        "device_id": deviceInfo?.identifier??"",
        "page_no": "1",
      };

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(FollowingList));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(body)));

      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      if (response.statusCode == 200) {
        print('Following Data === ${reply}');
        return reply; // Return the successful response
      } else {
        // Handle non-200 response status
        print('Failed with status code: ${response.statusCode}');
        return "Error: Failed to fetch data"; // Return a fallback message
      }
    } catch (e) {
      // Catch any exceptions and return an error string
      print('ERROR IN FOLLOWER LIST: $e');
      return "Error: ${e.toString()}"; // Return the error message as a string
    }
  }

  // Future<String> getFollowingList() async {
  //   try {
  //     CurrentUserModel user = await TokenManagerServices().getData();
  //     DeviceInfoModel deviceInfo = await HelperServices.getDeviceInfo();
  //     Map body = {
  //       "user_id": user.userId,
  //       "device_id": deviceInfo.identifier,
  //       "page_no": "1"
  //     };
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.postUrl(
  //         Uri.parse(FollowingList));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(body)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     print("reply$body");
  //     httpClient.close();
  //
  //     if (response.statusCode == 200) {
  //       print('Following Data  === ${reply}');
  //
  //       return reply;
  //     }
  //   } catch (e) {
  //     print('ERROR IN FOLLOWER LST : $e');
  //   }
  // }
  Future<CashoutModel> cashout({required String id}) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    try {
      // Prepare the payload for the request
      Map<String, String> payload = {
        "user_id": id,
        "device_id": deviceInfo?.identifier??""
      };

      // Create an HttpClient and send the POST request
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(getCashout));

      // Set the headers and add the payload as JSON
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));

      // Wait for the response from the server
      HttpClientResponse response = await request.close();

      // Convert the response body to a string
      String reply = await response.transform(utf8.decoder).join();

      // Close the HTTP client
      httpClient.close();

      // Log the response
      print('Response getCashout --- $reply');

      // Return the deserialized CashoutModel from the response
      return cashoutModelFromJson(reply);
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error in cashout: $e');

      // Optionally, throw an exception or handle the error as needed
      throw Exception('Failed to process cashout: $e');
    }
  }


  // Future<String> getFollowerList() async {
  //   try {
  //     CurrentUserModel user = await TokenManagerServices().getData();
  //     DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
  //     Map body = {
  //       "user_id": user.userId,
  //       "device_id": deviceInfo?.identifier,
  //       "page_no": "1"
  //     };
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.postUrl(
  //         Uri.parse(followerList));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(body)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     print("responceeeeeeeeeee==$body");
  //     httpClient.close();
  //
  //     if (response.statusCode == 200) {
  //       print('Following Data  === ${reply}');
  //
  //       return reply;
  //     }
  //   } catch (e) {
  //     print('ERROR IN FOLLOWER LST : $e');
  //
  //   }
  // }
  Future<String> getFollowerList() async {
    try {
      CurrentUserModel user = await TokenManagerServices().getData();
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      Map body = {
        "user_id": user.userId,
        "device_id": deviceInfo?.identifier,
        "page_no": "1"
      };
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(followerList));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(body)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print("response=====$body");
      httpClient.close();

      if (response.statusCode == 200) {
        print('Following Data  === $reply');
        return reply;
      } else {
        // Return an empty string or error message for non-200 responses
        return "Error: Failed to fetch follower list. Status Code: ${response.statusCode}";
      }
    } catch (e) {
      print('ERROR IN FOLLOWER LIST: $e');
      // Return a default error message in case of exception
      return "Error: $e";
    }
  }

  Future<String> getFriendsList() async {
    try {
      CurrentUserModel user = await TokenManagerServices().getData();
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      Map body = {"user_id": user.userId, "device_id": deviceInfo?.identifier??""};

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(friendsList));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(body)));

      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      // Ensure to handle cases where the response is not 200
      if (response.statusCode == 200) {
        print('Following Data  === ${reply}');
        return reply;  // Return the successful response
      } else {
        // Handle non-200 response status
        print('Failed with status code: ${response.statusCode}');
        return "Error: Failed to fetch data";  // Fallback return value in case of failure
      }
    } catch (e) {
      // Catch any exceptions and return an error string
      print('ERROR IN FOLLOWER LIST: $e');
      return "Error: ${e.toString()}";  // Return the error message as a string
    }
  }

  // Future<String> getFriendsList() async {
  //   try {
  //     CurrentUserModel user = await TokenManagerServices().getData();
  //     DeviceInfoModel deviceInfo = await HelperServices.getDeviceInfo();
  //     Map body = {"user_id": user.userId, "device_id": deviceInfo.identifier};
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.postUrl(
  //         Uri.parse(friendsList));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(body)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     print("reply$body");
  //     httpClient.close();
  //
  //     if (response.statusCode == 200) {
  //       print('Following Data  === ${reply}');
  //
  //       return reply;
  //     }
  //   } catch (e) {
  //     print('ERROR IN FOLLOWER LST : $e');
  //   }
  // }
  Future<String> getfolllow(String followid) async {
    try {
      CurrentUserModel user = await TokenManagerServices().getData();
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      Map<String, String> body = {
        "user_id": user.userId!,
        "other_user_id": followid,
      };

      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(followUrl));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(body)));

      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      // Ensure to handle cases where the response is not 200
      if (response.statusCode == 200) {
        print('Following Data === ${reply}');
        return reply;  // Return the successful response
      } else {
        // Handle non-200 response status
        print('Failed with status code: ${response.statusCode}');
        return "Error: Failed to fetch data";  // Fallback return value in case of failure
      }
    } catch (e) {
      // Catch any exceptions and return an error string
      print('ERROR IN FOLLOWER LIST: $e');
      return "Error: ${e.toString()}";  // Return the error message as a string
    }
  }

  // Future<String> getfolllow(followid) async {
  //   try {
  //     CurrentUserModel user = await TokenManagerServices().getData();
  //     DeviceInfoModel deviceInfo = await HelperServices.getDeviceInfo();
  //     Map body = {
  //       "user_id": user.userId,
  //       "other_user_id": followid,
  //     };
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient
  //         .postUrl(Uri.parse(followUrl));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(body)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     print("responceeeeee-----$body");
  //     httpClient.close();
  //
  //     if (response.statusCode == 200) {
  //       print('Following Data  === ${reply}');
  //
  //       return reply;
  //     }
  //   } catch (e) {
  //     print('ERROR IN FOLLOWER LST : $e');
  //   }
  // }
}
