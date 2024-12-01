import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/banner_model.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/bean/beans.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/coins/coins.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/diamonds/diamonds.dart';

class Wallet extends StatefulWidget {
  final String? diamond;
  final String? beans;
  final String? coins;
  final String? userid;

  const Wallet({this.userid, this.diamond, this.beans, this.coins});
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  var primaryIdx = 0;
  List<Datum> banner = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print('diamondsss${widget.diamond}');
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.west,
                color: Colors.black,
              ),
            ),
            title: Text(
              "Wallet",
              style: TextStyle(
                  color: Color(0xFFE1233F),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                height: 30,
                width: size.width / 1.5,
                child: TabBar(
                  isScrollable: true,
                  indicatorColor: Color(0xFFD8300E),
                  onTap: (idx) {
                    setState(() {
                      primaryIdx = idx;
                    });
                  },
                  // indicator: BoxDecoration(
                  //   color:  Color(0xFFD8300E)
                  // ),
                  tabs: [
                    Tab(
                      child: LabelText(
                        selected: primaryIdx == 0,
                        label: "Diamonds",
                      ),
                    ),
                    Tab(
                      child: LabelText(
                        selected: primaryIdx == 1,
                        label: "Beans",
                      ),
                    ),
                    Tab(
                      child: LabelText(
                        selected: primaryIdx == 2,
                        label: "Coins",
                      ),
                    ),
                  ],
                ),
              ),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    Diamonds(
                      diamond: widget.diamond??"",
                      userid: widget.userid??"",
                    ),
                    Beans(
                      beans: widget.beans??"",
                      userid: widget.userid??"",
                    ),
                    Coins(coins: widget.coins??"")
                  ],
                ),
              ),
              Text(
                'Appstech Technology pvt. ltd.',
                style: TextStyle(
                    color: Colors.red.shade900,
                    fontSize: 5.sp,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'www.hdlive.pro',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String? label;
  final bool? selected;

  LabelText({this.label, this.selected});
  @override
  Widget build(BuildContext context) {
    return Text(
      label??"",
      style: !selected!
          ? TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
              fontSize: 14.sp)
          : TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFFAA2104),
              fontSize: 14.sp),
    );
  }
}
