import 'dart:convert';

import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/shared_storage_services.dart';
import 'package:http/http.dart' as http;

class FollowFriendServices {
  Future followSomeone({userId}) async {
    try {
      var url = Uri.parse(followSomeoneUrl);
      var token = await LocalStorageHelper.read("token");
      Map payloadMap = {"follow_id": userId};
      var payload = jsonEncode(payloadMap);

      var response = await http.post(url, body: payload, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
    } catch (e) {
      print("Follow Someone Error $e");
    }
  }

  Future<String?> reportUser({reportedUserid}) async {
    try {
      var url = Uri.parse(reportUserUrl);
      var token = await LocalStorageHelper.read("token");
      Map payloadMap = {"reported_user": reportedUserid};
      var payload = jsonEncode(payloadMap);

      var response = await http.post(url, body: payload, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var info = jsonDecode(response.body);
        if (info['success']) {
          return "REPORTED THANKS!";
        }
      }
    } catch (e) {}
  }

  Future<String?> blockSomeone({userId}) async {
    try {
      var url = Uri.parse(blockUserUrl);
      var token = await LocalStorageHelper.read("token");
      Map payloadMap = {"blocked_user_id": userId};
      var payload = jsonEncode(payloadMap);

      var response = await http.post(url, body: payload, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var info = jsonDecode(response.body);
        if (info['success']) {
          return "BLOCKED THANKS!";
        }
      }
    } catch (e) {}
  }
}
