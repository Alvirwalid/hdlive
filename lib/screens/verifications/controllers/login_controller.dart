import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:hdlive_latest/models/signup_data_model.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/screens/verifications/phone_auth/phone_otp_and_other_info.dart';
import 'package:hdlive_latest/screens/verifications/social_terms_condition.dart';
import 'package:hdlive_latest/services/helper_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:hdlive_latest/services/verification_services.dart';
import 'package:http/http.dart' as http;

import '../phone_auth/phone_signin_otp_confirmation.dart';

class LoginController {
  final BuildContext context;

  LoginController(this.context);
  VerificationServices ver = VerificationServices();

  //phone login
  doPhoneLogin({String? phone}) async {
    floatingLoading(context);
    // int login = await ver.doLogin(type: "phone",password: password,phone: phone);
    List otp = await ver.getPhoneLoginOTP(phone: phone);
    Navigator.of(context).pop();
    if (otp[0] == 1) {
      String otpString = otp[1];
      String realotp = otpString.substring(12, 16);
      Fluttertoast.showToast(
        msg: 'OTP sent to your mobile',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.red,
        fontSize: 11.0,
      );
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   "/landing", (Route<dynamic> route) => false,
      // );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PhoneSigninOTPConfirmation(
                phone: phone??"",
                otp: realotp,
              )));
    } else {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: errorText);
    }
  }

  newPhoneLogin({String? phone})async {
    floatingLoading(context);

    final result = await ver.newPhoneLogin(phone??"");
    print(
        ';RESULT == ${result[1]}'); // if(result.additionalUserInfo.isNewUser){
    if (result[0] == 0) {
      print("new user");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return SocialTermsCondition(
              data: result[1],
            );
          }), (route) => false);

    } else if (result[0] == 1) {
      print('Old User ========');
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/landing",
            (Route<dynamic> route) => false,
      );
    }else{
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: errorText);
    }
  }

  doPhoneLoginConfirmation({String? phone, String? otp}) async {
    floatingLoading(context);
    List login = await ver.doPhoneLogin(phone: phone, otp: otp);
    Navigator.of(context).pop();
    if (login[0] == 1) {
      Fluttertoast.showToast(
        msg: 'Login Successfull',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.red,
        fontSize: 11.0,
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/landing",
        (Route<dynamic> route) => false,
      );
    } else if (login[0] == 0) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: login[1] ?? errorText);
    } else {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: errorText);
    }
  }

  //email login
  doEmailLogin({String? email, String? password}) async {
    floatingLoading(context);

    ///Remove Comment When API Integrate.
    // int login =
    //     await ver.doLogin(type: "email", email: email, password: password);

    DeviceInfoModel? deviceInfo = await HelperServices.getDeviceInfo();
    Map body = {
      "email": email,
      "password": password,
      "device_id": deviceInfo?.identifier,
    };
    print('Email Login BOdy == $body');

    final req = await http.MultipartRequest(
      'POST',
      Uri.parse(universal_login),
    );
    req.fields['email'] = email??"";
    req.fields['password'] = password??"";
    req.fields['device_id'] = deviceInfo?.identifier??"";
    http.Response response = await http.Response.fromStream(
        await req.send()); // print("body ${body}");

    print(response.body);
    if (response.statusCode == 200) {
      var info = json.decode(response.body);
      print('i ==== ${info}');
      var data = info['data'];
      print(info);
      if (info['error'].toString().contains('false')) {
        print('idata ==== ${info['msg']}');
        await TokenManagerServices().saveData(data);
        Fluttertoast.showToast(
          msg: 'Login Successfull',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.red,
          fontSize: 11.0,
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/landing",
          (Route<dynamic> route) => false,
        );
        return [0, data];
      } else {
        Fluttertoast.showToast(
          msg: 'Error Occurred!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.red,
          fontSize: 11.0,
        );
        return [1, data];
      }
    }
    // Navigator.of(context).pop();
    // if (login == 1) {
    //
    // } else if (login == 0) {
    //   CoolAlert.show(
    //       context: context,
    //       type: CoolAlertType.error,
    //       text: "Please enter a valid Email and Password");
    // } else {
    //   CoolAlert.show(
    //       context: context, type: CoolAlertType.error, text: errorText);
    // }
  }

  doPhoneSignup(String phone, String countryCode) async {
    floatingLoading(context);
    print("====================");
    List? otp = await ver.doSignUp(
        type: 'phone', countryCode: countryCode, phone: phone);
    Navigator.of(context).pop();
    if (otp?[0] == 1) {
      String otpString = otp?[1];
      String realotp = otpString.substring(12, 16);

      Fluttertoast.showToast(
        msg: 'OTP sent to your phone',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.red,
        fontSize: 11.0,
      );
      // SignupDataModel data =
      // SignupDataModel(name: name, email: email, password: password);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => PhoneOtpAndOtherInfo(
                    phone: phone,
                    otp: realotp,
                  )),
          (route) => false);
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     "/signup_otp", (Route<dynamic> route) => false,
      //     arguments: data);
    } else if (otp?[0] == 2) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          text: "Phone Already exists");
    } else {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: errorText);
    }
  }

  doEmailSignup(String email, String name, String password) async {
    floatingLoading(context);
    List? otp = await ver.doSignUp(type: 'email', email: email);
    Navigator.of(context).pop();
    if (otp?[0] == 1) {
      Fluttertoast.showToast(
        msg: 'OTP sent to your email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.red,
        fontSize: 11.0,
      );
      SignupDataModel data = SignupDataModel(
          name: name, email: email, password: password, type: 'email');
      Navigator.of(context).pushNamedAndRemoveUntil(
          "/signup_otp", (Route<dynamic> route) => false,
          arguments: data);
    } else if (otp?[0] == 2) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          text: "Email Already exists");
    } else {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: errorText);
    }
  }

  verifySignup(SignupDataModel data) async {
    floatingLoading(context);
    var signup = await ver.verifySignUp(data);
    Navigator.of(context).pop();
    if (signup == null) {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: errorText);
    } else if (signup[0] == 1) {
      Fluttertoast.showToast(
        msg: 'Registration Successfull',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.red,
        fontSize: 11.0,
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/landing",
        (Route<dynamic> route) => false,
      );
    } else if (signup[0] == 2) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: signup[1] ?? errorText);
    } else {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: errorText);
    }
  }

  handleSignupFormError(bool email, bool password) {
    if (email) {
      Fluttertoast.showToast(
        msg: "Email Invalid",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.red,
        fontSize: 11.0,
      );
    } else if (password) {
      Fluttertoast.showToast(
        msg: "Password & Confirm password does not match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.red,
        fontSize: 11.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Please enter all the fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.red,
        fontSize: 11.0,
      );
    }
  }

  signinWithGoogle() async {
    floatingLoading(context);

    final result = await ver.signInWithGoogle();
    var data = await TokenManagerServices().getData();
    print(
        ';RESULT == ${result[1]}'); // if(result.additionalUserInfo.isNewUser){
    if (result[0] == 1) {
      print("new user");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return SocialTermsCondition(
          data: result[1],
        );
      }), (route) => false);
      // TODO:TODO implement API For google
    } else {
      // TODO:TODO implement API For facebook
      print('Old User ========');
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/landing",
        (Route<dynamic> route) => false,
      );
    }
    // }
  }

  signinWithFacebook() async {
    floatingLoading(context);

    final result = await ver.signInWithFacebook();
    print(
        ';RESULT == ${result[0]}'); // if(result.additionalUserInfo.isNewUser){

    if (result[0] == 1) {
      print("new user");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return SocialTermsCondition(
          data: result[1],
        );
      }), (route) => false);
      // TODO:TODO implement API For google
    } else {
      // TODO:TODO implement API For facebook
      print('Old User ========');
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/landing",
        (Route<dynamic> route) => false,
      );
    }
  }
}
