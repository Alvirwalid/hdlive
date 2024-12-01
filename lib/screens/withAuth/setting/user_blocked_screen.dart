import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hdlive_latest/models/blocked_user_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/userfollowservice.dart';
class UserBlockedScreen extends StatefulWidget {
  const UserBlockedScreen({Key? key}) : super(key: key);

  @override
  _UserBlockedScreenState createState() => _UserBlockedScreenState();
}

class _UserBlockedScreenState extends State<UserBlockedScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
          'User Blocked',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder(
        future: UserFollowService().getBlockedList(),
        builder: (context, AsyncSnapshot<dynamic>snapshot) {
          if (snapshot.hasData) {
            if (json.decode(snapshot.data)['error']) {
              return Center(
                child: Text(
                  'No Block User Available!',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              );
            } else {
              BlockedUserModel data = followerModelFromJson(snapshot.data);
              return ListView.builder(
                  itemCount: data.data?.blockedusers?.length??0,
                  itemBuilder: (context, index) {
                    var datas = data.data?.blockedusers?[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 8.0,bottom: 8.0,right: 0.0),
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
                                // String status = "";
                                // if(datas.isFollowing.contains('yes') &&
                                //     datas.isFollower.contains('yes')){
                                //   status = "Friends";
                                // }else {
                                //   status = "Follower";
                                // }
                                //
                                // CurrentUserModel  userModel = await ProfileUpdateServices().getUserProfile(datas.userId);
                                // Future<void> future = showModalBottomSheet<void>(
                                //   context: context,
                                //   isDismissible: true,
                                //   isScrollControlled: true,
                                //   backgroundColor: Colors.white,
                                //   builder: (BuildContext context) {
                                //     return UserProfileDailog(userModel:userModel,status: status,);
                                //   },
                                // );
                                // future.whenComplete(() =>  setState(() {
                                //
                                // }));
                              },
                              child:  CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(datas?.image??""),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                datas?.name??"",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                return showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context)
                                  {
                                    return AlertDialog(
                                      title: Text('Are you sure you want to unblock this user?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            bool i = await UserFollowService().blockUser(datas?.userId??"", "unblock");
                                            if(!i){
                                              setState(() {
                                                data.data?.blockedusers?.removeAt(index);
                                              });
                                            }
                                          },
                                          child: Text('Yes',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                        ),
                                      ],
                                    );
                                  },);

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red.shade700,
                                    borderRadius: BorderRadius.circular(20)),
                                height: 20,
                                width: 70,
                                child: Center(
                                  child: Text(
                                    'UnBlock',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
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

