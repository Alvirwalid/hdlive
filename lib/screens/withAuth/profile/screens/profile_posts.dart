import 'package:flutter/material.dart';

class ProfilePosts extends StatefulWidget {
  @override
  _ProfilePostsState createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Text("No Posts Found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
    );
  }
}
