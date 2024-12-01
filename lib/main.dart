import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive/screens/live/timer_service.dart';
import 'landing/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  // _initialPermissionsAndInitialization();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    final timerService = TimerService();
    runApp(
      TimerServiceProvider( // provide timer service to all widgets of your app
        service: timerService,
        child: MyApp(),
      ),
    );
  });
}

//
// Future<void> _handlePermissions(Permission permission) async {
//   final status = await permission.request();
//
//   if (status.isGranted) {
//     return SpashScreen();
//   } else {
//     SystemNavigator.pop(animated: true);
//     print("else part==");
//   }
//   print(status);
// }
//
// _initialPermissionsAndInitialization() async {
//   // await _handlePermissions(Permission.location);
//   await _handlePermissions(Permission.storage);
//   await _handlePermissions(Permission.phone);
//   await _handlePermissions(Permission.camera);
//   await _handlePermissions(Permission.microphone);
//   await _handlePermissions(Permission.photos);
//   bool isKeptOn = await Screen.isKeptOn;
//   if (!isKeptOn) {
//     Screen.keepOn(true);
//   }
// }
// g
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: ScreenUtil.defaultSize,
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(scaffoldBackgroundColor: Colors.white),
            debugShowCheckedModeBanner: false,
            // initialRoute: '/',
            home: SpashScreen(),
            onGenerateRoute: RouteGenerator.generateRoute,
          );;
        },

        );
  }
}
