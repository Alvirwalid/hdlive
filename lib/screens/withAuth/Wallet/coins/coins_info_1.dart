import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdlive_latest/screens/withAuth/landing/coming_soon.dart';

class CoinsInfo1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "what are coins?",
                style: TextStyle(
                    color: Color(0xFF161523),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Divider(),
            Container(
                // padding: EdgeInsets.only(left: 5),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Text(
                  "1. Coins can be used to purchaser gifts.",
                  style: TextStyle(
                      color: Color(0xFF161523),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                    child: Text(
                  "2. Coins can be used to purchaser tools.",
                  style: TextStyle(
                      color: Color(0xFF161523),
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                )),
                SizedBox(
                  height: 5,
                ),
                Container(
                    child: Text(
                  "3. Coins can be used to attend the luckydraw.",
                  style: TextStyle(
                      color: Color(0xFF161523),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )),
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ComingSoon();
                    }));
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            //    crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "images/Go_to_use.svg",
                                height: 15.h,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Go to use",
                                    style: TextStyle(
                                        color: Color(0xFFF42408),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ],
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                            ),
                            onPressed: () {})
                      ],
                    ),
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
