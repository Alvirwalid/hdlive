import 'package:flutter/material.dart';

class ProfileVideo extends StatefulWidget {
  @override
  _ProfileVideoState createState() => _ProfileVideoState();
}

class _ProfileVideoState extends State<ProfileVideo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Text("No Videos Found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
    );
  }
}
