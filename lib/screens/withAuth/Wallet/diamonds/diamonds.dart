import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'diamond_google_play.dart';
import 'diamond_header.dart';

class Diamonds extends StatefulWidget {
  const Diamonds({this.diamond, this.userid});
  final String? diamond;
  final String? userid;
  @override
  _DiamondsState createState() => _DiamondsState();
}

class _DiamondsState extends State<Diamonds> {
  @override
  Widget build(BuildContext context) {
    print("diamond=== ${widget.diamond}");
    return Container(
      color: Color(0xFFF8F8F8),
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: ListView(
        children: [
          //   SizedBox(height: 10,),
          DiamondHeader(
            diamond: widget.diamond,
            userid: widget.userid,
          ),
          SizedBox(
            height: 20.h,
          ),
          // DiamondOffers(),
          // SizedBox(height: 20,),
          DiamondGooglePlay(
            userid: widget.userid,
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
