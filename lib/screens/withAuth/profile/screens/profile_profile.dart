import 'package:flutter/material.dart';
import 'package:hdlive_latest/models/current_user_model.dart';

class ProfileProfile extends StatefulWidget {
  final CurrentUserModel? profileInfoModel;
  ProfileProfile({this.profileInfoModel});
  @override
  _ProfileProfileState createState() => _ProfileProfileState();
}

class _ProfileProfileState extends State<ProfileProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileProfileInfos(
              lable: "Introduction",
              value: widget.profileInfoModel?.bio ?? "No Introduction Found",
            ),
            // SizedBox(height: 15,),
            // ProfileProfileInfos(lable: "Constellation",value:  "No Constellation Found",),
            SizedBox(
              height: 15,
            ),
            ProfileProfileInfos(
              lable: "Hometown",
              value: widget.profileInfoModel?.countryName ?? "No Hometown Found",
            )
          ],
        ));
  }
}

class ProfileProfileInfos extends StatelessWidget {
  final String? lable;
  final String ?value;
  ProfileProfileInfos({this.lable, this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          lable??"",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value??"",
          style: TextStyle(fontSize: 12, color: Colors.black),
        )
      ],
    );
  }
}
