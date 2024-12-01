import 'dart:convert';
import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/models/Brodscastmodel.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/screens/profile/profile_pages/message_page.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/screens/withAuth/landing/landing_page.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/edit/new_edit_profile_landing.dart';
import 'package:hdlive_latest/services/live_service/live_service.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:hdlive_latest/utils/utility.dart';
import 'package:url_launcher/url_launcher.dart';

import 'go_live/go_live_landing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with SingleTickerProviderStateMixin,WidgetsBindingObserver {
  TabController? pg;
  CurrentUserModel? user;

  void _onTappedBar(int value) async {
    // if (value == 2) {
    //   Brodcastmodel brod = await BrodcastServicee();
    //   if (brod.data.allowBroadcasting.contains("yes")) {
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return GoLiveLanding();
    //     }
    //     ));
    //   } else {
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             backgroundColor: Colors.white,
    //             title: Text(
    //               'Please wait 24 hours live Ban',
    //               style: TextStyle(fontSize: 18, color: Colors.red),
    //             ),
    //             content: Text(
    //               'please contact admin..',
    //               style: TextStyle(color: Colors.red),
    //             ),
    //             actions: <Widget>[
    //               FlatButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child: Text('Ok'),
    //               ),
    //             ],
    //           );
    //         });
    //   }
    // }

    // else {
    setState(() {
      _selectedIndex = value;
    });
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setInt('NavigationKey', value);
    _pageController?.jumpToPage(value);
  }

  int _selectedIndex = 0;
  PageController? _pageController;
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press Again To Exit');
      return Future.value(false);
    }
    SystemNavigator.pop(animated: true);

    return Future.value(true);
  }
  bool _isInterstitialAdLoaded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getAppPackage();
    Utility().getLoginStatus(context);
    getAgoraId();
    getPref();
    brodCastService();
    FacebookAudienceNetwork.init();
    _loadInterstitialAd();

    super.initState();
  }


  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "656772698757331_689157978852136",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {

        }
      },
    );
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("ChangeApp -- $state");
    if (state == AppLifecycleState.resumed) {
      getAppPackage();
    } else if (state == AppLifecycleState.inactive) {

    }
  }


  Future<void> getAgoraId() async {
    await LiveService().getAgoraId();
  }

  Future<Brodcastmodel?> brodCastService() async {
    var i = await TokenManagerServices().getData();
    try {
      Map payload = {
        "user_id": i.userId,
      };
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse(checkBroadcastPermission));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(jsonEncode(payload)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print('HELLOOOOOOO===>$reply');
      return brodcastmodelFromJson(reply);
    } catch (e) {
      print(e);
    }
    return null;
  }

  int? ind;
  bool? isLoad = false;

  getPref() async {
    setState(() {
      isLoad = true;
    });
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // ind = pref.getInt('NavigationKey');
    // print('Last index  == $ind');
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage:ind != null ? ind! : 0);
    return WillPopScope(
      onWillPop: onWillPop,
      child: isLoad!
          ? Center(
        // child: CircularProgressIndicator(),
        child: Loading(),
      )
          : Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () async {
            Brodcastmodel? brod = await brodCastService();
            if (brod!.data!.allowBroadcasting!.contains("yes")) {
              _loadAds(context);
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  useSafeArea: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      contentPadding:
                      EdgeInsets.only(left: 60.sp, right: 60.sp),
                      title: Image.asset(
                        "images/livepopup.png",
                        height: 200.h,
                        width: 250.w,
                        fit: BoxFit.cover,
                      ),
                      content: Text(
                        'Please wait 24 hours live Ban\n Please contact admin..',
                        style:
                        TextStyle(fontSize: 18.sp, color: Colors.red),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Ok'),
                        ),
                      ],
                    );
                  });
            }
          },
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                right: _selectedIndex == 0 ? 0 : -250.w,
                height: 80.h,
                bottom: 20.h,
                width: 180.w,
                child: Image.asset(
                  "images/liveButton.gif",
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
        body: PageView(
          allowImplicitScrolling: false,
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            LandingPage(),
            LandingPage(),
            // GoLiveLanding(),
            LandingPage(),
            MessagePage(
              isHome: false,
            ),
            NewEditProfileLanding()
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.white70,
          style: TabStyle.react,
          elevation: 0,
          disableDefaultTabController: true,
          items: [
            TabItem(
                icon: SvgPicture.asset(
                  "images/Home_inactive.svg",
                ),
                activeIcon: SvgPicture.asset(
                  "images/Home_Active.svg",
                ),
                isIconBlend: false),
            TabItem(
                icon: Image.asset(
                  "images/like2.png",
                  color: Colors.black54,
                ),
                isIconBlend: false,
                activeIcon: Image.asset("images/like.jpg")),
            TabItem(
                activeIcon: Image.asset(
                  "images/trophyy.png",
                  height: 200,
                  width: 200,
                ),
                icon: Image.asset(
                  "images/trophyy.png",
                  width: 125,
                  height: 125,
                ),
                isIconBlend: false),
            TabItem(
                icon: Image.asset(
                  "images/emailicon2.png",
                  width: 30,
                ),
                activeIcon: Image.asset(
                  "images/emailicon.png",
                  width: 30,
                ),
                isIconBlend: false),
            TabItem(
                icon: SvgPicture.asset(
                  "images/Profile_inactive.svg",
                ),
                activeIcon: SvgPicture.asset(
                  "images/Profile_Active.svg",
                ),
                isIconBlend: false),
          ],
          initialActiveIndex: ind != null ? ind : 0,
          onTap: _onTappedBar,
        ),
      ),
    );
  }

  Future<void> getAppPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print("version---> $version");
    print("buildNumber---> $buildNumber");

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    print("Fire Remote ---> ${remoteConfig.getString("playstore_version")}");

    if(version != remoteConfig.getString("playstore_version")){
      return showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 60, right: 60),
                title: Image.asset(
                  "images/livepopup.png",
                  height: 200,
                  width: 250,
                  fit: BoxFit.cover,
                ),
                content: Text(
                  'Sorry! Please update Application with latest future!',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      _launchURL("https://play.google.com/store/apps/details?id=com.lovello.lovello");
                    },
                    child: Text('Ok',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ),
                ],
              ),
            );
          });
    }

  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
    else {
      throw 'Could not launch $url';
    }
  }

  void _loadAds(BuildContext context) {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "656772698757331_689157978852136",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;
        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                Utility().getLoginStatus(context);
                return GoLiveLanding();
                // return GoLiveLandingNew();
              }));
        }else{
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                Utility().getLoginStatus(context);
                return GoLiveLanding();
                // return GoLiveLandingNew();
              }));
        }
      },
    );

  }


}
