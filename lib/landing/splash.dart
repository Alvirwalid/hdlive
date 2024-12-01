import 'dart:async';

import 'package:flutter/material.dart';

import '../services/shared_storage_services.dart';
class SpashScreen extends StatefulWidget {
  @override
  _SpashScreenState createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  Timer? timer;
  @override
  void initState() {
    new Future.delayed(const Duration(seconds: 3), () async {
      //Navigator.popAndPushNamed(context, '/login');
      var token = await LocalStorageHelper.read("token");
      if (token == null) {
        Navigator.popAndPushNamed(context, '/app_intro');
        // Navigator.popAndPushNamed(context, '/login');
      } else {
        Navigator.popAndPushNamed(context, '/landing');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image(
          image: AssetImage(
            "images/intro_video.gif",
          ),
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
