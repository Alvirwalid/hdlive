import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

class GoAudioLive extends StatefulWidget {
  final TextEditingController? controller;
  GoAudioLive({this.controller});
  @override
  _GoAudioLiveState createState() => _GoAudioLiveState();
}

class _GoAudioLiveState extends State<GoAudioLive> {
  CurrentUserModel? user;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    print("on Init");
    getUser();
  }

  getUser() async {
    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId, true);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                            image: AssetImage("images/audiogif.gif"),
                            fit: BoxFit.fill,
                          )),
                    )),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    // border: Border(bottom: BorderSide(color: Colors.black))
                  ),
                  height: MediaQuery.of(context).size.height * .1,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.25 + 20,
                        top: MediaQuery.of(context).size.height * .03),
                    child: TextFormField(
                      expands: true,
                      autofocus: false,
                      maxLines: null,
                      controller: widget.controller,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "HD Live",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: user?.image != null
                      ? CircleAvatar(
                          radius: 40.r,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: HexagonProfilePicNetworkImage(
                                url: user?.image,
                              )),
                        )
                      : InitIconContainer(
                          radius: 80.r,
                          text: user?.name,
                        ),
                )
              ],
            ),
          );
  }
}
