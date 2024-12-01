import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/level_model.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/profile_follow_infos.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/profile_locations.dart';
import 'package:hdlive_latest/services/level_service.dart';
import 'package:hdlive_latest/services/userfollowservice.dart';
import 'package:hdlive_latest/utils/utility.dart';

class UserProfileDailog extends StatefulWidget {
  UserProfileDailog({this.userModel, this.status, this.broadcaster = false,this.channelName});

  CurrentUserModel? userModel;
  String? status;
  bool? broadcaster;
  String? channelName;

  @override
  _UserProfileDailogState createState() => _UserProfileDailogState();
}

class _UserProfileDailogState extends State<UserProfileDailog> {
  bool isLoader = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, state) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: .5,
        minChildSize: .5,
        maxChildSize: .5,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: height * 0.20,
                          width: MediaQuery.of(context).size.width,
                          decoration: widget.userModel?.coverPhotos?[0].image != ""
                              ? BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.userModel?.coverPhotos?[0].image??""),
                                      fit: BoxFit.cover))
                              : BoxDecoration(
                                  image: DecorationImage(
                                      image: ExactAssetImage("images/profile.jpeg"),
                                      fit: BoxFit.fill)),
                        ),
                        widget.broadcaster!?
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0,left: 10.0),
                          child: GestureDetector(onTap: (){
                            Utility().isUserBlock(context,widget.userModel!.userId!,"block",widget.channelName??"");
                          },
                            child: Text(
                              " Manage ",
                              style: TextStyle(
                                  color:Colors.white ,
                                  backgroundColor: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.sp),
                            ),
                          ),
                        ):Container(),
                      ],
                    ),
                    Transform.translate(
                      transformHitTests: true,
                      offset: Offset(0, -50),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                widget.userModel!.image == null
                                    ? InitIconContainer(
                                        radius: width * 0.25,
                                        text: widget.userModel?.name??"",
                                      )
                                    : Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    widget.userModel!.gender ==
                                                            "Male"
                                                        ? Color(0xff3a9bdc)
                                                        : Color(0xfffe6f5e)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                radius: width * 0.125,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            width * 0.125),
                                                    child:
                                                        HexagonProfilePicNetworkImage(url: widget.userModel?.image??"")),
                                              ),
                                            ),
                                          ),
                                          ProfileLocation(
                                            location: widget.userModel?.countryName != null
                                                ? "Bangladesh"
                                                : widget.userModel?.countryName??"",
                                          ),
                                        ],
                                      ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 5),
                                      child: Text(
                                        widget.userModel?.name ?? "N/A",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            'ID : ${widget.userModel!.uniqueId??""}',
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          widget.userModel?.users_verify == "1"
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
                                            future: LevelService().getUserLevel(widget.userModel!.userId!).then((e)=>e??Levelmodel()),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Row(
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                      padding: EdgeInsets.zero,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .centerRight,
                                                            end: Alignment
                                                                .centerLeft,
                                                            colors: [
                                                              Color(int.parse(
                                                                  "${snapshot.data!.data!.blColorCode!.replaceFirst("#", "0xff")}")),
                                                              Colors.black87
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
                                                                NetworkImage(snapshot.data?.data?.blIcon??""),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),

                                                          Text(
                                                            "BL.${snapshot.data!.data!.broadcastingLevel}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 10),
                                                          ),
                                                          //    Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Container(
                                                      height: 20,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                      padding: EdgeInsets.zero,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .centerRight,
                                                            end: Alignment
                                                                .centerLeft,
                                                            colors: [
                                                              Color(int.parse(
                                                                  "${snapshot.data!.data!.rlColorCode!.replaceFirst("#", "0xff")}")),
                                                              Colors.black87
                                                            ],
                                                          )),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 12,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    snapshot.data?.data?.rlIcon??""),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
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
                                                                fontSize: 10),
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
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FollowBlocks(
                                    number:
                                        widget.userModel!.friendCount.toString(),
                                    label: "Friends",
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  FollowBlocks(
                                    number:
                                        widget.userModel!.followCount.toString(),
                                    label: "Following",
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  FollowBlocks(
                                    number:
                                        widget.userModel!.fanCount.toString(),
                                    label: "Follower",
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            isLoader = true;
                                          });
                                          await UserFollowService().getFollowFollowing(widget.userModel!.userId!);
                                          widget.status == "Friends" || widget.status == "Following"
                                              ? Navigator.pop(context)
                                              : setState(() {
                                                  widget.status = "Friend";
                                                  isLoader = false;
                                                });
                                        },
                                        child: isLoader
                                            ? Loading()
                                            : widget.status == "Friend" ? Container(
                                                    padding: const EdgeInsets.all(5.0),
                                                    decoration: BoxDecoration(color: Color(0xC2929090),
                                                        borderRadius: BorderRadius.circular(35)),
                                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'images/exchange.png',
                                                          fit: BoxFit.cover,
                                                          width: 16.w,
                                                          height: 16.h,
                                                          color: Colors.black26,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text("Friend",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15.sp),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : widget.status == "Follower"
                                                    ? Container(
                                                        padding: const EdgeInsets.all(5.0),
                                                        decoration: BoxDecoration(
                                                            color: Color(0xC2929090),
                                                            borderRadius: BorderRadius.circular(35)),
                                                        child: Text(
                                                          "Follow back",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15.sp),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding:
                                                            const EdgeInsets.all(5.0),
                                                        decoration: BoxDecoration(
                                                            color: Color(0xC2929090),
                                                            borderRadius: BorderRadius.circular(35)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [Icon(Icons.check, size: 18),
                                                            SizedBox(width: 5,),
                                                            Text("Following",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 15.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                              color: Color(0xC2F90000),
                                              borderRadius:
                                                  BorderRadius.circular(35)),
                                          child: Text(
                                            "Chat",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.sp),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    width: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
