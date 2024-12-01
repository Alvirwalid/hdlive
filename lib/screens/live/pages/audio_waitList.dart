import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/viewer_model.dart';
import '../../../services/firestore_services.dart';
import '../../shared/initIcon_container.dart';
import '../../shared/network_image.dart';
import 'audio_live.dart';

class AudioWaitList extends StatefulWidget {
  final String? channelName;
  final bool? broadcaster;
  List<ViewerModel>? listViewer;

  AudioWaitList({this.channelName, this.broadcaster,this.listViewer});

  @override
  _AudioWaitListState createState() => _AudioWaitListState();
}

class _AudioWaitListState extends State<AudioWaitList>
    with WidgetsBindingObserver {
  bool _switchValue = false;
  ViewerModel? viewer;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
          stream: FirestoreServices().getVideoWaitingViewer(widget.channelName??""),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            List<ViewerModel> viewers = snapshot.data as List<ViewerModel>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.h.w, right: 30.h.w),
                  child: Row(
                    children: [
                      Text(
                        "Waiting List (${(snapshot.data as List?)?.length ?? 0})",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Spacer(),
                      // CupertinoSwitch(
                      //   activeColor: Colors.red,
                      //   value: _switchValue,
                      //   onChanged: (value) {
                      //     print("valueeee $value");
                      //     setState(() {
                      //       _switchValue = value;
                      //     });
                      //     if (_switchValue) {
                      //       FirestoreServices.addUserToVideoLive(
                      //           viewer, widget.channelName);
                      //     } else {}
                      //   },
                      // ),
                    ],
                  ),
                ),
                !_switchValue
                    ? Container(
                  child: ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: viewers.length,
                    itemBuilder: (context, i) {
                      viewer = viewers[i];
                      print(viewer);
                      return ListTile(
                        leading: viewer?.photoUrl != null
                            ? CircleAvatar(
                          radius: 20.r,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.r),
                              child: HexagonProfilePicNetworkImage(
                                url: viewer?.photoUrl??"",
                              )),
                        )
                            : InitIconContainer(
                          radius: 40.r,
                          text: viewer?.name??"",
                        ),
                        title: Text(
                          viewer?.name??"",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        trailing: widget.broadcaster!
                            ? Container(
                          width: 90.w,
                          height: 25.h,
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, state) {
                                          return DraggableScrollableSheet(
                                              expand: false,
                                              initialChildSize: .18,
                                              minChildSize: .18,
                                              maxChildSize: .18,
                                              builder: (context,
                                                  scrollController) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius.circular(30.r),
                                                          topRight: Radius.circular(30.r))),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Select Number In Room",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontSize:
                                                            14.sp),
                                                      ),
                                                      SingleChildScrollView(
                                                        padding: EdgeInsets.zero,
                                                        scrollDirection: Axis.horizontal,
                                                        child: Row(
                                                          children: List.generate(8,
                                                                  (index) {return GestureDetector(
                                                                  onTap: () {
                                                                    selectedIndex = index;
                                                                    state(() {});
                                                                  },
                                                                  child:
                                                                  Padding(padding:
                                                                    EdgeInsets.all(5.0),
                                                                    child: Container(
                                                                      height: 35,
                                                                      width: 35,
                                                                      decoration: BoxDecoration(
                                                                          color: selectedIndex == index ? Colors.red.shade900 : Colors.white,
                                                                          shape: BoxShape.rectangle,
                                                                          border: Border.all(color: Colors.black54)),
                                                                      child: Center(child:
                                                                        Text((index + 1).toString(),
                                                                          style: TextStyle(fontWeight: FontWeight.bold, color: selectedIndex == index ? Colors.white : Colors.black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStatePropertyAll(Colors.red.shade900)
                                                        ),
                                                        onPressed: () {
                                                          bool seat = false;
                                                          if (selectedIndex != null) {
                                                            for(var j = 0 ;j<widget.listViewer!.length;j++ ){
                                                              if(!seat && widget.listViewer![j].name != "0" && j == selectedIndex){
                                                                seat = true;
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Select Other Seat Number')));
                                                                return;
                                                              }
                                                            }
                                                            FirestoreServices.addSeatUserToVideoLive(viewer!, widget.channelName??"", selectedIndex!);
                                                          } else {
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Select Seat Number')));
                                                          }
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Accept', style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 18.sp),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });
                                        });
                                  });

                              // CallServices.joinVideo(2, widget.channelName);
                            },

                            style: ButtonStyle(
                              backgroundColor:MaterialStatePropertyAll( Colors.red) ,
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(20.r))
                              )
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Icon(
                                  viewer?.status == 1 ? Icons.mic_none_outlined : Icons.videocam,
                                  color: Colors.white,
                                  size: 15.sp,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Accept",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        )
                            : Container(
                          width: 1.w,
                        ),
                      );
                    },
                    separatorBuilder: (context, i) {
                      return Divider(
                        thickness: 1,
                      );
                    },
                  ),
                )
                    : Container()
              ],
            );
          },
        ));
  }
}