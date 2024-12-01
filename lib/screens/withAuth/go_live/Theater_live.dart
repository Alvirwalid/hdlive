import 'package:flutter/material.dart';
import 'package:hdlive_latest/screens/withAuth/landing/coming_soon.dart';
class GoTheaterLive extends StatefulWidget {
  @override
  _GoTheaterLiveState createState() => _GoTheaterLiveState();
}

class _GoTheaterLiveState extends State<GoTheaterLive> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  ComingSoon(),
    );
  }
}
