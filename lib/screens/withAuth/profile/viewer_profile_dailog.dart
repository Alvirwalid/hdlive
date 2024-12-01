import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/followmodel.dart';
import 'package:hdlive_latest/models/level_model.dart';
import 'package:hdlive_latest/models/live_model.dart';
import 'package:hdlive_latest/models/viewer_model.dart';
import 'package:hdlive_latest/screens/live/pages/gift_model.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/profile_follow_infos.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/profile_locations.dart';
import 'package:hdlive_latest/services/firestore_services.dart';
import 'package:hdlive_latest/services/level_service.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:hdlive_latest/services/userfollowservice.dart';
import 'package:hdlive_latest/utils/utility.dart';

class ViewerProfileDailog extends StatefulWidget {
  ViewerProfileDailog({this.userModel,
    this.channelName,
    this.viewer,
    this.broadcastUser,
    this.broadcaster,
    this.isVideo});
  CurrentUserModel? userModel;
  String? status;
  String? channelName;
  ViewerModel? viewer;
  LiveModel? broadcastUser;
  bool? broadcaster;
  bool? isVideo;


  @override
  _ViewerProfileDailogState createState() => _ViewerProfileDailogState();
}

class _ViewerProfileDailogState extends State<ViewerProfileDailog> {
  bool isShow = true;
  bool isUser = true;
  int status =0;
  int guestLive = 0;

  @override
  void initState() {
    getFollowStatus();
    super.initState();
  }

Future<void> getFollowStatus() async {
  var i = await TokenManagerServices().getData();
  if(i.userId != widget.userModel?.userId) {
    isUser = false;
    FollowModel? model = await UserFollowService().checkFollowStatus(widget.userModel?.userId??"");
    FollowModel? model1 = await UserFollowService().checkFriendStatus(widget.userModel?.userId??"");
    setState(() {
      isShow = false;
      if (model!.data!.following! && model1!.data!.following!) {
        status = 3;
      } else if (!model.data!.following! && !model1!.data!.following!) {
        status = 0;
      } else if (model.data!.following! && !model1!.data!.following!) {
        status = 1;
      } else if (!model.data!.following! && model1!.data!.following!) {
        status = 2;
      }
    });
  }else {
    isUser = true;
  }
  if(widget.isVideo!) {
    FirestoreServices()
        .getVideoViewer(widget.channelName??"")
        !.forEach((element) {
      List<ViewerModel> viewers = element;
      guestLive = viewers.length;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, state) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: .45,
        minChildSize: 0.1,
        maxChildSize: 0.5,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                      child: Column(
                        children: [
                          Transform.translate(
                              transformHitTests: true,
                              offset: Offset(0, -50),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            widget.userModel?.image == null
                                                ? InitIconContainer(radius: width * 0.25, text: widget.userModel?.name,)
                                                : Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: widget.userModel?.gender == "Male"
                                                          ? Color(0xff3a9bdc)
                                                          : Color(0xfffe6f5e)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: CircleAvatar(
                                                      radius: width * 0.125,
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(width * 0.125),
                                                          child: HexagonProfilePicNetworkImage(url: widget.userModel?.image)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        widget.broadcaster!?
                                        Padding(
                                          padding: const EdgeInsets.only(top: 70.0,left: 10.0),
                                          child: GestureDetector(onTap: (){
                                            Utility().isUserBlock(context,widget.userModel?.userId??"","block",widget.channelName??"");
                                          },
                                            child: Text(
                                              "Manage",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11.sp),
                                            ),
                                          ),
                                        ):Container(),
                                      ],
                                    ),

                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 0.0, left: 5),
                                              child: Text(
                                                widget.userModel?.name ?? "N/A",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.sp),
                                              ),
                                            ),
                                            ProfileLocation(
                                              location: widget.userModel?.countryName != null
                                                  ? "Bangladesh"
                                                  : widget.userModel?.countryName??"",
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'ID : ${widget.userModel?.uniqueId}',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              widget.userModel?.users_verify == "1"? Image.asset(
                                                'images/verifyIcon.png',
                                                height: 20.h,
                                                width: 20.w,
                                              ):Image.asset(
                                                'images/unverified.jpg',
                                                height: 20.h,
                                                width: 20.w,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              FutureBuilder<Levelmodel>(
                                                future: LevelService().getUserLevel(widget.userModel?.userId??"").then((value) => value??Levelmodel()),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Row(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                              0.15,
                                                          padding: EdgeInsets.zero,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                              gradient: LinearGradient(
                                                                begin:
                                                                Alignment.centerRight,
                                                                end: Alignment.centerLeft,
                                                                colors: [
                                                                  Color(int.parse(
                                                                      "${snapshot.data!.data!.blColorCode!.replaceFirst("#", "0xff")}")),
                                                                  Colors.black87
                                                                ],
                                                              )),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 10,
                                                                backgroundImage:
                                                                NetworkImage(snapshot.data!.data!.blIcon??""),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text("BL.${snapshot.data!.data!.broadcastingLevel}",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontSize: 10),
                                                              ),
                                                              //    Spacer(),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 5.w,),
                                                        Container(
                                                          height: 20,
                                                          width: MediaQuery.of(context).size.width * 0.15,
                                                          padding: EdgeInsets.zero,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  20),
                                                              gradient: LinearGradient(
                                                                begin:
                                                                Alignment.centerRight,
                                                                end: Alignment.centerLeft,
                                                                colors: [
                                                                  Color(int.parse(
                                                                      "${snapshot.data!.data!.rlColorCode!.replaceFirst("#", "0xff")}")),
                                                                  Colors.black87
                                                                ],
                                                              )),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 12,
                                                                backgroundImage:
                                                                NetworkImage(snapshot.data?.data?.rlIcon??""),),
                                                              SizedBox(width: 10,),
                                                              // avater,
                                                              Text("LV.${snapshot.data?.data?.runningLevel??""}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                              ),
                                                              //    Spacer(),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
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
                                    widget.userModel?.bio != null
                                        ? Text(widget.userModel?.bio??"",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))
                                        : Text(''),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0,left: 15,right: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FollowBlocks(
                                            number: widget.userModel!.followCount.toString(),
                                            label: "Following",
                                          ),
                                          Spacer(),
                                          FollowBlocks(
                                            number: widget.userModel!.fanCount.toString(),
                                            label: "Follower",
                                          ),
                                          Spacer(),
                                          FollowBlocks(
                                            number: widget.userModel!.beansCount.toString(),
                                            label: "Beans",
                                          ),
                                          Spacer(),
                                          FollowBlocks(
                                            number: widget.userModel!.diamondcount.toString(),
                                            label: "Diamond",
                                          ),
                                        ],
                                      ),
                                    ),
                                    !isUser?
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child:GestureDetector(
                                                onTap: () async {
                                                  await UserFollowService().getFollowFollowing(widget.userModel?.userId??"");
                                                  setState(() {
                                                    if(status == 3) {
                                                      status = 2;
                                                    }else if(status == 2) {
                                                      status =3;
                                                    }else if(status == 1){
                                                      status = 0;
                                                    }else if(status == 0){
                                                      status = 1;
                                                    }
                                                  });
                                                },
                                                child:isShow ?Loading():status == 3 ? Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xC2929090),
                                                      borderRadius: BorderRadius.circular(35)),
                                                  child:  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset('images/exchange.png', fit: BoxFit.cover, width: 16.w, height: 16.h, color: Colors.black26,),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        "Friend",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 15.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ):
                                                status ==2? Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xC2929090),
                                                      borderRadius: BorderRadius.circular(35)),
                                                  child:  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset('images/exchange.png', fit: BoxFit.cover, width: 16.w, height: 16.h, color: Colors.black26,),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        "Follow back",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 15.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ):
                                                status == 0?Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xC2F90000),
                                                      borderRadius: BorderRadius.circular(35)),
                                                  child:  Text(
                                                    "Follow",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15.sp),
                                                  ),
                                                ) :Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xC2929090),
                                                      borderRadius: BorderRadius.circular(35)),
                                                  child:  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.check, size: 18),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        "Following",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 15.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )

                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          IconButton(
                                              iconSize: 40.0,
                                              onPressed:
                                                  () async {
                                                var i = await TokenManagerServices().getData();
                                                CurrentUserModel?  user = await ProfileUpdateServices().getUserInfo(i.userId, true);
                                                Navigator.pop(context);
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    isDismissible: true,
                                                    backgroundColor: Colors.transparent,
                                                    builder: (context) {
                                                      return Gift_Model(
                                                        user: user,
                                                        channelName: widget.channelName,
                                                        viewer: widget.viewer,
                                                        broadcastUser: widget.broadcastUser,
                                                      );
                                                    });

                                              },
                                              icon: Image.asset(
                                                  "images/Gift.png")),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          widget.broadcaster == true?
                                          Expanded(
                                              flex: 1,
                                              child:GestureDetector(
                                                onTap: (){
                                                  if(widget.isVideo!) {
                                                    if (guestLive < 2) {
                                                      FirestoreServices.sendInvition(widget.channelName??"",widget.viewer?.uid??"");
                                                      Navigator.pop(context);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: "Sorry! Maximum 2 Guest are Allow.");
                                                    }
                                                  }else{
                                                    FirestoreServices.sendInvition(widget.channelName??"",widget.viewer?.uid??"");
                                                    Navigator.pop(context);
                                                  }

                                                },
                                                child:Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xC22AF900),
                                                      borderRadius: BorderRadius.circular(35)),
                                                  child:  Text(
                                                    "Invite",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15.sp),
                                                  ),
                                                ) ,
                                              )

                                          ):
                                          Expanded(
                                              flex: 1,
                                              child:GestureDetector(
                                                onTap: (){
                                                },
                                                child:Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xC2F90000),
                                                      borderRadius: BorderRadius.circular(35)),
                                                  child:  Text(
                                                    "Chat",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15.sp),
                                                  ),
                                                ) ,
                                              )

                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),

                                        ],
                                      ),
                                    ):Container(
                                      child: SizedBox(height: 20,),
                                    ),
                                  ],
                                ),
                            ),
                        ],
                      ),
                    ),
            ),
          );

        },
      );
    });
  }
}
