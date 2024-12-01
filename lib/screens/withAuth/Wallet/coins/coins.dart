import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/coins/coins_header.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/coins/coins_info_1.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/coins/coins_info_2.dart';

class Coins extends StatefulWidget {
  Coins({this.coins});
  final String? coins;
  @override
  _CoinsState createState() => _CoinsState();
}

class _CoinsState extends State<Coins> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF8F8F8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: [
          SizedBox(
            height: 10.h,
          ),
          CoinsHeader(coins: widget.coins??""),
          SizedBox(
            height: 20.h,
          ),
          // BeansExchange(),
          // SizedBox(
          //   height: 20,
          // ),
          CoinsInfo1(),
          SizedBox(
            height: 20.h,
          ),
          CoinsInfo2()
        ],
      ),
    );
  }
}
