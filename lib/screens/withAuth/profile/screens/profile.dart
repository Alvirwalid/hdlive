

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:hdlive_latest/bloc/profile_bloc/profile_bloc.dart';
import 'package:hdlive_latest/screens/shared/bloc_error_state.dart';
import 'package:hdlive_latest/screens/shared/chip_icon.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/no_image_found.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/profile_follow_infos.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/profile_tags.dart';
import 'package:ionicons/ionicons.dart';
import 'package:location/location.dart';

import '../../../../models/current_user_model.dart';
import 'profile_locations.dart';
import 'profile_posts.dart';
import 'profile_profile.dart';
import 'profile_video.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileBloc _bloc = ProfileBloc();
  int activeIdx = 2;

  @override
  void initState() {
    _bloc.add(FetchProfileInfo());
    super.initState();
  }

  var image;

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
      body: SafeArea(
          child: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is ProfileFetching) {
            return Loading();
          } else if (state is ProfileFetched) {
            int gender = 0; //TODO:: change later after api change
            IconData iconData;
            if (gender == 0) {
              iconData = Ionicons.male;
            } else if (gender == 1) {
              iconData = Ionicons.female;
            } else {
              iconData = Ionicons.male_female;
            }

            List<Widget> coverPicSlide = [
              NoImageFoundCoverPhoto(
                onTap: () {
                  Navigator.of(context).pushNamed("/edit_profile",
                      arguments: state.user?.coverPhotos);
                },
              ),
              NoImageFoundCoverPhoto(
                onTap: () {
                  Navigator.of(context).pushNamed("/edit_profile",
                      arguments: state.user?.coverPhotos);
                },
              ),
              NoImageFoundCoverPhoto(
                onTap: () {
                  Navigator.of(context).pushNamed("/edit_profile",
                      arguments: state.user?.coverPhotos);
                },
              ),
            ];

            //TODO:: change when cover pics exists
            return Container(
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
                              ImageSlideshow(
                                children: coverPicSlide,
                                indicatorColor: Colors.white,
                                initialPage: 1,
                                width: double.infinity,
                                height: height * 0.4,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: width * 0.25 + 15, top: 10),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.user?.name ?? "N/A",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            ChipIcon(
                                              avater: Icon(
                                                iconData,
                                                color: Colors.red,
                                              ),
                                              text: "0",
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ChipIcon(
                                              avater: Text(
                                                "LV.",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              text: "0".toString(),
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
                                location: state.user?.countryName ?? "N/A",
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ProfileTags(
                                tags: [], //TODO::need to change tags
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              ProfileFollowInfos(
                                  //TODO:: need to change profile follow info
                                  fans: 0,
                                  following: 0,
                                  friend: 0),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.grey[400]!),
                                        borderRadius: BorderRadius.circular(5)))
                                  ),
                                  onPressed: () {
                                    //   Navigator.of(context).pushNamed("/edit_profile",arguments: state.userInfoModel);
                                  },
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
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
                                      width: MediaQuery.of(context).size.width *
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
                                      width: MediaQuery.of(context).size.width *
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
                                      width: MediaQuery.of(context).size.width *
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
                                          profileInfoModel: state.user??CurrentUserModel(),
                                        ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.person_add_alt_1,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: height * .4 - 60,
                          left: 10,
                          child: state.user?.image == null
                              ? InitIconContainer(
                                  radius: width * 0.25,
                                  text: state.user?.name,
                                )
                              : Image(
                                  image: NetworkImage(state.user?.image??""),
                                  height: 120,
                                  width: width * 0.25,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return BlocErrorState();
          }
        },
      )),
    );
  }

}

class LiveOptionsProfile extends StatelessWidget {
  final String? option;
  final double? width;
  final bool? active;
  final Function? onTap;
  LiveOptionsProfile({this.option, this.width, this.active, this.onTap});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap!(),
      child: Container(
        width: width,
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              child: Text(
                option??"",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: active! ? Colors.red : Colors.black,
                    fontSize: 13),
              ),
            ),
            active!
                ? Divider(
                    color: Colors.red,
                    height: 15,
                    thickness: 2,
                  )
                : Container(
                    height: 15,
                  ),
          ],
        ),
      ),
    );
  }
}
