import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';
import 'package:hdlive_latest/screens/withAuth/setting/user_blocked_screen.dart';
import 'package:hdlive_latest/services/shared_storage_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AboutUsScreen.dart';

class Settingprofile extends StatefulWidget {
  // final String icon;
  final String? label;
  final String ?label2;
  Settingprofile({this.label, this.label2});

  @override
  State<Settingprofile> createState() => _SettingprofileState();
}

class _SettingprofileState extends State<Settingprofile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.transparent))),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          // SvgPicture.asset("images/$icon",),
          // Image.asset(
          //   "images/$icon",
          //   height: 25,
          //   width: 25,
          //   color: Colors.red,
          //   fit: BoxFit.cover,
          // ),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.label??"",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 120),
            child: Text(
              "${widget.label2}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SettingSreen extends StatefulWidget {
  const SettingSreen({Key? key}) : super(key: key);

  @override
  State<SettingSreen> createState() => _SettingSreenState();
}

class _SettingSreenState extends State<SettingSreen> {
  Stream<FileResponse>? fileStream;

  void _downloadFile() {
    setState(() {
      fileStream =
          DefaultCacheManager().getFileStream(baseURL2, withProgress: true);
    });
  }

  void _clearCache() {
    DefaultCacheManager().getFileFromCache(baseURL2, ignoreMemCache: true);
    setState(() {
      fileStream = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 20,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 5),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  ListView(children: [
                    Column(
                      children: [
                        Settingprofile(
                          label: 'Account Management', label2: '',
                          //  icon: 'block.png',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UserBlockedScreen(),
                              ),
                            );
                          },
                          child: Settingprofile(
                            label: 'Blocked list',
                            label2: '',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      'Are you sure you want to clear app cache?',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _clearCache();
                                          Loading();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Clean Cache',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Settingprofile(
                            label: 'Clean Cache', label2: '',
                            //icon: 'block.png',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AboutUsScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                // SvgPicture.asset("images/$icon",),

                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "AboutUs",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () async {
                            await LocalStorageHelper.clearData();
                            SharedPreferences prref =
                                await SharedPreferences.getInstance();
                            prref.setBool("box", true);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red.shade700,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
