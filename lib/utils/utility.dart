import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firestore_services.dart';
import '../services/live_service/live_service.dart';
import '../services/shared_storage_services.dart';
import '../services/userfollowservice.dart';

class Utility {
  logout(BuildContext context) async {
    await LocalStorageHelper.clearData();
    SharedPreferences prref = await SharedPreferences.getInstance();
    prref.setBool("box", true);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  getLoginStatus(BuildContext context) async {
    bool i = await LiveService().getLoginStatus();
    if (i) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (BuildContext context) {
            return AlertDialog(
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
                'Sorry! You account is temporary suspend,Please contact to App Admin!',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await LocalStorageHelper.clearData();
                    SharedPreferences prref =
                    await SharedPreferences.getInstance();
                    prref.setBool("box", true);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  },
                  child: Text('Ok',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ),
              ],
            );
          });
    }
  }

  isUserBlock(BuildContext context, String userId, String type,
      String channelName) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to block this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                bool i = await UserFollowService().blockUser(userId, "block");
                if (!i) {

                }
                FirestoreServices.userBlock(userId, channelName);
              },
              child: Text('Yes',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
            ),
          ],
        );
      },);
  }

  Future<bool?> isUserUnBlock(BuildContext context, String userId) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)
    {
      return AlertDialog(
        title: Text('Are you sure you want to unblock this user?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              bool? i = await UserFollowService().blockUser(userId, "unblock");
              // if (i) {
              //   return true;
              // } else {
              //   return false;
              // }
            },
            child: Text('Yes',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
          ),
        ],
      );
    },);
  }

}
