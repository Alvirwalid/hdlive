import 'package:flutter/material.dart';
import 'package:hdlive_latest/screens/profile/follower_page.dart';
import 'package:hdlive_latest/screens/profile/following_page.dart';
import 'package:hdlive_latest/screens/profile/friend_page.dart';

import 'edit/new_edit_profile_landing.dart';


class ProfileFollowInfos extends StatelessWidget {
  final Function? onStartListen;
  var fans;
  var following;
  var friend;
  ProfileFollowInfos({this.fans, this.following, this.friend,this.onStartListen});



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FriendPage();
              }));
            },
            child: FollowBlocks(
              number: friend.toString(),
              label: "Friends",
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FollowingPage();
              }));
            },
            child: FollowBlocks(
              number: following.toString(),
              label: "Following",
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Follower();
              }));
            },
            child: FollowBlocks(
              number: fans.toString(),
              label: "Follower",
            ),
          ),
        ],
      ),
    );
  }


}

class OtherProfileFollowInfos extends StatelessWidget {
  final int? fans;
  final int? following;
  final int? friends;

  OtherProfileFollowInfos({this.fans, this.following, this.friends});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FollowBlocks(
            number: fans.toString(),
            label: "Fans",
          ),
          FollowBlocks(
            number: following.toString(),
            label: "Following",
          ),
          FollowBlocks(
            number: friends.toString(),
            label: "Friends",
          ),
        ],
      ),
    );
  }
}

class FollowBlocks extends StatelessWidget {
  final String? number;
  final String? label;
  FollowBlocks({this.number, this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            number??"",
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            label??"",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          )
        ],
      ),
    );
  }
}
