import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:hdlive_latest/services/level_service.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:hdlive_latest/services/userfollowservice.dart';
import 'package:hdlive_latest/utils/utility.dart';

import 'screens/profile_locations.dart';

class Viewprofile_model extends StatefulWidget {
  Viewprofile_model({
    this.image,
    this.name,
    this.uniqueId,
    this.bio,
    this.coverphoto,
    this.gender,
    this.image2,
    this.countryName,
    this.userId,
    this.userModel,
    this.isBrodcaster,
    this.channelName,
    this.broadcaster = false,
  });
  String? image;
  String? image2;
  String? bio;
  String? countryName;
  String? gender;
  String? name;
  String? uniqueId;
  String? coverphoto;
  String? userId;
  String? channelName;
  CurrentUserModel? userModel;
  bool? isBrodcaster;
  bool? broadcaster;

  @override
  _Viewprofile_modelState createState() => _Viewprofile_modelState();
}

class _Viewprofile_modelState extends State<Viewprofile_model> {

  bool isShow = true;
  int status =0;
  @override
  void initState() {
    if(!widget.isBrodcaster!) {
      getFollowStatus();
    }
    super.initState();
  }

  Future<void> getFollowStatus() async {

    FollowModel? model =  await  UserFollowService().checkFollowStatus(widget.userId!);
    FollowModel? model1 = await UserFollowService().checkFriendStatus(widget.userId!);

    setState(() {
      isShow = false;
      if(model!.data!.following! && model1!.data!.following!){
        status = 3;
      }else if(!model!.data!.following! && !model1!.data!.following!){
        status = 0;
      }else if(model!.data!.following! && !model1!.data!.following!){
        status = 1;
      }else if(!model!.data!.following! && model1!.data!.following!){
        status = 2;
      }

    });
  }

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
              // padding: EdgeInsets.only(left: width * 0.25 + 30, top: 10.sp),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          decoration:widget.coverphoto != "" ? BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(widget?.coverphoto??""),
                                  fit: BoxFit.cover))
                              :BoxDecoration(
                              image: DecorationImage(
                                  image: ExactAssetImage("images/profile.jpeg"),
                                  fit: BoxFit.fill)),
                        ),
                        !widget.broadcaster!?
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0,left: 10.0),
                          child: GestureDetector(onTap: (){
                            Utility().isUserBlock(context,widget?.userModel?.userId??"","block",widget?.channelName??"");
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              widget.image == null
                                  ? InitIconContainer(radius: width * 0.25, text: widget.name,)
                                  : Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: widget.gender == "Male"
                                                  ? Color(0xff3a9bdc)
                                                  : Color(0xfffe6f5e)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: width * 0.125,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(width * 0.125),
                                                  child: HexagonProfilePicNetworkImage(url: widget?.image??"")),
                                            ),
                                          ),
                                        ),
                                        ProfileLocation(
                                          location: widget.countryName != null
                                              ? "Bangladesh"
                                              : widget.countryName??"",
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
                                    padding: const EdgeInsets.only(top: 15.0, left: 5),
                                    child: Text(
                                      widget.name ?? "N/A",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'ID : ${widget.uniqueId}',
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
                                          future: LevelService().getUserLevel(widget.userId??"").then((value) => value??Levelmodel()),
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
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 10,
                                                          backgroundImage:
                                                              NetworkImage(snapshot.data?.data?.blIcon??""),
                                                        ),
                                                        SizedBox(
                                                          width: 7,
                                                        ),

                                                        Text(
                                                          "BL.${snapshot.data?.data?.broadcastingLevel??""}",
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
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
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
                                            gradient: LinearGradient(begin: Alignment.centerRight, end: Alignment.centerLeft,
                                            colors: [
                                            Color(int.parse(
                                            "${snapshot.data!.data!.rlColorCode!.replaceFirst("#", "0xff")}")), Colors.black87
                                            ],
                                            )),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                            children: [CircleAvatar(radius: 12, backgroundImage: NetworkImage(snapshot.data?.data?.rlIcon??""),),
                                            SizedBox(width: 7,),
                                            Text(
                                            "LV.${snapshot.data?.data?.runningLevel??""}",
                                            style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 10),
                                            ),
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
                          widget.bio != null
                              ? Text(widget?.bio??"",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                              : Text(''),



                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0,left: 15,right: 15),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          widget.isBrodcaster != true?Expanded(
                              flex: 1,
                              child:GestureDetector(
                                onTap: () async {
                                  await UserFollowService().getFollowFollowing(widget.userId!);
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

                          ):
                          Container(),
                          SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          widget.isBrodcaster != true?Expanded(
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

                          ):
                          Container(),
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
          );

          // return Column(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         CircleAvatar(
          //           radius: 30,
          //           backgroundImage: widget.image != null
          //               ? NetworkImage(widget.image)
          //               : Image.asset('images/profile.png'),
          //         ),
          //         SizedBox(
          //           width: 18,
          //         ),
          //         Icon(
          //           Icons.edit,
          //           color: Colors.red,
          //           size: 15,
          //         ),
          //       ],
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           widget.name,
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         Image.asset(
          //           'images/verifyIcon.png',
          //           height: 20.h,
          //           width: 20.w,
          //         ),
          //         // ChipIcon(
          //         //   color: [
          //         //     leveldata.data.colorCode.isNotEmpty
          //         //         ? Color(int.parse(
          //         //             "${leveldata.data.colorCode.replaceFirst("#", "0xff")}"))
          //         //         : Colors.black87,
          //         //     Colors.black87
          //         //   ],
          //         // )
          //       ],
          //     )
          //   ],
          // );
        },
      );
    });
  }
}
