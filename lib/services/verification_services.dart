import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/signup_data_model.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/services/helper_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:path/path.dart' as path;

class VerificationServices {
  Future<List> getPhoneLoginOTP({String? phone}) async {
    List returned = [0];
    try {
      var countryCode = "+88"; //::TODO TOBE changed later

      Map data = {"type": "phone", "country_code": countryCode, "phone": phone};

      var payload = jsonEncode(data);
      var url = Uri.parse(loginOtp);
      var response = await http.post(url,
          body: payload, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        try {
          var info = jsonDecode(response.body);
          if (info['success']) {
            return [1, info['message']];
          } else
            throw Error();
        } catch (e) {
          return [2];
        }
      } else
        throw Error();
    } catch (e) {}
    return returned;
  }

  Future doPhoneLogin({String? phone, String? otp}) async {
    try {
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      LocationData? locationData = await HelperServices.getCurrentLocation();
      Map payload = {
        "type": "phone",
        "phone": phone,
        "otp": otp,
        "device_id": deviceInfo?.identifier??"",
        "longitude": locationData?.longitude??"",
        "latitude": locationData?.latitude??"",
      };
      var body = jsonEncode(payload);

      var url = Uri.parse(loginUrl);
      var response = await http
          .post(url, body: body, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        var info = jsonDecode(response.body);
        List returned = [0, errorText];
        if (info['success']) {
          var data = info['data'];
          if (data != null) {
            await TokenManagerServices().saveData(data);
            returned = [1, info['message']];
          } else
            throw Error();
        } else
          returned = [0, info['message']];
        return returned;
      }
    } catch (e) {
      print(e);
    }
  }

  Future newPhoneLogin(String phone) async {
    try {
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      Map payload = {
        "phone": phone,
        "device_id": deviceInfo?.identifier??"",
      };
      var body = jsonEncode(payload);

      Dio dio = Dio();
      Response response = await dio.post(
        getphoneLogin,
        data: body,
        options: Options(contentType: 'application/json'),
      );
      if (response.statusCode == 200) {
        var info = response.data;
        try {
          var data = info['data'];
          await TokenManagerServices().saveData(data);

          if (info['msg']
              .toString()
              .contains('You have registered successfully!')) {
            return [0, data];
          } else {
            return [1, data];
          }
        } catch (e) {
          return [2, info['message']];
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int?> doLogin(
      {String? type, String? email, String? password, String? phone}) async {
    try {
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      LocationData? locationData = await HelperServices.getCurrentLocation();
      String body;
      // if (type == "email") {
      print('Device id  === ${deviceInfo?.identifier??""}');
      Map payload = {
        "type": "email",
        "email": email,
        "device_id": deviceInfo?.identifier??"",
        "password": password,
      };
      body = jsonEncode(payload);
      // } else if (type == "phone") {
      //   Map payload = {
      //     "type": "phone",
      //     "phone": phone,
      //     "device_id": deviceInfo.identifier,
      //     "longitude": locationData.longitude,
      //     "latitude": locationData.latitude
      //   };
      //   body = jsonEncode(payload);
      // }

      var url = Uri.parse(loginUrl);
      var response = await http
          .post(url, body: body, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        try {
          var info = jsonDecode(response.body);
          if (info['success']) {
            var data = info['data'];
            if (data != null) {
              await TokenManagerServices().saveData(data);
              return 1;
            } else
              throw Error();
          } else
            throw Error();
        } catch (e) {
          print(e);
          return 0;
        }
      } else
        throw Error();
    } catch (e) {
      print(e);
    }
  }

  Future<List?> doSignUp(
      {String? type, String? email, String? phone, String? countryCode}) async {
    try {
      var body;

      if (type == 'email') {
        Map payload = {"type": type, "email": email};

        body = payload;
      } else if (type == "phone") {
        Map payload = {
          "type": type,
          "phone": phone,
          "country_code": countryCode
        };
        body = payload;
      }
      Dio dio = Dio();
      Response response = await dio.post(
        signupOtp,
        data: body,
      );
      // var url = Uri.parse(signupOtp);
      // var response = await http.post(
      //   url,
      //   body: body,
      // );
      if (response.statusCode == 200) {
        try {
          var info = jsonDecode(response.data);
          if (info['success']) {
            return [1, info['message']];
          } else
            throw Error();
        } catch (e) {
          return [2];
        }
      } else
        throw Error();
    } catch (e) {
      print(e);
    }
  }

  Future<List?> verifySignUp(SignupDataModel data) async {
    try {
      DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
      LocationData? locationData = await HelperServices.getCurrentLocation();
      Map<String, dynamic> formdataMap = {
        'type': data.type,
        'country_code': data.country != null ? data.country!.isoCode : null,
        'name': data.name,
        'nick_name': data.name,
        'device_id': deviceInfo?.identifier??"",
        'country_id': data.country != null ? data.country!.id : null,
        'otp': data.otp,
        'longitude': locationData?.longitude??"",
        'latitude': locationData?.latitude??"",
        'dob': data.dob,
        'profile_img': data.image != null
            ? await MultipartFile.fromFile(data.image!.path,
                filename: path.basename(data.image!.path))
            : null
      };
      if (data.type == "email") {
        formdataMap['email'] = data.email;
        formdataMap['password'] = data.password;
      } else if (data.type == "phone") {
        formdataMap['phone'] = data.phone;
      }
      FormData formData = FormData.fromMap(formdataMap);
      Dio dio = Dio();
      Response response = await dio.post(
        verifySignup,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 200) {
        var info = response.data;
        try {
          if (info['success']) {
            var data = info['data'];
            await TokenManagerServices().saveData(data);
            return [1];
          } else
            throw Error();
        } catch (e) {
          return [2, info['message']];
        }
      }
    } catch (e) {
      print(e);
    }
  }


  Future<dynamic> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    //type=facebook&account=112766645041552109325&name=Jerry
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    Map body = {
      "type": "gmail",
      "name": result.user?.displayName,
      "email": result.user?.email??"",
      "phone": result.user?.phoneNumber != null
          ? result.user?.phoneNumber??""
          : '0000000000',
      "account": result.user?.uid??"",
      "country_id": "1",
      "device_id": deviceInfo?.identifier??"",
    };
    print("device_id:${body}");

    Dio dio = Dio();
    Response response = await dio.post(
      socialSignin,
      data: body,
      options: Options(contentType: 'application/json'),
    );
    if (response.statusCode == 200) {
      var info = response.data;
      try {
        var data = info['data'];
        await TokenManagerServices().saveData(data);

        if (info['msg']
            .toString()
            .contains('Your account with this email already exists!')) {
          return [0, data];
        } else {
          return [1, data];
        }
      } catch (e) {
        return [2, info['message']];
      }
    }

    // Once signed in, return the UserCredential
  }

  Future<dynamic> signInWithFacebook() async {
    final LoginResult accessToken = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);

    // Create a credential from the access token
    final OAuthCredential credential = FacebookAuthProvider.credential(
      accessToken.accessToken!.token,
    );
    // Once signed in, return the UserCredential
    UserCredential _user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();

    Map body = {
      "type": "facebook",
      "name": _user.user?.displayName??"",
      "email": _user.user?.email??"",
      "phone": _user.user?.phoneNumber != null
          ? _user.user?.phoneNumber??""
          : '0000000000',
      "account": _user.user!.uid??"",
      "country_id": "1",
      "device_id": deviceInfo!.identifier??"",
    };

    Dio dio = Dio();
    Response response = await dio.post(
      socialSignin,
      data: body,
      options: Options(contentType: 'application/json'),
    );
    if (response.statusCode == 200) {
      var info = response.data;
      try {
        var data = info['data'];
        await TokenManagerServices().saveData(data);

        if (info['msg'].toString().contains('Your account already exists!')) {
          return [0, data];
        } else {
          return [1, data];
        }
      } catch (e) {
        return info['message'];
      }
    }
  }
}
