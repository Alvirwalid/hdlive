import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hdlive_latest/models/country_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';

class CountryServices {
  static Future<List<CountryModel>> getAllCountries() async {
    List<CountryModel> list = [];

    try {
      var url = Uri.parse(countryList);

      Dio dio = Dio();
      Response response = await dio.get(
        "http://hdlive.cc/index.php/Apis/universal/getCountries",
        options: Options(contentType: 'application/json'),
      );
      // var response = await http.get(url, headers: body);
      print('responceee================${response.data}');
      if (response.statusCode == 200) {
        var info = jsonDecode(response.data);
        var success = info['error'];
        if (success.toString().contains('false')) {
          var data = info['data'];
          if (data.length > 0) {
            for (var i = 0; i < data.length; i++) {
              list.add(CountryModel(
                id: int.parse(data[i]["id"]),
                // region: data[i]['region'],
                name: data[i]['name'],
                iso: data[i]['std_code'],
                // isoCode: data[i]['isd_code'],
                flag: data[i]['flag'],
                // status: data[i]['status']
              ));
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return list;
  }
}
