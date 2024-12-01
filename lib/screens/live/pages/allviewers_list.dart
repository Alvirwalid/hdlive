import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/current_user_model.dart';
import '../../../models/live_model.dart';
import '../../../models/viewer_model.dart';
import '../../../services/firestore_services.dart';
import '../../../services/profile_update_services.dart';
import '../../../services/token_manager_services.dart';
import '../../shared/initIcon_container.dart';
import '../../shared/loading.dart';
import '../../shared/network_image.dart';
import '../../withAuth/profile/viewer_profile_dailog.dart';
import 'gift_model.dart';

class AllViewerList extends StatefulWidget {
  final String? channelName;
  final String? userid;
  final LiveModel? broadcastUser;
  bool? broadcaster;
  bool? isVideo;

  AllViewerList({this.broadcastUser, this.channelName, this.userid,this.broadcaster,this.isVideo});

  @override
  _AllViewerListState createState() => _AllViewerListState();
}

class _AllViewerListState extends State<AllViewerList> {
  CurrentUserModel? user;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: StreamBuilder(
            stream: FirestoreServices().getAllViewersList(widget.channelName!, widget.userid),
            builder: (context, snapshot) {
              // Check if snapshot data is available
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: Text('No Viewers Found'),
                  ),
                );
              }

              // Safely cast the snapshot data to List<ViewerModel>
              List<ViewerModel> viewers = List<ViewerModel>.from(snapshot.data as List<dynamic>);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30.h.w, top: 10.h.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Viewer List (${viewers.length})",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                      child: ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: viewers.length,
                        itemBuilder: (context, i) {
                          ViewerModel viewer = viewers[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return Container(
                                    child: Container(
                                      child: FutureBuilder<CurrentUserModel?>(
                                        future: ProfileUpdateServices().getUserProfile(viewer.uid),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Container(
                                              height: MediaQuery.of(context).size.height / 2,
                                              child: Loading(),
                                            );
                                          }

                                          if (snapshot.hasData && snapshot.data != null) {
                                            return ViewerProfileDailog(
                                              userModel: snapshot.data!, // Using the '!' to assert non-null
                                              channelName: widget.channelName!,
                                              viewer: viewers[i],
                                              broadcastUser: widget.broadcastUser!,
                                              broadcaster: widget.broadcaster!,
                                              isVideo: widget.isVideo!,
                                            );
                                          } else {
                                            return Center(child: Text('No data available.'));
                                          }
                                        },
                                      ),

                                      // FutureBuilder<CurrentUserModel>(
                                      //   future: ProfileUpdateServices().getUserProfile(viewer.uid),
                                      //   builder: (context, snapshot) {
                                      //     if (snapshot.data != null) {
                                      //       return ViewerProfileDailog(
                                      //         userModel: snapshot.data,
                                      //         channelName: widget.channelName,
                                      //         viewer: viewers[i],
                                      //         broadcastUser: widget.broadcastUser,
                                      //         broadcaster: widget.broadcaster,
                                      //         isVideo: widget.isVideo,
                                      //       );
                                      //     } else {
                                      //       return Container(
                                      //         height: MediaQuery.of(context).size.height / 2,
                                      //         child: Loading(),
                                      //       );
                                      //     }
                                      //   },
                                      // ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: ListTile(
                              dense: true,
                              leading: viewer.photoUrl != null
                                  ? CircleAvatar(
                                radius: 20.r,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: HexagonProfilePicNetworkImage(
                                      url: viewer?.photoUrl??"",
                                    )),
                              )
                                  : InitIconContainer(
                                radius: 40,
                                text: viewer?.name??"",
                              ),
                              title: Text(
                                viewer?.name??"",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, i) {
                          return Divider(
                            thickness: 1,
                          );
                        },
                      ))
                ],
              );
            },
          )

        // StreamBuilder(
          //   stream: FirestoreServices().getAllViewersList(widget.channelName!, widget.userid),
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) {
          //       return Container(
          //         child: Center(
          //           child: Text('No Viewers Found'),
          //         ),
          //       );
          //     }
          //     List<ViewerModel> viewers = snapshot.data;
          //     return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.only(left: 30.h.w, top: 10.h.w),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Viewer List (${snapshot.data.length})",
          //                 style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          //               Padding(
          //                 padding: EdgeInsets.only(right: 10),
          //               )
          //             ],
          //           ),
          //         ),
          //         Divider(),
          //         Container(
          //             child: ListView.separated(
          //               shrinkWrap: true,
          //               primary: false,
          //               itemCount: viewers.length,
          //               itemBuilder: (context, i) {
          //                 ViewerModel viewer = viewers[i];
          //                 return GestureDetector(
          //                   onTap: () {
          //                     Navigator.pop(context);
          //                     showModalBottomSheet(
          //                       context: context,
          //                       isScrollControlled: true,
          //                       isDismissible: true,
          //                       backgroundColor: Colors.transparent,
          //                       builder: (context) {
          //                         return Container(
          //                           child: Container(
          //                             child: FutureBuilder<CurrentUserModel>(
          //                               future: ProfileUpdateServices().getUserProfile(viewer.uid),
          //                               builder: (context, snapshot) {
          //                                if(snapshot.data != null) {
          //                                  return ViewerProfileDailog(
          //                                      userModel: snapshot.data,
          //                                    channelName:widget.channelName,
          //                                      viewer:viewers[i],
          //                                    broadcastUser: widget.broadcastUser,
          //                                      broadcaster:widget.broadcaster,
          //                                    isVideo:widget.isVideo,);
          //                                }else{
          //                                  return Container(
          //                                      height: MediaQuery.of(context).size.height / 2,
          //                                    child: Loading(),) ;
          //                                }
          //
          //                                 /*Row(
          //                                   mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     Container(
          //                                       decoration: BoxDecoration(
          //                                           borderRadius:
          //                                           BorderRadius.circular(20),
          //                                           image: DecorationImage(
          //                                               image: NetworkImage(
          //                                                   viewer.photoUrl))),
          //                                       height: 40,
          //                                       width: 40,
          //                                     ),
          //                                     GestureDetector(
          //                                       onTap: () async {
          //                                         Navigator.pop(context);
          //                                         Navigator.pop(context);
          //                                         showModalBottomSheet(
          //                                             context: context,
          //                                             isScrollControlled: true,
          //                                             isDismissible: true,
          //                                             backgroundColor: Colors.transparent,
          //                                             builder: (context) {
          //                                               return Gift_Model(
          //                                                 channelName: widget.channelName,
          //                                                 user: user,
          //                                                 viewer: viewer,
          //                                                 brodcast: widget.brodcast,
          //                                                 //viewers:viewer.uid,
          //                                               );
          //                                             });
          //                                       },
          //                                       child: Container(
          //                                         child: Image.asset('images/Gift.png'),
          //                                         height: 40,
          //                                         width: 40,
          //                                       ),
          //                                     ),
          //                                     GestureDetector(
          //                                       onTap: () {
          //                                         showDialog(
          //                                             context: context,
          //                                             builder: (context) {
          //                                               return AlertDialog(
          //                                                 actions: <Widget>[
          //                                                   TextButton(
          //                                                     onPressed: () {
          //                                                       showDialog(
          //                                                           context: context,
          //                                                           builder: (context) {
          //                                                             return AlertDialog(
          //                                                               // content: Text('go to hd-live setting and give all permittion'),
          //                                                               actions: <Widget>[
          //                                                                 TextButton(
          //                                                                   onPressed:
          //                                                                       () async {
          //                                                                     // SystemNavigator.   pop(animated: true);
          //                                                                   },
          //                                                                   child: Text(
          //                                                                       'Mute'),
          //                                                                 ),
          //                                                                 TextButton(
          //                                                                   onPressed:
          //                                                                       () {},
          //                                                                   child: Text(
          //                                                                     'Kick Out',
          //                                                                   ),
          //                                                                 ),
          //                                                                 TextButton(
          //                                                                   onPressed:
          //                                                                       () {},
          //                                                                   child: Text(
          //                                                                     'Kick Out',
          //                                                                   ),
          //                                                                 ),
          //                                                                 TextButton(
          //                                                                   onPressed:
          //                                                                       () {},
          //                                                                   child: Text(
          //                                                                     'Kick Out',
          //                                                                   ),
          //                                                                 ),
          //                                                                 TextButton(
          //                                                                   onPressed:
          //                                                                       () {},
          //                                                                   child: Text(
          //                                                                     'Kick Out',
          //                                                                   ),
          //                                                                 ),
          //                                                               ],
          //                                                             );
          //                                                           });
          //                                                       // SystemNavigator.pop(animated: true);
          //                                                     },
          //                                                     child: Text(""),
          //                                                   ),
          //                                                   TextButton(
          //                                                     onPressed: () {
          //                                                       // _initialPermissionsAndInitialization();
          //                                                       Navigator.of(context)
          //                                                           .pop(false);
          //                                                     },
          //                                                     child: Text('Yes'),
          //                                                   ),
          //                                                 ],
          //                                               );
          //                                             });
          //                                       },
          //                                       child: Padding(
          //                                         padding: EdgeInsets.only(
          //                                             right: 20, bottom: 50),
          //                                         child: Row(
          //                                           children: [
          //                                             // Image.asset(
          //                                             //   "images/manage.png",
          //                                             //   color: Colors.red,
          //                                             //   width: 15,
          //                                             //   height: 15,
          //                                             // ),
          //                                             Text(
          //                                               "Manage",
          //                                               style: TextStyle(
          //                                                   fontSize: 8,
          //                                                   fontWeight: FontWeight.bold,
          //                                                   color: Colors.black),
          //                                             ),
          //                                           ],
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 );*/
          //                               },
          //                             ),
          //                           ),
          //                         );
          //                       },
          //                     );
          //                   },
          //                   child: ListTile(
          //                       dense: true,
          //                       leading: viewer.photoUrl != null
          //                           ? CircleAvatar(
          //                         radius: 20.r,
          //                         child: ClipRRect(
          //                             borderRadius: BorderRadius.circular(40),
          //                             child: HexagonProfilePicNetworkImage(
          //                               url: viewer.photoUrl,
          //                             )),
          //                       )
          //                           : InitIconContainer(
          //                         radius: 40,
          //                         text: viewer.name,
          //                       ),
          //                       title: Text(
          //                         viewer.name,
          //                         style: TextStyle(fontSize: 14.sp),
          //                       )),
          //                 );
          //               },
          //               separatorBuilder: (context, i) {
          //                 return Divider(
          //                   thickness: 1,
          //                 );
          //               },
          //             ))
          //       ],
          //     );
          //   },
          // )


      ),
    );
  }

  Future<void> initialize() async {
    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId, true);
  }
}
