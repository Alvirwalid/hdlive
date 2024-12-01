import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hdlive_latest/models/beans_model.dart';
import 'package:hdlive_latest/models/cover_photo_model.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/shared_storage_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import 'helper_services.dart';

class ProfileUpdateServices {
  Future<Covermodel> updateCoverPics(
      File image1, int position, String userid) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    String url = updateCoverPhoto;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    response.fields['user_id'] = userid;
    response.fields['device_id'] = deviceInfo?.identifier??"";
    if (position == 0) {
      response.files
          .add(await http.MultipartFile.fromPath('image', image1.path));
    } else if (position == 1) {
      response.files
          .add(await http.MultipartFile.fromPath('image1', image1.path));
    } else if (position == 2) {
      response.files
          .add(await http.MultipartFile.fromPath('image2', image1.path));
    } else if (position == 3) {
      response.files
          .add(await http.MultipartFile.fromPath('image3', image1.path));
    } else if (position == 4) {
      response.files
          .add(await http.MultipartFile.fromPath('image4', image1.path));
    }

    // position==0? response.files.add(await http.MultipartFile.fromPath('image', image1.path)):;
    // response.files
    //     .add(await http.MultipartFile.fromPath('image1', image2.path));
    // response.files
    //     .add(await http.MultipartFile.fromPath('image2', image3.path));
    // response.files
    //     .add(await http.MultipartFile.fromPath('image3', image4.path));
    // response.files
    //     .add(await http.MultipartFile.fromPath('image4', image5.path));
    http.Response responses =
        await http.Response.fromStream(await response.send());
    var images = jsonDecode(responses.body)['data']['image'];

    preferences.setString('coverpic', images);
    return covermodelFromJson(responses.body);
  }

  Future updateProfilePic(File image, CurrentUserModel user) async {
    try {
      var token = await LocalStorageHelper.read("token");
      String url = updateProfilephoto;
      Dio dio = Dio();
      Map<String, dynamic> payload = {
        "user_id": user.userId,
        "device_id": user.deviceId,
        "image": await MultipartFile.fromFile(image.path,
            filename: path.basename(image.path)),
      };

      FormData formData = FormData.fromMap(payload);
      Response response = await dio.post(
        'http://hdlive.cc/index.php/Apis/universal/uploadProfilePic',
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      print(e);
    }
  }

  Future updateProfileInfos(
    String userid,
    String loginuserid,
    String deviceid,
    String nickname,
    String name,
    String region,
    String dob,
    String gender,
    String countryId,
    String address,
    String bio,
  ) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();

    final queryParameters = {
      "user_id": userid.toString(),
      "login_user_id": loginuserid.toString(),
      "device_id": deviceInfo!.identifier.toString(),
      "nick_name": name.toString(),
      "name": name.toString(),
      "region": region.toString(),
      "dob": dob.toString(),
      "gender": gender.toString(),
      "country_id": countryId.toString(),
      "address": 'address',
      "bio": bio.toString(),
    };
    // var token = await LocalStorageHelper.read("token");

    var url = Uri.parse(updateUserUrl);

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(updateUserUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(queryParameters)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    Map<String, dynamic> map = jsonDecode(reply);
    return map;
  }

  Future<CurrentUserModel?> getUserInfo(id, me) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    // try {
    var url = Uri.parse(singleProfileInfoUrl);
    var meUrl = Uri.parse(myProfileUrl);
    var user = await TokenManagerServices().getData();
    //  var token = await LocalStorageHelper.read("token");
    // var token = user.token;

    String body = jsonEncode({
      "login_user_id": user.userId.toString(),
      "user_id": user.userId.toString(),
      "device_id": deviceInfo!.identifier.toString(),
    });
    Response response;
    if (!me) {
      Dio dio = Dio();
      response = await dio.post(
        myProfileUrl,
        data: body,
        options: Options(contentType: 'application/json'),
      );
    } else {
      Dio dio = Dio();
      response = await dio.post(
        myProfileUrl,
        data: body,
        options: Options(contentType: 'application/json'),
      );
      // response = await http.get(meUrl, headers: {
      //   "login_user_id": user.userId,
      //   "user_id": user.userId,
      //   "device_id": user.deviceId,
      // });
      print("responcee data===${response.data}");
    }

    if (response.statusCode == 200) {
      var info = response.data;
      var success = info['error'];
      if (success.toString().contains('false')) {
        var data = info['data'];
        var dobString = data['dob'];
        // String dobS2 = dobString != null
        //     ? dobString.substring(0, dobString.indexOf('T'))
        //     : null;

        List<GetCoverModel> coverPhotos = [];
        data['cover'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover'], position: 1))
            : null;
        data['cover1'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover1'], position: 2))
            : null;
        data['cover2'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover2'], position: 3))
            : null;
        data['cover3'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover3'], position: 4))
            : null;
        data['cover4'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover4'], position: 5))
            : null;

        // if (data['cover_photo'].length > 0) {
        //   for (var i = 0; i < data['cover_photo'].length; i++) {
        //     var position = data['cover_photo'][i]['position'];
        //     String coverImage = data['cover_photo'][i]['cover_image'];
        //     coverPhotos[position] =
        //         GetCoverModel(position: position, image: coverImage);
        //   }
        //  }

        //List<PreferenceCountryModel> preferenceCountries = [];
        //
        // if (data['preference_countries'].length > 0) {
        //   for (var i = 0; i < data['preference_countries'].length; i++) {
        //     PreferenceCountryModel p = PreferenceCountryModel(
        //       id: data['preference_countries'][i]['id'].toString(),
        //       name: data['preference_countries'][i]['name'],
        //       isoCode: data['preference_countries'][i]['iso_code'],
        //       isdCode: data['preference_countries'][i]['isd_code'],
        //       flagImage: data['preference_countries'][i]['flag_img'],
        //     );
        //     preferenceCountries.add(p);
        //   }
        // }

        // List<TagsModel> tags = [];
        // if (data['tags'].length > 0) {
        //   for (var i = 0; i < data['tags'].length; i++) {
        //     TagsModel t = TagsModel(
        //         id: data['tags'][i]['tag_id'].toString(),
        //         name: data['tags'][i]['name']);
        //     tags.add(t);
        //   }

        // }

        //TokenManagerServices().saveData(data);
        CurrentUserModel user = CurrentUserModel(
          userId: data['user_id'].toString(),
          runningLevel: data['running_level'].toString(),
          broadcastingLevel: data['broadcasting_level'].toString(),
          coinCount: data['stars'].toString(),
          diamondcount: data['diamonds'].toString(),
          beansCount: data['beans'].toString(),
          uniqueId: data['unique_id'].toString(),
          // nickName: data['nick_name'] ?? "N/A",
          name: data['name'] ?? 'N/A',
          // dob: dobS2,
          bio: data['bio'],
          gender: data['gender'],
          phone: data['phone'],
          color_code: data['color_code'],
          bl_color_code: data['bl_color_code'],
          users_verify: data['users_verify'],
          countryId: data['country_id'].toString(),
          countryName: data['country_name'].toString(),
          countryCode: data['country_code'],
          image: data['image'] == false ? null : data['image'],
          email: data['email'],
          coverPhotos: coverPhotos,
          // preferenceCountries: preferenceCountries,
          // tags: tags,
          fanCount: data['fans'],
          followCount: data['followings'],
          friendCount: data['friend'],
          // isFriend: data.containsKey("is_friends") ? data['is_friends'] : false,
          isFollowing:
              data.containsKey("is_following") ? data['is_following'] : false,
        );

        return user;
      }
    }
  }



  Future<CurrentUserModel?> getUserProfile(id) async {
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    String body = jsonEncode({
      "login_user_id": id,
      "user_id": id,
      "device_id": deviceInfo!.identifier.toString(),
    });
    Response response;

      Dio dio = Dio();
      response = await dio.post(
        myProfileUrl,
        data: body,
        options: Options(contentType: 'application/json'),
      );
      print("getUserProfile data===${response.data}");


    if (response.statusCode == 200) {
      var info = response.data;
      var success = info['error'];
      if (success.toString().contains('false')) {
        var data = info['data'];
        var dobString = data['dob'];
        // String dobS2 = dobString != null
        //     ? dobString.substring(0, dobString.indexOf('T'))
        //     : null;

        List<GetCoverModel> coverPhotos = [];
        data['cover'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover'], position: 1))
            : null;
        data['cover1'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover1'], position: 2))
            : null;
        data['cover2'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover2'], position: 3))
            : null;
        data['cover3'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover3'], position: 4))
            : null;
        data['cover4'] != null
            ? coverPhotos.add(GetCoverModel(image: data['cover4'], position: 5))
            : null;


        //TokenManagerServices().saveData(data);
        CurrentUserModel user = CurrentUserModel(
          userId: data['user_id'].toString(),
          runningLevel: data['running_level'].toString(),
          broadcastingLevel: data['broadcasting_level'].toString(),
          coinCount: data['stars'].toString(),
          diamondcount: data['diamonds'].toString(),
          beansCount: data['beans'].toString(),
          uniqueId: data['unique_id'].toString(),
          // nickName: data['nick_name'] ?? "N/A",
          name: data['name'] ?? 'N/A',
          // dob: dobS2,
          bio: data['bio'],
          gender: data['gender'],
          phone: data['phone'],
          color_code: data['color_code'],
          bl_color_code: data['bl_color_code'],
          users_verify: data['users_verify'],
          countryId: data['country_id'].toString(),
          countryName: data['country_name'].toString(),
          countryCode: data['country_code'],
          image: data['image'] == false ? null : data['image'],
          email: data['email'],
          coverPhotos: coverPhotos,
          // preferenceCountries: preferenceCountries,
          // tags: tags,
          fanCount: data['fans'],
          followCount: data['followings'],
          friendCount: data['friend'],
          // isFriend: data.containsKey("is_friends") ? data['is_friends'] : false,
          isFollowing:
          data.containsKey("is_following") ? data['is_following'] : false,
        );

        return user;
      }
    }
  }

  Future<BeansModel> getBeansInfo(String type,String userId) async {
    BeansModel beansModel = new BeansModel();
    Map body1 = {
      "user_id": userId,
      "type": type,
    };

    var headers = {'Content-Type': 'text/plain'};

    var request = http.Request('POST', Uri.parse(getBeans));
    request.body = jsonEncode(body1);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var info = jsonDecode(await response.stream.bytesToString());
      print("getBeansInfo ==> $info");
      var success = info['error'];
      if (success.toString().contains('false')) {
        print(info);
        return beansModel = BeansModel.fromJson(info);
      } else {
        return beansModel;
      }
    } else {
      return beansModel;
    }
  }


}
