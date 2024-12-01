import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/models/signup_data_model.dart';
import 'package:hdlive_latest/screens/verifications/sign_up.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/signup_singin_rich_text.dart';
import 'package:pinput/pin_put/pin_put.dart';

class SingupWithOTP extends StatefulWidget {
  final SignupDataModel? data;
  SingupWithOTP({this.data});
  @override
  _SingupWithOTPState createState() => _SingupWithOTPState();
}

class _SingupWithOTPState extends State<SingupWithOTP> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  void dispose() {
    _pinPutController.dispose();
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
                    bottom: height * 0.1,
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
                    top: height * 0.3,
                    left: 20,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FrontTextInSignup(),
                          SizedBox(
                            height: height * 0.05,
                          ),
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
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                selectedFieldDecoration: _pinPutDecoration,
                                followingFieldDecoration:
                                    _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.025,
                          ),
                          //  LinearSocialButtonGroup(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.55,
                    left: width * 0.68,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pinPutController.text.length == 4) {
                          widget.data?.otp = _pinPutController.text;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/terms_condition",
                              (Route<dynamic> route) => false,
                              arguments: widget.data);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please enter a 4 digit OTP",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.red,
                            fontSize: 11.0,
                          );
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
                        "ENTER OTP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SignInSignUpRichText(
                        plainText: "Already have an account?",
                        coloredText: "Sign In now !",
                        route: "/login",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FrontTextInLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's Sign In",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            "Welcome Back, you've been missed",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          )
        ],
      ),
    );
  }
}
