import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/package/Exchange_rewards.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/package/exchang_diamond.dart';

class BeansExchange extends StatelessWidget {
  BeansExchange({this.userid});
  String? userid;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ExchangeDiamond(userid: userid??"");
              }));
            },
            child: BeansExchangeItem(
              image: "diamonds.svg",
              label: "Exchange diamonds",
            ),
          ),
          //  Divider(),
          // BeansExchangeItem(
          //   image: "Lovello_Store.svg",
          //   label: "Lovello Store",
          // ),
          Divider(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  (MaterialPageRoute(
                    builder: (context) {
                      return ExchangeReward(
                        userid: userid??"",
                      );
                    },
                  )));
            },
            child: BeansExchangeItem(
              image: "exchange_rewards.svg",
              label: "Exchange rewards",
            ),
          ),
          Divider(),
          BeansExchangeItem(
            image: "Withdrawal_History.svg",
            label: "Withdrawal history",
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}

class BeansExchangeItem extends StatelessWidget {
  String? image;
  String ?label;
  BeansExchangeItem({this.image, this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          SvgPicture.asset(
            "images/${image}",
            color: Colors.red,
            width: 16.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            "${label}",
            style: TextStyle(
                color: Color(0xFF161523),
                fontSize: 15.sp,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
