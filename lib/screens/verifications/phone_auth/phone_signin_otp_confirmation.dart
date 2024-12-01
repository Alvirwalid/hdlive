import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/screens/verifications/controllers/login_controller.dart';
import 'package:hdlive_latest/screens/verifications/sign_in.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'linear_social_button_group_phone.dart';

class PhoneSigninOTPConfirmation extends StatefulWidget {
  final String? phone;
  final String? otp;

  PhoneSigninOTPConfirmation({this.phone, this.otp});

  @override
  _PhoneSigninOTPConfirmationState createState() =>
      _PhoneSigninOTPConfirmationState();
}

class _PhoneSigninOTPConfirmationState
    extends State<PhoneSigninOTPConfirmation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
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
                    top: height * 0.26,
                    left: 20,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FrontTextInLogin(),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Container(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.56,
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
                                    height: 20.h,
                                    width: width / 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Divider(
                                          thickness: 1,
                                          height: 2,
                                          color: Colors.grey,
                                        )),
                                        Text(
                                          " OR ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                            child: Divider(
                                          thickness: 1,
                                          height: 2,
                                          color: Colors.grey,
                                        ))
                                      ],
                                    ),
                                  )
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
                          LoginController(context).doPhoneLoginConfirmation(
                              phone: widget.phone, otp: widget.otp);
                        } else {
                          //  LoginController(context).handleSignupFormError(false, passwordNotMatch);
                        }
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      child: Text(
                        "SIGN IN",
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
