import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/followerModel.dart';
import 'package:hdlive_latest/screens/profile/user_profile_dailog.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/follower_following_service/follower_following.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  bool isLoad = false;
  int position = -1;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black54)),
        title: Text(
          'Followings',
          style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
              fontSize: 18.sp),
        ),
      ),
      body: FutureBuilder(
        future: FollowService().getFollowingList(),
        builder: (context,AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData) {
            print('Snapshot Dat === ${snapshot.data}');

            if (json
                .decode(snapshot.data!)['msg']
                .toString()
                .contains('you are not following anyone!')) {
              return Center(
                child: Text(
                  'you are not following anyone!',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
              );
            } else {
              FollowerModel data = followerModelFromJson(snapshot.data!);
              return ListView.builder(
                  itemCount: data.data!.following!.length,
                  itemBuilder: (context, index) {
                    var datas = data.data!.following![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String status = "";
                                if( datas!.isFollowing!.contains('yes') &&
                                    datas.isFollower!.contains('yes')){
                                  status = "Friends";
                                }else {
                                  status = "Following";
                                }

                                CurrentUserModel?  userModel = await ProfileUpdateServices().getUserProfile(datas.userId);
                                Future<void> future = showModalBottomSheet<void>(
                                  context: context,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  builder: (BuildContext context) {
                                    return UserProfileDailog(userModel:userModel!,status:status,);
                                  },
                                );
                                future.whenComplete(() =>  setState(() {

                                }));
                              },
                              child:  CircleAvatar(
                                radius: 25.r,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(datas.image??""),
                              ),
                            ),

                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                datas.name??"",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              ),
                            ),
                            Spacer(),
                            datas!.isFollowing!.contains('yes') &&
                                    datas.isFollower!.contains('yes')
                                ? GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoad = true;
                                    position = index;
                                  });
                                  print(
                                      "useriddd======${data.data!.following![index].userId}");
                                  var datas = await FollowService().getfolllow(data.data!.following![index].userId!);
                                  var rep = json.decode(datas);
                                  print('Reply DAta  ==== ${rep}');
                                  setState(() {
                                    position = -1;
                                    isLoad = false;
                                  });

                                  //    Navigator.pop(context)
                                },
                                child:isLoad && position == index ?Loading(): Image.asset(
                                    'images/exchange.png',
                                    fit: BoxFit.cover,
                                    width: 20.w,
                                    height: 20.h,
                                    color: Colors.black26,
                                  ))
                                : datas.isFollowing!.contains("yes") &&
                                        datas.isFollower!.contains("no")
                                    ? GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            isLoad = true;
                                            position = index;
                                          });
                                          print(
                                              "useriddd======${data.data!.following![index].userId}");
                                          var datas = await FollowService()
                                              !.getfolllow(data.data!.following![index].userId!);
                                          var rep = json.decode(datas);
                                          print('Reply DAta  ==== ${rep}');
                                          setState(() {
                                            position = -1;
                                            isLoad = false;
                                          });

                                          //    Navigator.pop(context)
                                        },
                                        child:isLoad && position == index?Loading(): Icon(
                                          Icons.check,
                                          color: Colors.red.shade900,
                                        ),
                                      )
                                    : Container(),
                            SizedBox(
                              width: 15.w,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'ERROR',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Center(
              // child: CircularProgressIndicator(),
              child: Loading(),
            );
          }
        },
      ),
    );
  }
}
