import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/verifications/controllers/login_controller.dart';
import 'package:hdlive_latest/screens/verifications/phone_auth/linear_social_button_group_phone.dart';
import 'package:hdlive_latest/screens/verifications/sign_up.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';

class PhoneSignup extends StatefulWidget {
  @override
  _PhoneSignupState createState() => _PhoneSignupState();
}

class _PhoneSignupState extends State<PhoneSignup> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phone = TextEditingController();
  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  signup() async {
    if (_formKey.currentState!.validate()) {
      LoginController(context).doPhoneSignup(phone.text, "+88");
    }
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
                    left: 0.w,
                    right: 10.w,
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
                    left: 17.w,
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
                                    width: width * 0.56,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter your phone number";
                                          }
                                          return null;
                                        },
                                        // controller: phone,
                                        decoration:
                                            signupInputDecoration.copyWith(
                                          errorStyle:
                                              TextStyle(color: Colors.red),
                                          hintText: 'Phone',
                                          prefixIcon: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.sp),
                                              child: Text(
                                                "+88",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          prefixIconConstraints: BoxConstraints(
                                              minWidth: 0, minHeight: 0),
                                        )),
                                  ),
                                  Container(
                                    height: 20.h,
                                    width: width / 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Divider(
                                          thickness: 1,
                                          height: 2.h,
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
                                          height: 2.h,
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
                          SizedBox(
                            height: height * 0.025,
                          ),
                          PhoneLoginSignupRedirection(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.65,
                    left: width * 0.52,
                    child: ElevatedButton(
                      onPressed: signup,
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
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

class PhoneLoginSignupRedirection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        width: width / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Have an account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/login");
              },
              child: Container(
                  padding: EdgeInsets.all(2.sp),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/sign_up");
              },
              child: Container(
                  padding: EdgeInsets.all(2.sp),
                  child: Text(
                    "Signup",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )),
            )
          ],
        ));
  }
}
