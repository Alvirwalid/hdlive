import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/bloc/profile_bloc/profile_bloc.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/level_model.dart';
import 'package:hdlive_latest/screens/profile/profile_pages/check_vip.dart';
import 'package:hdlive_latest/screens/profile/profile_pages/earning_page.dart';
import 'package:hdlive_latest/screens/profile/profile_pages/message_page.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/screens/shared/no_image_found.dart';
import 'package:hdlive_latest/screens/withAuth/Wallet/wallet.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/edit/new_edit_profile_window.dart';
import 'package:hdlive_latest/services/level_service.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../profile_follow_infos.dart';
import '../profile_locations.dart';
import 'family_battle.dart';
import 'levelscreen.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class NewEditProfileLanding extends StatefulWidget {
  final bool fromReg;

  NewEditProfileLanding({this.fromReg = false});

  @override
  _NewEditProfileLandingState createState() => _NewEditProfileLandingState();
}

class _NewEditProfileLandingState extends State<NewEditProfileLanding> {
  ProfileBloc _bloc = ProfileBloc();
  bool servicestatus = false;
  bool haspermission = false;
  LocationPermission? permission;
  Position? position;
  String long = "", lat = "", liveLocation = "";
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    getIMage();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _bloc.add(FetchProfileInfo(me: true));
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });
        getLocation();
      }
    } else {
      Fluttertoast.showToast(
          msg: "GPS Service is not enabled, turn on GPS location");
      await Geolocator.openLocationSettings();
      checkGps();
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position?.longitude);
    print(position?.latitude);

    long = position!.longitude.toString();
    lat = position!.latitude.toString();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      setState(() {
        print(position?.longitude);
        print(position?.latitude);
        liveLocation = placemarks[0].country??"";
        print(placemarks[0].country);
      });
    } catch (err) {}

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) async {
      print(position.longitude);
      print(position.latitude);
      long = position.longitude.toString();
      lat = position.latitude.toString();

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        setState(() {
          print(position.longitude);
          print(position.latitude);
          liveLocation = placemarks[0].country??"";
        });
        print(placemarks[0].country);
      } catch (err) {}
    });
  }

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  var image;

  getIMage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    image = pref.getString('coverpic');
    // setState(() {});
  }

  void pageRefresh() {
    initState();
    build(context);
  }

  @override
  Widget build(BuildContext context) {
    // getIMage();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async{
        if (widget.fromReg) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
          return true;

        } else {
          Navigator.of(context).pop();
          return false;

        }
      },
      child:
        Scaffold(
        body: SafeArea(
          child: Container(
            child: BlocBuilder(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is ProfileFetching) {
                    return Loading();
                  } else if (state is ProfileFetched) {
                    CurrentUserModel user = state.user??CurrentUserModel();
                    List<Widget> coverPic = [];
                    if (user.coverPhotos!.isNotEmpty) {
                      user.coverPhotos!.forEach((value) {
                        coverPic.add(CachedNetworkImage(
                          imageUrl: value.image??"",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: height * .4,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Container(width: 20.w, child: Loading()),
                          errorWidget: (context, url, error) => Image.asset(
                            "images/profile.jpeg",
                            fit: BoxFit.cover,
                          ),
                        ));
                      });
                    } else {
                      Container();
                    }
                    // List<String> tags = [];
                    // if (user.tags.length > 0) {
                    //   user.tags.forEach((element) {
                    //     tags.add(element.name);
                    //   });
                    // }

                    IconData genderData = Ionicons.male_female;
                    if (user.gender == "Male")
                      genderData = Ionicons.male;
                    else if (user.gender == 'Female')
                      genderData = Ionicons.female;
                    return ListView(
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  primary: false,
                                  children: [
                                    coverPic.length > 0
                                        ? ImageSlideshow(
                                            indicatorColor: Colors.white,
                                            initialPage: 1,
                                            width: double.infinity,
                                            height: height * 0.4,
                                            children: coverPic)
                                        : Container(
                                            // image != null
                                            //     ? Image.network(
                                            //         image,
                                            //         fit: BoxFit.cover,
                                            //         height: height * 0.4,
                                            //       )
                                            //     : Container(
                                            //
                                            child: NoImageFoundCoverPhoto(),
                                            height: height * 0.4,
                                          ),

                                    Container(
                                      padding: EdgeInsets.only(
                                          left: width * 0.25 + 30, top: 10.sp),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.name ?? "N/A",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.sp),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'ID : ${user.uniqueId}',
                                                    style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  user.users_verify == "1"
                                                      ? Image.asset(
                                                          'images/verifyIcon.png',
                                                          height: 20.h,
                                                          width: 20.w,
                                                        )
                                                      : Image.asset(
                                                          'images/unverified.jpg',
                                                          height: 20.h,
                                                          width: 20.w,
                                                        ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  FutureBuilder<Levelmodel>(
                                                    future: LevelService().level().then((value) => value??Levelmodel()),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Container(
                                                          height: 20,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .centerRight,
                                                                    end: Alignment
                                                                        .centerLeft,
                                                                    colors: [
                                                                      Color(int
                                                                          .parse(
                                                                              "${snapshot.data?.data?.blColorCode?.replaceFirst("#", "0xff")}")),
                                                                      Colors
                                                                          .black87
                                                                    ],
                                                                  )),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 8,
                                                                backgroundImage:
                                                                    NetworkImage(snapshot.data?.data?.blIcon??""),
                                                              ),

                                                              // avater,
                                                              Text(
                                                                "BL.${snapshot.data?.data?.broadcastingLevel??""}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              //    Spacer(),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return Loading();
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  FutureBuilder<Levelmodel>(
                                                    future: LevelService().level().then((value) => value??Levelmodel()),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Container(
                                                          height: 20,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .centerRight,
                                                                    end: Alignment
                                                                        .centerLeft,
                                                                    colors: [
                                                                      Color(int
                                                                          .parse(
                                                                              "${snapshot.data?.data?.rlColorCode?.replaceFirst("#", "0xff")}")),
                                                                      Colors
                                                                          .black87
                                                                    ],
                                                                  )),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 10,
                                                                backgroundImage:
                                                                    NetworkImage(snapshot.data?.data?.rlIcon??""),
                                                              ),

                                                              // avater,
                                                              Text(
                                                                "LV.${snapshot.data?.data?.runningLevel??""}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              //    Spacer(),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return Loading();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Checkmyvip();
                                        }));
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ProfileLocation(
                                              /*location: user.countryName.isEmpty
                                                  ? "Bangladesh"
                                                  : user.countryName,*/
                                              location: liveLocation,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30.sp, top: 10.sp),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff17925),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.r)),
                                              height: 30.h,
                                              width: 120.w,
                                              child: Center(
                                                child: Text(
                                                  'Check My Vip',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.sp),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // ProfileLocation(
                                        //   location: user.countryName.isEmpty
                                        //       ? "Bangladesh"
                                        //       : user.countryName,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      padding: EdgeInsets.only(
                                          left: 10.sp, right: 10.sp),
                                      child: Text(
                                        user.bio??"",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),

                                    //ProfileTags(tags: tags),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    ProfileFollowInfos(
                                      fans: user.fanCount ?? 0,
                                      following: user.followCount ?? 0,
                                      friend: user.friendCount ?? 0,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Divider(
                                      thickness: 5,
                                    ),
                                    IconCardForProfile(
                                      icon: "post.png",
                                      label: "My Post",
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return MessagePage(
                                            isHome: true,
                                          );
                                        }));
                                      },
                                      child: IconCardForProfile(
                                        icon: "Messages.png",
                                        color: Colors.red,
                                        label: "Messages",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return EarningPage(
                                              id: user.userId,
                                              isVerify: user.users_verify);
                                        }));
                                      },
                                      child: IconCardForProfile(
                                        icon: "earning.png",
                                        color: Colors.red,
                                        label: "Earning",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          print(
                                              "diamondcounttt${user.diamondcount}");
                                          return Wallet(
                                            diamond: user.diamondcount??"",
                                            beans: user.beansCount??"",
                                            coins: user.coinCount??"",
                                            userid: user.userId??"",
                                          );
                                        }));
                                      },
                                      child: IconCardForProfile(
                                        icon: "Wallet.png",
                                        label: "Wallet",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        WebView.platform = AndroidWebView();
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Scaffold(
                                            appBar: AppBar(
                                              leading: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.black45,
                                                    size: 25.sp,
                                                  )),
                                              backgroundColor: Colors.white,
                                              title: Text(
                                                'HD Store',
                                                style: TextStyle(
                                                    color: Colors.red.shade900,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            body: WebView(
                                              initialUrl:
                                                  "https://lovello.market",
                                              debuggingEnabled: true,
                                            ),
                                          );
                                        }));
                                      },

                                      // onTap: () async {
                                      //   String url = "https://lovello.market/";
                                      //   if (await canLaunch(url)) {
                                      //     await launch(url);
                                      //   }
                                      // },
                                      child: IconCardForProfile(
                                        icon: "market.jpeg",
                                        label: "HD Store",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return Familybattle();
                                          },
                                        ));
                                      },
                                      child: IconCardForProfile(
                                        icon: "Fans_Group.png",
                                        label: "Family Battle",
                                      ),
                                    ),
                                    IconCardForProfile(
                                      icon: "Task_Center.png",
                                      label: "Task Center",
                                    ),
                                    IconCardForProfile(
                                      icon: "Activites.png",
                                      label: "Activities",
                                    ),
                                    IconCardForProfile(
                                      icon: "Item_Bag.png",
                                      label: "My Bag",
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Levelscreen();
                                        }));
                                      },
                                      child: IconCardForProfile(
                                        icon: "Level.png",
                                        label: "Level",
                                      ),
                                    ),
                                    IconCardForProfile(
                                      icon: "Ranking.png",
                                      label: "Ranking",
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed("/Setting");
                                      },
                                      child: IconCardForProfile(
                                        icon: "Setting.png",
                                        label: "Settings",
                                      ),
                                    ),
                                    IconCardForProfile(
                                      icon: "Help_Feedback.png",
                                      label: "Help & Feedback",
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        String url =
                                            "https://www.facebook.com/HDlive.bd";
                                        if (await canLaunch(url))
                                          await launch(url);
                                        else
                                          // can't launch url, there is some error
                                          throw "Could not launch $url";
                                      },
                                      child: IconCardForProfile(
                                        icon: "facebook2.png",
                                        label: "Like Us",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Me',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.all(10.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      NewEditProfileWindow(
                                                        user: user,
                                                        onDispose: () {
                                                          _bloc.add(
                                                              FetchProfileInfo(
                                                                  me: true));
                                                        },
                                                      )));
                                        },
                                        child:
                                            Image.asset("images/icon-10.png")),
                                  ],
                                ),
                              ),
                              Positioned(
                                  top: height * .4 - width * 0.125,
                                  left: 5,
                                  child: state.user?.image == null
                                      ? InitIconContainer(
                                          radius: width * 0.25,
                                          text: state.user?.name??"",
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: user.gender == "Male"
                                                  ? Color(0xff3a9bdc)
                                                  : Color(0xfffe6f5e)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: width * 0.125,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.125),
                                                  child:
                                                      HexagonProfilePicNetworkImage(
                                                          url: state.user?.image??"")),
                                            ),
                                          ),
                                        )
                                  //   : Image(image: NetworkImage(state.user.image),height: 120,width:width * 0.25 ,fit: BoxFit.fill,),
                                  ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Text(
                            "Could not found info. Please Logout and Login again."),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}

class IconCardForProfile extends StatelessWidget {
  final String? icon;
  final String? label;
  final Color? color;

  IconCardForProfile({this.color, this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
      child: Row(
        children: [
          // SvgPicture.asset("images/$icon",),
          Image.asset(
            "images/$icon",
            height: 25.h,
            width: 25.w,
            color: color,
          ),
          SizedBox(
            width: 15.w,
          ),
          Text(
            label??"",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
          )
        ],
      ),
    );
  }
}
