import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/verifications/controllers/login_controller.dart';
import 'package:hdlive_latest/screens/verifications/phone_auth/linear_social_button_group.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/signup_singin_rich_text.dart';

class NewSignupDesign extends StatefulWidget {
  @override
  _NewSignupDesignState createState() => _NewSignupDesignState();
}

class _NewSignupDesignState extends State<NewSignupDesign> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _conPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool showConPassword = false;

  bool emailInvalid = false;
  bool passwordNotMatch = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _conPass.dispose();
    super.dispose();
  }

  signup() async {
    if (_formKey.currentState!.validate()) {
      LoginController(context)
          .doEmailSignup(_email.text, _name.text, _pass.text);
    } else {
      LoginController(context)
          .handleSignupFormError(emailInvalid, passwordNotMatch);
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
                                    width: width * 0.56,
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
                                  Container(
                                    width: width * 0.56,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "";
                                        } else if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val)) {
                                          emailInvalid = true;
                                          return "";
                                        }
                                        emailInvalid = false;
                                        return null;
                                      },
                                      controller: _email,
                                      decoration:
                                          signupInputDecoration.copyWith(
                                        isDense: true,
                                        hintText: 'Email',
                                        prefixIcon: Icon(
                                          Icons.email_rounded,
                                          color: Color(0xFFBD2823),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.56,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "";
                                        }

                                        return null;
                                      },
                                      controller: _pass,
                                      obscureText: !showPassword,
                                      decoration:
                                          signupInputDecoration.copyWith(
                                        isDense: true,
                                        hintText: 'Password',
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                            icon: Icon(
                                              showPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Color(0xFFBD2823),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.56,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "";
                                        } else if (val != _pass.text) {
                                          passwordNotMatch = true;
                                          return "";
                                        }
                                        passwordNotMatch = false;
                                        return null;
                                      },
                                      controller: _conPass,
                                      obscureText: !showConPassword,
                                      decoration:
                                          signupInputDecoration.copyWith(
                                        isDense: true,
                                        hintText: 'Confirm Password',
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showConPassword =
                                                    !showConPassword;
                                              });
                                            },
                                            icon: Icon(
                                              showConPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Color(0xFFBD2823),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.025,
                          ),
                          LinearSocialButtonGroup(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.75,
                    left: width * 0.36,
                    child: ElevatedButton(
                      onPressed: signup,
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
            )
          ],
        ),
      ),
    );
  }
}

class FrontTextInSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create an Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          Text(
            "Welcome Back, you've been missed",
            style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
          )
        ],
      ),
    );
  }
}
