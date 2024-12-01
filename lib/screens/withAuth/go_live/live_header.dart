import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:hdlive_latest/models/beans_model.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/followmodel.dart';
import 'package:hdlive_latest/models/level_model.dart';
import 'package:hdlive_latest/models/live_model.dart';
import 'package:hdlive_latest/models/viewer_model.dart';
import 'package:hdlive_latest/screens/profile/user_profile_dailog.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/screens/withAuth/profile/viewprofile_model.dart';
import 'package:hdlive_latest/services/firestore_services.dart';
import 'package:hdlive_latest/services/level_service.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:hdlive_latest/services/userfollowservice.dart';

import '../../../utils/round_slider_track_shape.dart';

class LiveHeader extends StatefulWidget {
  final LiveModel? broadcastUser;
  final bool? broadcaster;
  final bool? isAudio;
  final String? channelName;
  final String? msgText;
  final String? userchannelId;
  final Function? onClose;
  final Function? onView;
  final Function? onGiftView;
  final Function? onPipMode;
  final int? second;
  final bool? isMute;
  final String? bio;

  LiveHeader(
      {this.broadcastUser,
      this.msgText,
      this.isAudio,
      this.second,
      this.userchannelId,
      this.broadcaster,
      this.channelName,
      this.isMute,
      this.bio,
      this.onClose,
      this.onGiftView,
      this.onView,
        this.onPipMode});

  @override
  _LiveHeaderState createState() => _LiveHeaderState();
}

class _LiveHeaderState extends State<LiveHeader> {
  String? photoUrl;
  String name = "";
  String uniqId = "";
  String uid = "";
  String gender = "";
  String startcount = "0";
  String bio = "";
  bool showscreen = true;
  int beans = 0;

  @override
  void initState() {
    getInitialDatas();

    getFollowStatus();

    getBenseInfo();

    super.initState();
  }

  CurrentUserModel? user;
  bool isFollow = false;

  Future<void> getFollowStatus() async {
    if (!widget.broadcaster!) {
      FollowModel? model = await UserFollowService().checkFollowStatus(widget.broadcastUser?.userId??"");
      isFollow = model?.data?.following??false;
      print("Follow Status --- $isFollow");
    }
  }

  getInitialDatas() async {
    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId, true);
    if (widget.broadcaster!) {
      photoUrl = user?.image;
      name = user?.name??"";
      uniqId = user?.uniqueId??"";
      uid = user?.userId??"";
      gender = user?.bio??"";
    } else {
      photoUrl = widget.broadcastUser?.photoUrl;
      name = widget.broadcastUser?.liveName??"";
      uniqId = widget.broadcastUser?.uniqid??"";
      uid = widget.broadcastUser?.userId??"";
      gender = widget.broadcastUser?.gender??"";
      bio = widget.broadcastUser?.bio??"";
    }
    showscreen = false;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant LiveHeader oldWidget) {
    // getInitialDatas();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // FollowerModel data = followerModelFromJson();
    return Positioned(
      left: 10,
      top: 10,
      right: 10,
      //   right: MediaQuery.of(context).size.width / 2.5,
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0x99000000),
                          borderRadius: BorderRadius.circular(35)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            photoUrl != null || gender != null
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: gender == "Male"
                                            ? Color(0xff3a9bdc)
                                            : Color(0xfffe6f5e)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (!widget.broadcaster!) {
                                            user = await ProfileUpdateServices()
                                                .getUserProfile(widget
                                                    .broadcastUser?.userId);
                                          }
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              backgroundColor: Colors.white,
                                              builder: (context) {
                                                return Viewprofile_model(
                                                    userId: user?.userId,
                                                    image: user?.image,
                                                    name: user?.name,
                                                    bio: user?.bio,
                                                    countryName:
                                                        user?.countryName,
                                                    gender: user?.gender,
                                                    uniqueId: user?.uniqueId,
                                                    coverphoto: user?.coverPhotos?[1].image,
                                                    userModel: user,
                                                    isBrodcaster:
                                                        widget.broadcaster,
                                                    channelName:
                                                        widget.channelName,
                                                    broadcaster:
                                                        widget.broadcaster);
                                              });
                                        },
                                        child: CircleAvatar(
                                          radius: 18,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child:
                                                  HexagonProfilePicNetworkImage(
                                                      url: photoUrl)),
                                        ),
                                      ),
                                    ),
                                  )
                                : InitIconContainer(
                                    radius: 30,
                                    text: name,
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.msgText!.isNotEmpty
                                          ? widget.msgText!
                                          : name,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(

                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: GestureDetector(
                                                onTap: () {
                                                  openBeansView();
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      'images/beans.png',
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                    FutureBuilder<BeansModel>(
                                                      future:ProfileUpdateServices().getBeansInfo("daily", uid),
                                                      builder:(context,AsyncSnapshot<BeansModel> snapshot) {
                                                        if (snapshot.hasData && snapshot.data!.data != null) {
                                                          beans = int.parse(
                                                              snapshot.data!.data!.totalReceive!.replaceAll(",", ""));
                                                          if (int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) >=
                                                                  10000 &&
                                                              int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) <
                                                                  50000) {
                                                            startcount = "1";
                                                          } else if (int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) >=
                                                                  50000 &&
                                                              int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) < 200000) {
                                                            startcount = "2";
                                                          } else if (int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) >=
                                                                  200000 &&
                                                              int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) < 1000000) {
                                                            startcount = "3";
                                                          } else if (int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) >=
                                                                  1000000 &&
                                                              int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) <
                                                                  2000000) {
                                                            startcount = "4";
                                                          } else if (int.parse(snapshot.data!.data!.totalReceive!.replaceAll(",", "")) >=
                                                              2000000) {
                                                            startcount = "5";
                                                          } else {
                                                            startcount = "0";
                                                          }

                                                          return Text(
                                                            "${snapshot.data?.data?.totalReceive??""}",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          );
                                                        } else {
                                                          return Text(
                                                            "0",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              double i = 0.0;
                                              int total = 0;
                                              if (startcount == "0") {
                                                total = 10000;
                                                i = (beans * 100) / 10000;
                                              } else if (startcount == "1") {
                                                total = 50000;
                                                i = (beans * 100) / 50000;
                                              } else if (startcount == "2") {
                                                total = 200000;
                                                i = (beans * 100) / 200000;
                                              } else if (startcount == "3") {
                                                total = 1000000;
                                                i = (beans * 100) / 1000000;
                                              } else if (startcount == "4") {
                                                total = 2000000;
                                                i = (beans * 100) / 2000000;
                                              }
                                              openStarDialog(
                                                  i, beans, total, startcount);
                                            },
                                            child: Container(
                                                height: 20,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width *
                                                    0.10,
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(20),
                                                  color: startcount == "0"?Colors.grey:
                                                  startcount == "1"?Colors.green:
                                                  startcount == "2"?Colors.orange:
                                                  startcount == "3"?Colors.pink.shade900:
                                                  startcount == "4"?Colors.purple.shade900:
                                                  Colors.red.shade900,
                                                    ),

                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 5,),
                                                      Icon(
                                                        Icons.star,
                                                        size: 15,
                                                        color: Colors.brown,
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        startcount,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      /*  Expanded(
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    !widget.broadcaster &&
                                                            !isFollow
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              await UserFollowService()
                                                                  .getFollowFollowing(
                                                                      uid);
                                                              setState(() {
                                                                isFollow =
                                                                    !isFollow;
                                                              });
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              width: 25,
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xC2F90000),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25)),
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 18,
                                                                color: Colors
                                                                    .red
                                                                    .shade200,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                  ],
                                                ))),*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            widget.isAudio!
                                ? Container()
                                : StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection("live_streams")
                                        .doc(widget.channelName)
                                        .get()
                                        .asStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data!.get('isMute').toString().contains('true')
                                            ? Icon(
                                                Icons.mic_off_rounded,
                                                size: 20,
                                                color: Colors.red,
                                              )
                                            : Container();
                                      } else {
                                        return Center(
                                          child: Container(),
                                        );
                                      }
                                    }),
                            SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: showscreen
                        ? Container()
                        : Container(
                            child: StreamBuilder<List<ViewerModel>>(
                              stream: FirestoreServices().getAllViewersList(
                                  widget.channelName??"", user?.userId??""),
                              builder: (context, snapshot) {
                                List<Widget> people = [];
                                if (snapshot.hasData) {
                                  var lenth = snapshot.data!.length;
                                  if (lenth > 0) {
                                    people.clear();
                                    for (var i = 0; i < 4; i++) {
                                      if (snapshot.data != null && i < lenth) {
                                        people.add(Container(
                                          child: snapshot.data?[i].photoUrl !=
                                                      null &&
                                                  snapshot.data?[i].photoUrl !=
                                                      "http://hdlive.cc/public/uploads/"
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    snapshot.data?[i].photoUrl??"",
                                                  ),
                                                  radius: 12,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "images/profile.jpeg"),
                                                  radius: 12,
                                                ),
                                        ));
                                      }
                                    }
                                  }
                                } else {
                                  print(
                                      'No DATA ====================================');
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            widget.onView!();
                                          },
                                          child: Container(
                                            child: Wrap(
                                              children: people,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            widget.onView!();
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0),
                                              child: Text(
                                                  "${snapshot.data != null ? snapshot.data!.length : 0}"),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            widget.onClose!();
                                          },
                                          child: Container(
                                              child: Image(
                                            image: AssetImage(
                                              "images/end_live.png",
                                            ),
                                            width: 24,
                                          )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            widget.onPipMode!();
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle),
                                              padding: EdgeInsets.all(5),
                                              child: Image(
                                                image: AssetImage(
                                                  "images/minimize.png",
                                                ),
                                                width: 18,
                                                color: Colors.white,
                                              )),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem(BuildContext context, int index, List<Ledger> ledger) {
    var model = ledger[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                openProfile(ledger[index].userId??"");
              },
              child: model.picture != null
                  ? CircleAvatar(
                      radius: 20,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: HexagonProfilePicNetworkImage(
                            url: model.picture,
                          )),
                    )
                  : InitIconContainer(
                      radius: 40,
                      text: model.userName,
                    ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  openProfile(ledger[index].userId??"");
                },
                child: Text(
                  model.userName??"",
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "Beans: ${model.quantity}",
                maxLines: 1,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openProfile(String userId) async {
    String status = "";
    FollowModel? model = await UserFollowService().checkFollowStatus(userId);
    FollowModel? model1 = await UserFollowService().checkFriendStatus(userId);
    if (model!.data!.following! && model1!.data!.following!) {
      status = "Friend";
    } else if (!model.data!.following! && !model1!.data!.following!) {
      status = "Follow";
    } else if (model.data!.following! && !model1!.data!.following!) {
      status = "Following";
    } else if (!model.data!.following! && model1!.data!.following!) {
      status = "Follow back";
    }

    CurrentUserModel? userModel = await ProfileUpdateServices().getUserProfile(userId);
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return UserProfileDailog(
          userModel: userModel,
          status: status,
          broadcaster: widget.broadcaster,
          channelName: widget.channelName,
        );
      },
    );
  }

  void openStarDialog(double i, int beans, int total, String startcount) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 350.0,
        width: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Text('Daily Star',
                  style: TextStyle(color: Colors.black87, fontSize: 20.0)),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  startcount == "0"
                      ? CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.star, color: Colors.white70),
                        )
                      : startcount == "1"
                          ? CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.star, color: Colors.white70),
                            )
                          : startcount == "2"
                              ? CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Colors.orange,
                                  child:
                                      Icon(Icons.star, color: Colors.white70),
                                )
                              : startcount == "3"
                                  ? CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: Colors.pink.shade900,
                                      child: Icon(Icons.star,
                                          color: Colors.white70),
                                    )
                                  : CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: Colors.purple.shade900,
                                      child: Icon(Icons.star,
                                          color: Colors.white70),
                                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '$startcount Star',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 17.0),
                    ),
                  )
                ],
              ),
            ) //
                ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Container(
                height: 22,
                child: Stack(
                  children: [
                    Center(
                      child: SliderTheme(
                        child: Slider(
                          value: i,
                          max: 100,
                          min: 0,
                          onChanged: (double value) {},
                        ),
                        data: SliderTheme.of(context).copyWith(
                            trackHeight: 22,
                            thumbColor: Colors.transparent,
                            trackShape: RoundSliderTrackShape(),
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                      ),
                    ),
                    Center(
                      child: Text(
                        '$beans/$total',
                        style: TextStyle(color: Colors.black, fontSize: 13.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
              child: Text('Sending gifts can help me collect stars',
                  style:
                      TextStyle(color: Colors.grey.shade400, fontSize: 13.0)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.broadcaster! ? openBeansView() : widget.onGiftView!();
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      border: Border.all(
                        color: Colors.pink,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(
                        widget.broadcaster! ? 'Check Gift Record' : 'Send Gift',
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 15.0, bottom: 10.0),
                child: Text(
                    'After reaching 5 star,receive a big beans bag on sending gifts of worth 200k beans every time.',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 13.0)),
              ),
            ),
            ClipRRect(
              child: Image.asset(
                "images/box.png",
                fit: BoxFit.cover,
                height: 50.0,
                width: 50.0,
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> getBenseInfo() async {
    BeansModel model = await ProfileUpdateServices().getBeansInfo("daily", uid);
    if(model.data?.totalReceive != null){
    beans = int.parse(model.data!.totalReceive!.replaceAll(",", ""));
    if (int.parse(model.data!.totalReceive!.replaceAll(",", "")) >= 10000 &&
    int.parse(model.data!.totalReceive!.replaceAll(",", "")) < 50000) {
    startcount = "1";
    } else if (int.parse(model.data!.totalReceive!.replaceAll(",", "")) >=
    50000 &&
    int.parse(model.data!.totalReceive!.replaceAll(",", "")) < 200000) {
    startcount = "2";
    } else if (int.parse(model.data!.totalReceive!.replaceAll(",", "")) >=
    200000 &&
    int.parse(model.data!.totalReceive!.replaceAll(",", "")) < 1000000) {
    startcount = "3";
    } else if (int.parse(model.data!.totalReceive!.replaceAll(",", "")) >=
    1000000 &&
    int.parse(model.data!.totalReceive!.replaceAll(",", "")) < 2000000) {
    startcount = "4";
    } else if (int.parse(model.data!.totalReceive!.replaceAll(",", "")) >=
    2000000) {
    startcount = "5";
    } else {
    startcount = "0";
    }
    }else{
      startcount = "0";
    }
    setState(() {});
  }

  void openBeansView() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.80,
              minChildSize: 0.60,
              maxChildSize: 0.80,
              builder: (context, scrollController) {
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 50,
                            ),
                            height: MediaQuery.of(context).size.height * .07,
                            child: Row(
                              children: [
                                Expanded(
                                    child: TabBar(
                                  labelStyle: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                  unselectedLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                  indicatorColor: Colors.red,
                                  labelColor: Colors.red,
                                  unselectedLabelColor: Colors.black,
                                  tabs: [
                                    Container(
                                      child: Text(
                                        "Daily",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Weekly",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Monthly",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: TabBarView(
                              physics: ScrollPhysics(),
                              children: [
                                FutureBuilder<BeansModel>(
                                  future: ProfileUpdateServices()
                                      .getBeansInfo("daily", uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.data!.ledger![0].userName!.isEmpty) {
                                        return Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "No data found",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Text(
                                              "Total Beans :${snapshot.data?.data?.totalReceive??""}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    shrinkWrap: false,
                                                    itemCount: snapshot.data?.data?.ledger?.length??0,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return listItem(
                                                          context,
                                                          index,
                                                          snapshot.data!.data!.ledger!);
                                                    })),
                                          ],
                                        );
                                      }
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                FutureBuilder<BeansModel>(
                                  future: ProfileUpdateServices()
                                      .getBeansInfo("weekly", uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.data!.ledger![0].userName!.isEmpty) {
                                        return Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "No data found",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Text(
                                              "Total Beans :${snapshot.data?.data?.totalReceive??""}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    shrinkWrap: false,
                                                    itemCount: snapshot.data?.data?.ledger?.length??0,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return listItem(
                                                          context,
                                                          index,
                                                          snapshot.data!.data!.ledger!);
                                                    })),
                                          ],
                                        );
                                      }
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                FutureBuilder<BeansModel>(
                                  future: ProfileUpdateServices()
                                      .getBeansInfo("monthly", uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.data!.ledger![0].userName!.isEmpty) {
                                        return Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "No data found",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Text(
                                              "Total Beans :${snapshot.data!.data!.totalReceive}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    shrinkWrap: false,
                                                    itemCount: snapshot.data!.data!.ledger!.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return listItem(
                                                          context,
                                                          index,
                                                          snapshot.data!.data!.ledger!);
                                                    })),
                                          ],
                                        );
                                      }
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ));
              },
            );
          });
        });
  }
}

class StarCoinViewer extends StatelessWidget {
  final String? image;
  final String ?value;

  StarCoinViewer({this.image, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("images/${image}"),
          SizedBox(
            width: 3,
          ),
          Text(
            value??"",
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
