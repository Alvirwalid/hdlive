import 'package:flutter/material.dart';
import '../follow/other_user_profile.dart';
class OthersProfileRedirectionWidget extends StatelessWidget {

  final Widget? child;
  final String? userId;

  OthersProfileRedirectionWidget({this.child,this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OtherUserProfile(userId:userId??"",)));
      },
      child: Container(
        child: child,
      ),
    );
  }
}
