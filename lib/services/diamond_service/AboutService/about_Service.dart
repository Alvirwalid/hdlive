import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/Aboutus_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';

class AboutSevice {

  Future<AboutusModel> aboutus({String? id}) async {
    try {
      Map<String, String> payload = {"site_information": "$id"};
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(getSiteInfo));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('reply == $reply');
      return aboutusModelFromJson(reply);
    } catch (e) {
      print('Error: $e');
      // Handle the error case by returning a default AboutusModel or throwing an error
      throw Exception('Failed to fetch about us data: $e');
    }
  }

// Future<AboutusModel> aboutus({String? id}) async {
  //   try {
  //     Map payload = {"site_information": "$id"};
  //     HttpClient httpClient = new HttpClient();
  //     HttpClientRequest request = await httpClient.postUrl(
  //         Uri.parse(getSiteInfo));
  //     request.headers.set('content-type', 'application/json');
  //     request.add(utf8.encode(jsonEncode(payload)));
  //     HttpClientResponse response = await request.close();
  //     String reply = await response.transform(utf8.decoder).join();
  //     httpClient.close();
  //     print(' replsy == $reply');
  //     return aboutusModelFromJson(reply);
  //   } catch (e) {
  //     print(e);
  //   }
  // }


}
