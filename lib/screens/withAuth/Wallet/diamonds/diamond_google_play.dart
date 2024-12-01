import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hdlive_latest/models/banner_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/package/bankpackage.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/package/gpaypackage.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/package/package.dart';
import 'package:hdlive_latest/services/live_service/live_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiamondGooglePlay extends StatefulWidget {
  DiamondGooglePlay({this.userid});

  String? userid;
  @override
  _DiamondGooglePlayState createState() => _DiamondGooglePlayState();
}

class _DiamondGooglePlayState extends State<DiamondGooglePlay> {
  List<Datum> banner = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: SvgPicture.asset(
              'images/Gpay.svg',
              height: 60,
              width: 60,
            ),
            trailing: Container(
                width: 100.w,
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.amber.shade900, Colors.amber]),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                      context,
                    ) {
                      return Gpaypackage(
                        userid: widget.userid??"",
                      );
                    }));
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        'images/dimond.png',
                        height: 35,
                        width: 35,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        'Package',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(
            height: 10.h,
          ),
          ListTile(
            leading: SvgPicture.asset(
              'images/paypal.svg',
              height: 60,
              width: 60,
            ),
            trailing: Container(
                width: 100.w,
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.amber.shade900, Colors.amber]),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                      context,
                    ) {
                      return packagepaypal(
                        userid: widget.userid??"",
                      );
                    }));
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        'images/dimond.png',
                        height: 35,
                        width: 35,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Package',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(
            height: 10.h,
          ),
          ListTile(
            leading: SvgPicture.asset(
              'images/mastercard.svg',
              height: 60,
              width: 60,
            ),
            trailing: Container(
                width: 100.w,
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.amber.shade900, Colors.amber]),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                      context,
                    ) {
                      return Bankpackage(
                        userid: widget.userid??"",
                      );
                    }));
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'images/dimond.png',
                        height: 35,
                        width: 35,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Package',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          FutureBuilder<BannerModel>(
              future: LiveService().getBanner(),
              builder: (context, snap) {
                if (snap.hasData) {
                  if (banner.isNotEmpty) {
                    banner.clear();
                  }
                  if (banner.isEmpty) {
                    for (int i = 0; i < snap.data!.data!.length; i++) {
                      if (snap.data!.data![i].type
                          .toString()
                          .contains('wallet_banner')) {
                        banner.add(snap.data!.data![i]);
                      }
                    }
                  }
                  return Container(
                    width: double.infinity,
                    height: 120.h,
                    child: CarouselSlider.builder(
                      itemCount: banner.length,
                      itemBuilder: (context, index, realIndex) {
                        return GestureDetector(
                          onTap: () {
                            WebView.platform = AndroidWebView();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Scaffold(
                                body: WebView(
                                  initialUrl: banner[index].link,
                                  debuggingEnabled: true,
                                ),
                              );
                            }));
                          },
                          child: Container(
                            width: 400.w,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  banner[index].image??"",
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        autoPlay: true,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 1.0,
                        initialPage: 0,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Loading(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
