import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/live_viewer_bloc/live_viewer_bloc.dart';
import '../../models/current_user_model.dart';
import '../../services/live_service/live_service.dart';
import '../../services/profile_update_services.dart';
import '../../services/token_manager_services.dart';
import '../shared/initIcon_container.dart';
import '../shared/loading.dart';
import '../shared/network_image.dart';
closeLiveModal(BuildContext context, String channelName, int seconds,String callType) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, state) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: .5,
              minChildSize: .5,
              maxChildSize: .5,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30.r))),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: QuitBroadcastingContainer(
                      channelName: channelName,
                      seconds: seconds,
                      callType:callType,
                    ),
                  ),
                );
              },
            );
          },
        );
      });
}

class QuitBroadcastingContainer extends StatefulWidget {
  final String? channelName;
  final int? seconds;
  final String? callType;

  QuitBroadcastingContainer({this.channelName, this.seconds,this.callType});

  @override
  _QuitBroadcastingContainerState createState() => _QuitBroadcastingContainerState();
}

class _QuitBroadcastingContainerState extends State<QuitBroadcastingContainer> {
  LiveViewerBloc _bloc = LiveViewerBloc();
  int viewerCount = 0;
  bool loading = true;
  CurrentUserModel? user;

  @override
  void initState() {
    _bloc.add(FetchLiveViewer(channelName: widget.channelName));
    getUser();

    super.initState();
  }

  getUser() async {
    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId, true);
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                SizedBox(
                  height: 15.sp,
                ),
                Container(
                  child: user!.image != null
                      ? CircleAvatar(
                          radius: 40.r,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.r),
                              child: HexagonProfilePicNetworkImage(
                                url: user?.image??"",
                              )),
                        )
                      : InitIconContainer(
                          radius: 80.r,
                          text: user?.name??"",
                        ),
                ),
                Expanded(
                    child: Container(
                  child: BlocBuilder(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is LiveViewerFetching) {
                        // return Center(child: CircularProgressIndicator());
                        return Center(child: Loading());
                      } else if (state is LiveViewerFetched) {
                        viewerCount = state.liveViewerCount!;
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("images/Fans_Group.png"),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text("Viewer ${state.liveViewerCount}")
                            ],
                          ),
                        );
                      } else {
                        return Text("Some error ocurred");
                      }
                    },
                  ),
                )),
                Container(
                  child: Text(
                    "Are you sure to quit broadcasting?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  //color: Colors.red,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                      side: BorderSide(color: Colors.red))),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFFB02105))),
                          child: Text(
                            "CONTINUE",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17.sp),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: ElevatedButton(
                          onPressed: () async {
                            print("HERE");
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            //

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BroadcastingStatusAfterQuit(
                                      viewerCount: viewerCount,
                                      photoUrl: user?.image??"",
                                      seconds: widget.seconds!,
                                      name: user?.name??"",
                                    )));
                            await LiveService().isTimeLiveCall(widget.callType??"","end");
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.red))),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          child: Text(
                            "QUIT BROADCAST",
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
  }
}

class BroadcastingStatusAfterQuit extends StatefulWidget {
  final int? viewerCount;
  final String? photoUrl;
  final int? seconds;
  final String? name;

  BroadcastingStatusAfterQuit(
      {this.viewerCount, this.seconds, this.photoUrl, this.name});

  @override
  _BroadcastingStatusAfterQuitState createState() =>
      _BroadcastingStatusAfterQuitState();
}

class _BroadcastingStatusAfterQuitState
    extends State<BroadcastingStatusAfterQuit> {
  String time = "";

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  void initState() {
    var d = Duration(seconds: widget.seconds!);
    time = format(d);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD8300E),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: Container(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Color(0x88000000),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Container(
                  child: widget.photoUrl != null
                      ? CircleAvatar(
                          radius: 40.r,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.r),
                              child: HexagonProfilePicNetworkImage(
                                  url: widget.photoUrl??"")),
                        )
                      : InitIconContainer(
                          radius: 80.r,
                          text: widget.name??"",
                        ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                StatInfo(
                  viewer: widget.viewerCount!,
                  fans: 0,
                  beans: 0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Text(
                  "Live time",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
                Text(time,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatInfo extends StatelessWidget {
  final int? viewer;
  final int? fans;
  final int? beans;

  StatInfo({this.viewer, this.fans, this.beans});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatBlock(
            number: viewer.toString(),
            label: "Viewers",
          ),
          StatBlock(
            number: fans.toString(),
            label: "Follower",
          ),
          StatBlock(
            number: beans.toString(),
            label: "New Beans",
          ),
        ],
      ),
    );
  }
}

class StatBlock extends StatelessWidget {
  final String? number;
  final String? label;

  StatBlock({this.number, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            number!,
            style: TextStyle(
                color: Colors.white,
                fontSize: 21.sp,
                fontWeight: FontWeight.bold),
          ),
          Text(
            label!,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          )
        ],
      ),
    );
  }
}
