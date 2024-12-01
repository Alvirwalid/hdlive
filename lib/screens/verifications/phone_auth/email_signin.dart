import 'package:flutter/material.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/verifications/controllers/login_controller.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sign_in.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  onSingInPressed() async {
    if (_formKey.currentState!.validate()) {
      LoginController(context).doEmailLogin(email: _email.text, password: _password.text);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    onSingInPressed();
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
                    top: height * 0.26,
                    left: 20,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FrontTextInLogin(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.6,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Email Or uniqueid  is not valid";
                                      }
                                    },
                                    controller: _email,
                                    decoration: loginInputDecoration.copyWith(
                                        isDense: true,
                                        hintText: 'Email / Unique Id',
                                        prefixIcon: Icon(
                                          Icons.email_rounded,
                                          color: Color(0xFFBD2823),
                                        ))),
                              ),
                              Container(
                                width: width * 0.6,
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Password is Required";
                                    }
                                  },
                                  controller: _password,
                                  obscureText: !showPassword,
                                  decoration: loginInputDecoration.copyWith(
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
                              TextButton(
                                  onPressed: () async {
                                    if (!await launch(
                                        'https://www.facebook.com/HDlive.bd/',
                                        forceSafariVC: false,
                                        forceWebView: false))
                                      throw 'Could not launch ';
                                  },
                                  child: Text(
                                    'Forget Password ?',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.65,
                    left: width * 0.50,
                    child: ElevatedButton(
                      onPressed: onSingInPressed,
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(color: Colors.white),
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
