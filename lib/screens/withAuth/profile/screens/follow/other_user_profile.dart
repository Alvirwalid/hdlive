import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:hdlive_latest/bloc/profile_bloc/profile_bloc.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/screens/shared/chip_icon.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/screens/shared/no_image_found.dart';
import 'package:ionicons/ionicons.dart';

import '../../controller/profile_controller.dart';
import '../profile.dart';
import '../profile_follow_infos.dart';
import '../profile_locations.dart';
import '../profile_posts.dart';
import '../profile_profile.dart';
import '../profile_tags.dart';
import '../profile_video.dart';

class OtherUserProfile extends StatefulWidget {
  final String? userId;
  OtherUserProfile({this.userId});
  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  ProfileBloc _bloc = ProfileBloc();
  int activeIdx = 2;
  @override
  void initState() {
    _bloc.add(FetchProfileInfo(me: false, id: widget.userId));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      //  bottomNavigationBar:
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
                if (user.coverPhotos!.length > 0) {
                  user.coverPhotos?.forEach((value) {
                    coverPic.add(CachedNetworkImage(
                      imageUrl: value.image??"",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: height * .4,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Container(width: 20, child: Loading()),
                      errorWidget: (context, url, error) => Image.asset(
                        "images/profile.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ));
                  });
                }

                List<String> tags = [];
                // if (user.tags.length > 0) {
                //   user.tags.forEach((element) {
                //     tags.add(element.name);
                //   });
                // }
                IconData genderData = Ionicons.male_female;
                if (user.gender == "Male")
                  genderData = Ionicons.male;
                else if (user.gender == 'Female') genderData = Ionicons.female;

                bool following = user.isFollowing??false;
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
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
                                              child: NoImageFoundCoverPhoto(),
                                              height: height * 0.4,
                                            ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: width * 0.25 + 10, top: 10),
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
                                                    fontSize: 15),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'ID : ${user.uniqueId}',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    ChipIcon(
                                                      color: [
                                                        Colors.black87,
                                                        Colors.orange
                                                      ],
                                                      avater: Icon(
                                                        genderData,
                                                        color: Colors.red,
                                                      ),
                                                      text: "0",
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    ChipIcon(
                                                      color: [
                                                        Colors.white,
                                                        Colors.red
                                                      ],
                                                      avater: Text(
                                                        "LV.",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      text: 0.toString(),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ProfileLocation(
                                        location: user.countryName ?? "N/A",
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      ProfileTags(tags: tags),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      OtherProfileFollowInfos(
                                        fans: user.fanCount ?? 0,
                                        following: user.followCount ?? 0,
                                        friends: user.friendCount ?? 0,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        thickness: 5,
                                      ),
                                      Material(
                                        elevation: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            LiveOptionsProfile(
                                              option: "POST",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.12,
                                              active: activeIdx == 0,
                                              onTap: () {
                                                setState(() {
                                                  activeIdx = 0;
                                                });
                                              },
                                            ),
                                            LiveOptionsProfile(
                                              option: "VIDEO",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.12,
                                              active: activeIdx == 1,
                                              onTap: () {
                                                setState(() {
                                                  activeIdx = 1;
                                                });
                                              },
                                            ),
                                            LiveOptionsProfile(
                                              option: "PROFILE",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.17,
                                              active: activeIdx == 2,
                                              onTap: () {
                                                setState(() {
                                                  activeIdx = 2;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      activeIdx == 0
                                          ? ProfilePosts()
                                          : activeIdx == 1
                                              ? ProfileVideo()
                                              : ProfileProfile(
                                                  profileInfoModel: user,
                                                ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                //Profile Pic
                                Positioned(
                                    top: height * .4 - width * 0.125,
                                    left: 5,
                                    child: state.user?.image == null
                                        ? InitIconContainer(
                                            radius: width * 0.25,
                                            text: state.user?.name,
                                          )
                                        : CircleAvatar(
                                            radius: width * 0.125,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        width * 0.125),
                                                child:
                                                    HexagonProfilePicNetworkImage(
                                                        url: state.user?.image)),
                                          )
                                    //   : Image(image: NetworkImage(state.user.image),height: 120,width:width * 0.25 ,fit: BoxFit.fill,),
                                    ),

                                //block report User
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      //   showDialog(context: context, builder: (BuildContext context) =>ReportBlockDialog()  );
                                      showSimpledialog(
                                          context: context,
                                          widget: ReportBlockDialog(
                                            user: user,
                                          ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Material(
                        elevation: 15,
                        shadowColor: Colors.grey,
                        child: Container(
                          height: 60,
                          width: width,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // follow button
                              MaterialButton(
                                minWidth: width / 2.5,
                                color: primaryColor,
                                onPressed: () async {
                                  if (!user.isFollowing!) {
                                    await ProfileController(context: context)
                                        .followSomeone(userId: user.userId);

                                    setState(() {
                                      user.isFollowing = true;
                                    });
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: primaryColor)),
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Icon(
                                      user.isFollowing!
                                          ? Icons.check
                                          : Icons.add,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                  Text(
                                      user.isFollowing! ? "Following" : "Follow",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                ]),
                              ),

                              MaterialButton(
                                minWidth: width / 2.5,
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: primaryColor)),
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Icon(
                                      Icons.message,
                                      color: primaryColor,
                                      size: 14,
                                    ),
                                  ),
                                  Text("Chat",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                ]),
                              ),
                            ],
                          ),
                          // child: Text("dskjfhjk"),
                        ),
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
            },
          ),
        ),
      ),
    );
  }
}

showSimpledialog({required BuildContext context, required Widget widget}) {
  return showDialog(
      context: context, builder: (BuildContext context) => widget);
}

class ReportBlockDialog extends StatelessWidget {
  final CurrentUserModel? user;
  ReportBlockDialog({this.user});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      children: [
        MaterialButton(
          onPressed: () async {
            floatingLoading(context);
            String reterned = await ProfileController(context: context)
                .reportSomeone(userId: user?.userId??"");
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            // CoolAlert.show(context: context, type: CoolAlertType.loading,barrierDismissible: false);
            showSimpledialog(
                context: context,
                widget: ReportSuccessfullDialog(
                  dialoge: reterned ?? "Please try again.",
                ));
          },
          child: Text(
            "REPORT",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
            showSimpledialog(
                context: context,
                widget: ConfirmBlockDialog(
                  user: user??CurrentUserModel(),
                ));
          },
          child: Text("BLOCK",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: primaryColor)),
        )
      ],
    );
  }
}

class ConfirmBlockDialog extends StatelessWidget {
  final CurrentUserModel? user;
  ConfirmBlockDialog({this.user});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.block,
            color: primaryColor,
            size: 50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(thickness: 1),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: EasyRichText(
            "ARE YOU WANT TO BLOCK ${user?.name}",
            defaultStyle: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
            patternList: [
              EasyRichTextPattern(
                  targetString: "BLOCK", style: TextStyle(color: primaryColor)),
              EasyRichTextPattern(
                  targetString: '${user?.name}',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: MaterialButton(
            minWidth: 150,
            onPressed: () async {
              // Navigator.of(context).pop();
              // floatingLoading(context);
              floatingLoading(context);
              String reterned = await ProfileController(context: context)
                  .blockSomeone(userId: user?.userId??"");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              showSimpledialog(
                  context: context,
                  widget: ReportSuccessfullDialog(
                    dialoge: reterned ?? "Please try again",
                  ));
              //  CoolAlert.show(context: context, type: CoolAlertType.loading,barrierDismissible: false);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: primaryColor)),
            child: Text(
              "BLOCK",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
        ),
        Center(
          child: MaterialButton(
            minWidth: 150,
            onPressed: () {
              Navigator.of(context).pop();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Color(0xFF707070))),
            child: Text(
              "CANCEL",
              style: TextStyle(
                  color: Color(0xFF161523),
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
        )
      ],
    );
  }
}

class ReportSuccessfullDialog extends StatelessWidget {
  final String? dialoge;
  ReportSuccessfullDialog({this.dialoge});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      children: [
        MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              dialoge??"",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ))
      ],
    );
  }
}
