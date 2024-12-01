import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/viewer_model.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/services/firestore_services.dart';

class VideoLiveGuestList extends StatefulWidget {
  final String? channelName;
  final bool? broadcaster;
  VideoLiveGuestList({this.channelName, this.broadcaster});

  @override
  _VideoLiveGuestListState createState() => _VideoLiveGuestListState();
}

class _VideoLiveGuestListState extends State<VideoLiveGuestList> {
  List<Widget> guestListWidget = [];
  getList() {
    return FirestoreServices()
        .getVideoGuestViewer(widget.channelName??"")
        !.forEach((element) {
      List<ViewerModel> viewers = element;
      if (guestListWidget.isNotEmpty) {
        guestListWidget.clear();
      }
      print('Viewers == ${viewers.length}');
      for (var i = 0; i < viewers.length; i++) {
        ViewerModel viewer = viewers[i];

        guestListWidget.add(ListTile(
            trailing: widget.broadcaster!
                ? Container(
                    width: 160,
                    height: 70,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                iscamera = !iscamera;
                              });
                              if (iscamera) {
                                FirebaseFirestore.instance
                                    .collection("live_streams")
                                    .doc(widget.channelName)
                                    .collection("viewers")
                                    .where('uid')
                                    .get()
                                    .then((value) {
                                  value.docs.forEach((element) {
                                    var i = element.data();
                                    print(' values === ${i['iscamera']}');
                                    print(' values === ${i['uid']}');
                                    if (i['uid']
                                        .toString()
                                        .contains(viewer.uid!)) {
                                      print(' values === ${i['name']}');
                                      print(' values === ${viewer.uid}');
                                      FirebaseFirestore.instance
                                          .collection("live_streams")
                                          .doc(widget.channelName)
                                          .collection("viewers")
                                          .doc(viewer.uid.toString())
                                          .update({
                                        "iscamera": true,
                                      });
                                    }
                                  });
                                });
                              } else {
                                {
                                  print("2222522");
                                  FirebaseFirestore.instance
                                      .collection("live_streams")
                                      .doc(widget.channelName)
                                      .collection("viewers")
                                      .where('uid')
                                      .get()
                                      .then((value) {
                                    value.docs.forEach((element) {
                                      var i = element.data();
                                      if (i['uid']
                                          .toString()
                                          .contains(viewer.uid!)) {
                                        FirebaseFirestore.instance
                                            .collection("live_streams")
                                            .doc(widget.channelName)
                                            .collection("viewers")
                                            .doc(viewer.uid.toString())
                                            .update({
                                          "iscamera": false,
                                        });
                                      }
                                    });
                                  });
                                }
                              }
                            },
                            icon: viewer.isCamera!
                                ? Image.asset(
                                    'images/cameraa.png',
                                    height: 30,
                                    width: 30,
                                  )
                                : Image.asset(
                                    'images/cameraoff.png',
                                    height: 30,
                                    width: 30,
                                  )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isMute = !isMute;
                              });
                              print(' MUTE STATUS  === ${isMute}');
                              if (isMute) {
                                FirebaseFirestore.instance
                                    .collection("live_streams")
                                    .doc(widget.channelName)
                                    .collection("viewers")
                                    .where('uid')
                                    .get()
                                    .then((value) {
                                  value.docs.forEach((element) {
                                    var i = element.data();
                                    print(' values === ${i['isMute']}');
                                    print(' values === ${i['uid']}');
                                    if (i['uid']
                                        .toString()
                                        .contains(viewer.uid!)) {
                                      print(' values === ${i['name']}');
                                      print(' values === ${viewer.uid}');
                                      FirebaseFirestore.instance
                                          .collection("live_streams")
                                          .doc(widget.channelName)
                                          .collection("viewers")
                                          .doc(viewer.uid.toString())
                                          .update({
                                        "isMute": true,
                                      });
                                    }
                                  });
                                });
                              } else {
                                FirebaseFirestore.instance
                                    .collection("live_streams")
                                    .doc(widget.channelName)
                                    .collection("viewers")
                                    .where('uid')
                                    .get()
                                    .then((value) {
                                  value.docs.forEach((element) {
                                    var i = element.data();
                                    print(' values === ${i['isMute']}');
                                    print(' values === ${i['uid']}');
                                    if (i['uid']
                                        .toString()
                                        .contains(viewer.uid!)) {
                                      print(' values === ${i['name']}');
                                      print(' values === ${viewer.uid}');
                                      FirebaseFirestore.instance
                                          .collection("live_streams")
                                          .doc(widget.channelName)
                                          .collection("viewers")
                                          .doc(viewer.uid.toString())
                                          .update({
                                        "isMute": false,
                                      });
                                    }
                                  });
                                });
                              }
                            },
                            icon: Icon(
                              viewer.isMute! ? Icons.mic_off_rounded : Icons.mic,
                              color: Colors.red.shade900,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("live_streams")
                                  .doc(widget.channelName)
                                  .collection("viewers")
                                  .where('uid')
                                  .get()
                                  .then((value) {
                                value.docs.forEach((element) {
                                  var i = element.data();
                                  print(' values === ${i['status']}');
                                  if (i['status'].toString().contains('3')) {
                                    print(' values === ${i['status']}');
                                    print(' values === ${i['name']}');
                                    print(' values === ${i['uid']}');
                                    print(' values === ${viewer.uid}');
                                    FirebaseFirestore.instance
                                        .collection("live_streams")
                                        .doc(widget.channelName)
                                        .collection("viewers")
                                        .doc(viewer.uid.toString())
                                        .update({
                                      "status": 0,
                                    });
                                  }
                                });
                              });
                            },
                            icon: Image.asset(
                              'images/video.png',
                              height: 40,
                              width: 40,
                            )),
                      ],
                    ),
                  )
                : Container(
                    width: 5.w,
                    height: 5.h,
                  ),
            leading: viewer.photoUrl != null
                ? CircleAvatar(
                    radius: 20,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: HexagonProfilePicNetworkImage(
                          url: viewer.photoUrl??"",
                        )),
                  )
                : InitIconContainer(
                    radius: 40.r,
                    text: viewer.name??"",
                  ),
            title: Text(
              viewer.name??"",
              style: TextStyle(fontSize: 14),
            )));
      }
      setState(() {});
    });
  }

  var isMute = false;
  var iscamera = false;
  @override
  Widget build(BuildContext context) {
    getList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: guestListWidget);

    // return Container(
    //     child: StreamBuilder(
    //   stream: FirestoreServices().getVideoGuestViewer(widget.channelName),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       return Container();
    //     }
    //     List<ViewerModel> viewers = snapshot.data;
    //
    //         // return Column(
    //     //   crossAxisAlignment: CrossAxisAlignment.start,
    //     //   children: [
    //     //     Padding(
    //     //       padding: const EdgeInsets.only(left: 30),
    //     //       child: Text(
    //     //         "Guest List (${snapshot.data.length})",
    //     //         style: TextStyle(color: Colors.grey[600]),
    //     //       ),
    //     //     ),
    //     //     Container(
    //     //         child: ListView.separated(
    //     //       shrinkWrap: true,
    //     //       primary: false,
    //     //       itemCount: viewers.length,
    //     //       itemBuilder: (context, i) {
    //     //         ViewerModel viewer = viewers[i];
    //     //         print(viewer);
    //     //         return ListTile(
    //     //             leading: viewer.photoUrl != null
    //     //                 ? CircleAvatar(
    //     //                     radius: 20,
    //     //                     child: ClipRRect(
    //     //                         borderRadius: BorderRadius.circular(40),
    //     //                         child: HexagonProfilePicNetworkImage(
    //     //                           url: viewer.photoUrl,
    //     //                         )),
    //     //                   )
    //     //                 : InitIconContainer(
    //     //                     radius: 40,
    //     //                     text: viewer.name,
    //     //                   ),
    //     //             title: Text(
    //     //               viewer.name,
    //     //               style: TextStyle(fontSize: 14),
    //     //             ));
    //     //       },
    //     //       separatorBuilder: (context, i) {
    //     //         return Divider(
    //     //           thickness: 1,
    //     //         );
    //     //       },
    //     //     ))
    //     //   ],
    //     // );
    //   },
    // ));
  }
}
