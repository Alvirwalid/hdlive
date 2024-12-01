

import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/services/token_manager_services.dart';

import '../models/emojiModel.dart';
import '../screens/shared/urls.dart';
class EmojiService{
  Future<EmojiModel?> getEmoji() async {
    var i = await TokenManagerServices().getData();
    try {
      Map payload = {
        "user_id": i.userId,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(getEmojiData));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      return emojiModelFromJson(reply);
    } catch (e) {
      print(e);
    }
  }
}