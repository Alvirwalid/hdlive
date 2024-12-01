import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BeanInfos extends StatelessWidget {
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
                "Set password for exchanging rewards and diamonds",
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
                  "1. After setting password, beans and diamonds can only be exchanged by user who knows the password.",
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
                  "2. If you forget or need to reset your password, please contact us via Feedback on your profile page",
                  style: TextStyle(
                      color: Color(0xFF161523),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )),
              ],
            )),
            SizedBox(
              height: 10.h,
            ),
            Container(
              child: Text(
                "What are beans?",
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
              children: [
                Container(
                    child: Text(
                  '''1. Beans can be exchanged to diamonds 
2. Beans can be exchanged to rewards''',
                  style: TextStyle(
                      color: Color(0xFF161523),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )),
                // SizedBox(height: 5,),
                // Container(child: Text("2. Beans can be exchanged to rewards.",style: TextStyle(color: Color(0xFF161523),fontSize: 12,fontWeight: FontWeight.normal),)),
              ],
            )),
            SizedBox(
              height: 10.h,
            ),
            Container(
              child: Text(
                "Exchange rules",
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
                  "1. Exchange rewards starts from 100000 Current Beans and no more than 10000000 Current Beans forsingle withdrawal",
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
                  "2. You can exchange rewards once a week",
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
                  "3. Singe withdrawal; of more than \$1500 requires approval, which usually takes 25-30 working day.",
                  style: TextStyle(
                      color: Color(0xFF161523),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
