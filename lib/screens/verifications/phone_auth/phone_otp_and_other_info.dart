import 'package:flutter/material.dart';
import 'package:hdlive_latest/models/signup_data_model.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/verifications/phone_auth/linear_social_button_group_phone.dart';
import 'package:hdlive_latest/screens/verifications/sign_up.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PhoneOtpAndOtherInfo extends StatefulWidget {
  final String? phone;
  final String? otp;
  PhoneOtpAndOtherInfo({this.phone, this.otp});
  @override
  _PhoneOtpAndOtherInfoState createState() => _PhoneOtpAndOtherInfoState();
}

class _PhoneOtpAndOtherInfoState extends State<PhoneOtpAndOtherInfo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  TextEditingController _name = TextEditingController();
  bool showPassword = false;
  bool showConPassword = false;
  // TextEditingController _pass = TextEditingController();
  // TextEditingController _conPass = TextEditingController();
  // bool passwordNotMatch = false;
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  void initState() {
    super.initState();
    _pinPutController.text = widget.otp??"";
  }

  @override
  void dispose() {
    _name.dispose();
    _pinPutController.dispose();
    // _pass.dispose();
    // _conPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: height - 20,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFF32408), Color(0xFFA82104)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Stack(
                children: [
                  Positioned(
                    top: height * 0.08,
                    bottom: height * 0.07,
                    left: 0,
                    right: 10,
                    child: Container(
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("images/white_box.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.035,
                    right: width * .07,
                    child: CircleLogo(),
                  ),
                  Positioned(
                    top: height * 0.2,
                    left: 17,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FrontTextInSignup(),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.6,
                                    child: Container(
                                      color: Colors.white,
                                      // margin: const EdgeInsets.all(20.0),
                                      // padding: const EdgeInsets.all(20.0),
                                      child: PinPut(
                                        fieldsCount: 4,
                                        // onSubmit: (String pin) {
                                        //   print(pin);
                                        // },
                                        focusNode: _pinPutFocusNode,
                                        controller: _pinPutController,
                                        submittedFieldDecoration:
                                            _pinPutDecoration.copyWith(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        selectedFieldDecoration:
                                            _pinPutDecoration,
                                        followingFieldDecoration:
                                            _pinPutDecoration.copyWith(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.black.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.6,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: TextFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "";
                                          }

                                          return null;
                                        },
                                        controller: _name,
                                        decoration:
                                            signupInputDecoration.copyWith(
                                                isDense: true,
                                                hintText: 'Name',
                                                prefixIcon: Icon(
                                                  Icons.person,
                                                  color: Color(0xFFBD2823),
                                                ))),
                                  ),

                                  // Container(
                                  //   width:width*0.6,
                                  //   padding:
                                  //   EdgeInsets.symmetric(vertical: 5),
                                  //   child: TextFormField(
                                  //     validator: (val) {
                                  //       if (val.isEmpty) {
                                  //         return "";
                                  //       }
                                  //
                                  //       return null;
                                  //     },
                                  //     controller: _pass,
                                  //     obscureText: !showPassword,
                                  //     decoration: signupInputDecoration.copyWith(
                                  //       isDense: true,
                                  //       hintText: 'Password',
                                  //       suffixIcon: IconButton(
                                  //           onPressed: () {
                                  //             setState(() {
                                  //               showPassword = !showPassword;
                                  //             });
                                  //           },
                                  //           icon: Icon(
                                  //             showPassword
                                  //                 ? Icons.visibility_off
                                  //                 : Icons.visibility,
                                  //             color: Colors.black,
                                  //           )),
                                  //       prefixIcon: Icon(
                                  //         Icons.lock,
                                  //         color: Color(0xFFBD2823),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Container(
                                  //   width:width*0.6,
                                  //   padding:
                                  //   EdgeInsets.symmetric(vertical: 5),
                                  //   child: TextFormField(
                                  //     validator: (val) {
                                  //       if (val.isEmpty) {
                                  //         return "";
                                  //       } else if (val != _pass.text) {
                                  //         passwordNotMatch = true;
                                  //         return "";
                                  //       }
                                  //       passwordNotMatch = false;
                                  //       return null;
                                  //     },
                                  //     controller: _conPass,
                                  //     obscureText: !showConPassword,
                                  //     decoration: signupInputDecoration.copyWith(
                                  //       isDense: true,
                                  //       hintText: 'Confirm Password',
                                  //       suffixIcon: IconButton(
                                  //           onPressed: () {
                                  //             setState(() {
                                  //               showConPassword = !showConPassword;
                                  //             });
                                  //           },
                                  //           icon: Icon(
                                  //             showConPassword
                                  //                 ? Icons.visibility_off
                                  //                 : Icons.visibility,
                                  //             color: Colors.black,
                                  //           )),
                                  //       prefixIcon: Icon(
                                  //         Icons.lock,
                                  //         color: Color(0xFFBD2823),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.025,
                          ),
                          LinearSocialButtonGroupPhone(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.6,
                    left: width * 0.65,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          SignupDataModel data = SignupDataModel(
                              type: 'phone',
                              phone: widget.phone,
                              otp: widget.otp,
                              name: _name.text);

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/terms_condition",
                              (Route<dynamic> route) => false,
                              arguments: data);
                        } else {
                          //  LoginController(context).handleSignupFormError(false, passwordNotMatch);
                        }
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(bottom: 15),
                  //     child: SignInSignUpRichText(
                  //       plainText: "Already have an account?",
                  //       coloredText: "Sign In now !",
                  //       route: "/login",
                  //     ),
                  //   ),
                  //
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
