import 'package:flutter/material.dart';
import 'package:hdlive/screens/verifications/controllers/login_controller.dart';

class LinearSocialButtonGroup extends StatelessWidget {
  final BuildContext? context;

  LinearSocialButtonGroup({this.context});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            child: Image(
              image: AssetImage("images/facebook.png"),
            ),
          ), //facebook
          GestureDetector(
            onTap: () async {
              print("sigin google");
              // await LoginController(context).signinWithGoogle();
            },
            child: Container(
              child: Image(
                image: AssetImage("images/google.png"),
              ),
            ),
          ), //google
          GestureDetector(
            onTap: () {
              print("HERE");
              Navigator.of(context).popAndPushNamed("/phone_signup");
            },
            child: Container(
              child: Image(
                image: AssetImage("images/mobile.png"),
              ),
            ),
          ) //twitter
        ],
      ),
    );
  }
}

class LinearSocialLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              await LoginController(context).signinWithFacebook();
            },
            child: Container(
              child: Image(
                image: AssetImage("images/facebook.png"),
                // height: 70,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ), //facebook
          GestureDetector(
            onTap: () async {
              await LoginController(context).signinWithGoogle();
            },
            child: Container(
              child: Image(
                image: AssetImage("images/google.png"),
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ), //google
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pushNamed("/phone_signin");
            },
            child: Container(
              child: Image(
                image: AssetImage("images/mobile.png"),
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ), //tw
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/email_signin");
            },
            child: Container(
                child: Image(
              image: AssetImage("images/userIcon.png"),
              width: 40,
              fit: BoxFit.cover,
            )),
          ), //twitter
        ],
      ),
    );
  }
}
