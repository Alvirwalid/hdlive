import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/beans_model.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/bean/bean_header.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/bean/bean_infos.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/bean/beans_exchange.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';

class Beans extends StatefulWidget {
  const Beans({this.beans, this.userid});

  final String? beans;
  final String? userid;

  @override
  _BeansState createState() => _BeansState();
}


class _BeansState extends State<Beans> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<BeansModel>(
        future: ProfileUpdateServices().getBeansInfo("monthly",widget.userid??""),
        builder: (context,AsyncSnapshot<BeansModel>snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Color(0xFFF8F8F8),
              child: ListView(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  BeanHeader(
                    beans: snapshot.data?.data?.totalReceive??"",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BeansExchange(
                    userid: widget.userid??"",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BeanInfos(),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            );
          } else {
            return Container(
              color: Color(0xFFF8F8F8),
              child: ListView(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  BeanHeader(
                    beans: "0",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BeansExchange(
                    userid: widget.userid??"",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BeanInfos(),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            );
          }
        });
  }
}
