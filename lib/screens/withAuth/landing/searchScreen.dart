import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:hdlive_latest/models/Search_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/Search_service/searchService.dart';

import '../../../models/current_user_model.dart';
import '../../../models/followmodel.dart';
import '../../../services/profile_update_services.dart';
import '../../../services/userfollowservice.dart';
import '../../profile/user_profile_dailog.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchModel? searchData;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: MediaQuery.of(context).size,
            child: Container(
              height: 50,
              width: size.width,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )),
                  Container(
                      height: 60,
                      width: size.width * 0.7,
                      child: TextField(
                        onChanged: (val) async {
                          var i = await SearchService().search(val);
                          setState(() {
                            searchData = i;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          hintText: 'Search By UserId/UniqId/nickName',
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                          focusColor: Colors.transparent,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                        ),
                      ))
                ],
              ),
            ),
          ),
          body: searchData != null
              ? ListView.builder(
                  itemCount: searchData?.data?.length??0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Container(
                        child: GestureDetector(
                          onTap:() async {
                            Loading();
                            String status = "";
                            FollowModel? model = await UserFollowService().checkFollowStatus(searchData?.data?[index].userId??"");
                            FollowModel? model1 = await UserFollowService().checkFriendStatus(searchData?.data?[index].userId??"");
                            if (model!.data!.following! && model1!.data!.following!) {
                              status = "Friend";
                            } else if (!model.data!.following! && !model1!.data!.following!) {
                              status = "Follow";
                            } else if (model.data!.following! && !model1!.data!.following!) {
                              status = "Following";
                            } else if (!model.data!.following! && model1!.data!.following!) {
                              status = "Follow back";
                            }
                            CurrentUserModel?  userModel = await ProfileUpdateServices().getUserProfile(searchData?.data?[index].userId);
                             showModalBottomSheet<void>(
                              context: context,
                              isDismissible: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              builder: (BuildContext context) {
                                return UserProfileDailog(userModel:userModel,status: status,);
                              },
                            );
                          },
                          child: Text(
                            searchData?.data?[index].name??"",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                )),
    );
  }
}
