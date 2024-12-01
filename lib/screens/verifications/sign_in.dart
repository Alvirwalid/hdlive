import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/screens/verifications/phone_auth/linear_social_button_group.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:hdlive_latest/screens/withAuth/setting/Brodcast.dart';
import 'package:hdlive_latest/screens/withAuth/setting/privacypolicy.dart';
import 'package:hdlive_latest/screens/withAuth/setting/user_agreement.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class NewSignInDesign extends StatefulWidget {
  @override
  _NewSignInDesignState createState() => _NewSignInDesignState();
}

Future<void> _handlePermissions(Permission permission) async {
  final status = await permission.request();
  if (status.isGranted) {
    // return SpashScreen();
  } else {
    SystemNavigator.pop(animated: true);
    print("else part==");
  }
  print(status);
}

_initialPermissionsAndInitialization() async {
  // await _handlePermissions(Permission.location);
  await _handlePermissions(Permission.storage);
  await _handlePermissions(Permission.phone);
  await _handlePermissions(Permission.camera);
  await _handlePermissions(Permission.microphone);
  await _handlePermissions(Permission.photos);
  bool isKeptOn = await Wakelock.enabled;
  if (!isKeptOn) {
    Wakelock.enable();
  }
  // bool isKeptOn = await Screen.isKeptOn;
  // if (!isKeptOn) {
  //   Screen.keepOn(true);
  // }
}

prefrence() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('box', true);
}

prefrence2() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  boxx = prefs.getBool('box')!;
}

bool? boxx;

class _NewSignInDesignState extends State<NewSignInDesign> {
  @override
  void initState() {
    super.initState();
    prefrence2();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => Future(() => boxx == null || boxx != true
            ? showDialog(
                context: context,
                builder: (context) {
                  print("boxxxxx$boxx");
                  return AlertDialog(
                    title: Text(
                        'we required of your all permissions for run this application'),
                    content: Text('We hate to see you leave...'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      'Please go to setting apps-HD Live permissions and enable to give permissions for HD to use the storage functions'),
                                  // content: Text('go to hd-live setting and give all permittion'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        SystemNavigator.pop(animated: true);
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        openAppSettings();
                                        // _initialPermissionsAndInitialization();
                                        // Navigator.of(context).pop(false);
                                      },
                                      child: Text('GiveMe permissions',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                    ),
                                  ],
                                );
                              });
                          // SystemNavigator.pop(animated: true);
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          _initialPermissionsAndInitialization();
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                }).then((value) => prefrence())
            : null));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: height - 20,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFF32408), Color(0xFFA82104)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Stack(
                children: [
                  Positioned(
                    top: height * 0.08,
                    bottom: height * 0.1,
                    left: 0,
                    right: 10,
                    child: Container(
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("images/white_box.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.035,
                    right: width * .07,
                    child: CircleLogo(),
                  ),
                  Positioned(
                    top: height * 0.40,
                    left: 20,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 70),
                            child: FrontTextInLogin(),
                          ),
                          SizedBox(
                            height: height * 0.020,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: LinearSocialLogin(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 15, left: 10),
                        child: Row(
                          children: [
                            Text(
                              'Signin you means Agree to our',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 8.sp),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserAgreementScreen();
                                }));
                              },
                              child: Text('Terms of use. ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BrodcastScreen();
                                }));
                              },
                              child: Text('Broadcaster Agreement ',
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text('&',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8.sp)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PrivcyPolicyScreen();
                                }));
                              },
                              child: Text(' Privacy Policy',
                                  style: TextStyle(
                                      fontSize: 8.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FrontTextInLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's Sign In",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          Text(
            "Welcome Back, you've been missed",
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          )
        ],
      ),
    );
  }
}
