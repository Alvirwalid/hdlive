import 'package:flutter/material.dart';
import 'package:hdlive_latest/screens/withAuth/landing/coming_soon.dart';

class TheaterLive extends StatefulWidget {
  @override
  _TheaterLiveState createState() => _TheaterLiveState();
}

class _TheaterLiveState extends State<TheaterLive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ComingSoon(),
      ),
    );
  }
}
