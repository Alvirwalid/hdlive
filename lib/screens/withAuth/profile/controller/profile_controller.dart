import 'package:flutter/material.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';

import '../../../../services/follow_friend_services.dart';

class ProfileController {
  final BuildContext context;

  ProfileController({required this.context});

  FollowFriendServices ser = FollowFriendServices();
  followSomeone({userId}) async {
    floatingLoading(context);
    await ser.followSomeone(userId: userId);
    Navigator.of(context).pop();
  }

  Future<String> reportSomeone({userId}) async {
    String? returned = await ser.reportUser(reportedUserid: userId);
    return returned ?? "Please try again";
  }

  Future<String> blockSomeone({userId}) async {
    String? retuned = await ser.blockSomeone(userId: userId);
    return retuned ?? "Please try again";
  }
}
