import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/followerModel.dart';
import 'package:hdlive_latest/screens/profile/user_profile_dailog.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/follower_following_service/follower_following.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';

class Follower extends StatefulWidget {
  const Follower({Key? key}) : super(key: key);

  @override
  _FollowerState createState() => _FollowerState();
}

class _FollowerState extends State<Follower> {

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
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
        title: Text(
          'Follower',
          style: TextStyle(
              color: Colors.black54,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: FollowService().getFollowerList(),
        builder: (context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData) {
            if (json.decode(snapshot.data!)['msg']
                .toString()
                .contains('No Fans available!')) {
              return Center(
                child: Text(
                  'No Fans available!',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
              );
            } else {
              FollowerModel data = followerModelFromJson(snapshot.data!);
              return ListView.builder(
                  itemCount: data.data?.following?.length??0,
                  itemBuilder: (context, index) {
                    var datas = data.data?.following?[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 8.0,bottom: 8.0,right: 0.0),
                      child: Container(
                        height: height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String status = "";
                                if(datas!.isFollowing!.contains('yes') &&
                                    datas!.isFollower!.contains('yes')){
                                  status = "Friends";
                                }else {
                                  status = "Follower";
                                }

                                CurrentUserModel?  userModel = await ProfileUpdateServices().getUserProfile(datas.userId);
                                Future<void> future = showModalBottomSheet<void>(
                                  context: context,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  builder: (BuildContext context) {
                                    return UserProfileDailog(userModel:userModel!,status: status,);
                                  },
                                );
                                future.whenComplete(() =>  setState(() {

                                }));
                              },
                              child:  CircleAvatar(
                                radius: 25.r,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(datas?.image??""),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                datas?.name??"",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoad = true;
                                    position = index;
                                  });
                                  var datas = await FollowService().getfolllow(
                                      data.data!.following![index].userId!);
                                  var rep = json.decode(datas);
                                  setState(() {
                                    isLoad = false;
                                    position = -1;
                                  });

                                  //    Navigator.pop(context)
                                },
                                child:isLoad && position == index?Loading(): datas!.isFollowing!.contains('yes') &&
                                        datas.isFollower!.contains('yes')
                                    ? Image.asset(
                                        'images/exchange.png',
                                        fit: BoxFit.cover,
                                        width: 16.w,
                                        height: 16.h,
                                        color: Colors.black26,
                                      )
                                    : Icon(
                                        Icons.add,
                                        color: Colors.red.shade200,
                                      )),
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
