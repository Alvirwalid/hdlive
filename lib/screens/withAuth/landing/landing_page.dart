import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/screens/explore/explore.dart';
import 'package:hdlive_latest/screens/live/pages/teenpati.dart';
import 'package:hdlive_latest/screens/nearby/nearby_people.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/withAuth/go_live/current_live.dart';
import 'package:hdlive_latest/screens/withAuth/landing/searchScreen.dart';

import 'coming_soon.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var primaryIdx = 1;
  var index = 0;
  int selectedPos = 0;
  TabController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        initialIndex: 2,
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TabBar(
                        labelPadding: EdgeInsets.only(left: 10.sp),
                        isScrollable: true,
                        indicatorColor: Color(0xFFBD2823),
                        automaticIndicatorColorAdjustment: true,
                        labelStyle: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                        unselectedLabelStyle: TextStyle(fontSize: 10.sp),
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.red,
                        onTap: (idx) {
                          setState(() {
                            primaryIdx = idx;
                          });
                        },
                        tabs: [
                          Tab(
                            text: 'NEARBY',
                          ),
                          Tab(
                            text: 'EXPLORE',
                          ),
                          Tab(
                            text: 'POPULAR',
                          ),
                          Tab(
                            text: 'PARTY',
                          ),
                          Tab(
                            text: 'PK',
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SearchScreen();
                                }));
                              },
                              child: Image.asset("images/search-icon.png")),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TeenPati();
                                  },
                                );
                              },
                              child: Image.asset("images/notification-icon.png")),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  NearbyPeopleTab(),
                  Explore(key: ValueKey(1),),
                  CurrentLive(
                    type: "both",
                  ),
                  CurrentLive(
                    type: "audio",
                  ),
                  ComingSoon(),
                  // ComingSoon(),
                  // ComingSoon(),
                ],
              ),
            ],
          ),
        ));
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
      style: selected! ? selectedLableStyle : lableStyle,
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //
    // Path path_0 = Path();
    // path_0.moveTo(size.width*1.660597,size.height*2.155293);
    // path_0.lineTo(size.width*1.660597,size.height*1.514825);
    // path_0.lineTo(size.width*1.317796,size.height*1.515824);
    // path_0.cubicTo(size.width*1.279118,size.height*1.504372,size.width*1.253292,size.height*1.476432,size.width*1.237049,size.height*1.399085);
    // path_0.arcToPoint(Offset(size.width*1.109860,size.height*1.374157),radius: Radius.elliptical(size.width*0.08229159, size.height*0.3707084),rotation: 0 ,largeArc: false,clockwise: false);
    // path_0.lineTo(size.width*1.109855,size.height*1.374098);
    // path_0.cubicTo(size.width*1.109796,size.height*1.374474,size.width*1.109727,size.height*1.374792,size.width*1.109667,size.height*1.375158);
    // path_0.quadraticBezierTo(size.width*1.107761,size.height*1.384824,size.width*1.106008,size.height*1.395089);
    // path_0.cubicTo(size.width*1.089819,size.height*1.475529,size.width*1.063761,size.height*1.504174,size.width*1.024414,size.height*1.515826);
    // path_0.lineTo(size.width*0.6817613,size.height*1.515826);
    // path_0.lineTo(size.width*0.6817613,size.height*2.155293);
    // path_0.close();
    //
    // Paint paint = new Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.fill;
    // canvas.drawColor(Colors.black, BlendMode.);
    // canvas.drawPath(path_0,paint);
    Paint paint = new Paint()
      ..color = Colors.grey[50]!
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 30); // Start
    path.quadraticBezierTo(size.width * 0.20, 20, size.width * 0.35, 20);
    path.quadraticBezierTo(size.width * 0.40, 20, size.width * 0.40, 20);

    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.elliptical(30.0, 25), clockwise: true);
    path.quadraticBezierTo(size.width * 0.60, 20, size.width * 0.65, 20);
    path.quadraticBezierTo(size.width * 0.80, 20, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 10, false);
    canvas.drawColor(Colors.black, BlendMode.overlay);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
