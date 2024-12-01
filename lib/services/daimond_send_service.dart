import 'dart:convert';
import 'dart:io';

import 'package:hdlive_latest/models/emojiModel.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

class DaimondSendService {
  Future<bool> sendDiamond(String receiverId, String quantity) async {
    var i = await TokenManagerServices().getData();

    try {
      Map payload = {
        "sender_id": i.userId,
        "receiver_id": receiverId,
        "quantity": quantity.replaceAll(",", ""),
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request =
          await httpClient.postUrl(Uri.parse(sendDiamonds));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print(reply);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
