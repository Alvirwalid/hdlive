import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dimond_histofry.dart';

class DiamondHeader extends StatelessWidget {
  DiamondHeader({this.userid, this.diamond});
  final String? diamond;
  final String? userid;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.2,
      decoration: BoxDecoration(
        // color: Colors.blue,
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.amberAccent, Colors.amber.shade900]),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("images/dimond.png"),
                        Container(
                            padding: EdgeInsets.only(top: 10, left: 5),
                            child: Text(
                              diamond.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35.sp,
                                  fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          width: 30.w,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Account Balance",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp),
                        ),
                        // IconButton(
                        //     icon: Icon(
                        //       Icons.arrow_forward_ios,
                        //       size: 15,
                        //       color: Colors.white,
                        //     ),
                        //     onPressed: () {})
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 120, right: 10),
            child: Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DimondHistory(
                          userid: userid??"",
                        );
                      }));
                    },
                    child: Container(
                      child: Text(
                        "Recharge History",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    "images/Withdrawal_History.svg",
                    height: 25.h,
                    color: Colors.white,
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
