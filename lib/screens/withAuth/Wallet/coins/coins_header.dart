import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinsHeader extends StatelessWidget {
  CoinsHeader({this.coins});
  final String? coins;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "images/Taka_sign.svg",
                          height: 40,
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10, left: 5),
                            child: Text(
                              coins.toString(),
                              style: TextStyle(
                                  color: Color(0xFF707070),
                                  fontSize: 35,
                                  fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          width: 30.w,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      "Current Coins",
                      style: TextStyle(
                          color: Color(0xFF161523),
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "images/Withdrawal_History.svg",
                    height: 25.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      "beans record",
                      style: TextStyle(
                          color: Color(0xFF707070),
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
