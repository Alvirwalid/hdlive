import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/models/banner_model.dart';
import 'package:hdlive_latest/models/blockcheckmodel.dart';
import 'package:hdlive_latest/models/live_model.dart';
import 'package:hdlive_latest/screens/live/pages/audio_live.dart';
import 'package:hdlive_latest/screens/live/pages/call.dart';
import 'package:hdlive_latest/screens/live/pages/multi_guest_live.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/firestore_services.dart';
import 'package:hdlive_latest/services/live_service/live_service.dart';
import 'package:hdlive_latest/services/userfollowservice.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CurrentLive extends StatefulWidget {
  final String? type;

  CurrentLive({this.type});

  @override
  _CurrentLiveState createState() => _CurrentLiveState();
}

class _CurrentLiveState extends State<CurrentLive> {
  List<Datum> banner = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirestoreServices().getLiveStreams(widget.type ?? "video"),
        builder: (context,AsyncSnapshot<dynamic>snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data.length == 0) {
            return widget.type!.contains("audio")
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Live Streaming available",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Live Streaming available",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      )
                    ],
                  );
          }

          return FutureBuilder<BannerModel>(
              future: LiveService().getBanner(),
              builder: (context, snap) {
                if (snap.hasData) {
                  if (banner.isNotEmpty) {
                    banner.clear();
                  }
                  if (banner.isEmpty) {
                    for (int i = 0; i < snap.data!.data!.length; i++) {
                      if (widget.type.toString().contains('both')) {
                        if (snap.data!.data![i].type.toString().contains('app_top')) {
                          banner.add(snap.data!.data![i]);
                        }
                      } else {
                        if (snap.data!.data![i].type.toString()
                            .contains('audio_live')) {
                          banner.add(snap.data!.data![i]);
                        }
                      }
                    }
                  }
                  return CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverToBoxAdapter(
                        child: widget.type.toString().contains('audio')
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                child: CarouselSlider.builder(
                                  itemCount: banner.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return GestureDetector(
                                      onTap: () {
                                        WebView.platform = AndroidWebView();
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Scaffold(
                                            body: WebView(
                                              initialUrl: banner[index].link,
                                              debuggingEnabled: true,
                                            ),
                                          );
                                        }));
                                      },
                                      child: Container(
                                        width: 400.w,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(banner[index].image??""),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    autoPlay: true,
                                    autoPlayAnimationDuration:
                                        Duration(seconds: 2),
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.9,
                                    aspectRatio: 1.0,
                                    initialPage: 0,
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                      SliverToBoxAdapter(
                        child: StaggeredGridView.countBuilder(
                          crossAxisSpacing: 3.0,
                          shrinkWrap: true,
                          mainAxisSpacing: 3.0,
                          // controller: scrollController,
                          itemCount: snapshot.data.length,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            LiveModel live = snapshot.data[index];
                            if (index != 4) {
                              return GestureDetector(
                                onTap: () async {
                                  if (live.liveType == "video") {
                                    BlockCheckModel? model =  await UserFollowService().callCheckBlockUser(live.userId??"");
                                    if(model!.data!.hasBlocked!){
                                      Fluttertoast.showToast(msg: 'This user has been blocked you.');
                                      return;
                                    }
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CallPage(
                                          channelName: live.liveId,
                                          broadcastUser: live,
                                          broadcaster:false,
                                          msgText: '',
                                          role: 2,
                                        ),
                                      ),
                                    );
                                  } else if (live.liveType == "multi_video") {
                                    BlockCheckModel? model =  await UserFollowService().callCheckBlockUser(live.userId??"");
                                    if(model!.data!.hasBlocked!){
                                      Fluttertoast.showToast(msg: 'This user has been blocked you.');
                                      return;
                                    }
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MultiGuestLive(
                                            channelName: live.liveId,
                                            broadcastUser: live,
                                            msgText: '',
                                            seats: live.seats,
                                          ),
                                        ));
                                  } else {
                                    BlockCheckModel? model =  await UserFollowService().callCheckBlockUser(live.userId??"");
                                    if(model!.data!.hasBlocked!){
                                      Fluttertoast.showToast(msg: 'This user has been blocked you.');
                                      return;
                                    }
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AudioLive(
                                            channelName: live.liveId,
                                            broadcastUser: live,
                                            broadcaster:false,
                                            msgText: '',
                                            key: ValueKey(1),
                                          ),
                                        ));
                                  }
                                },
                                child: ImageBoxLive(
                                  title: live.liveName??"",
                                  image: live.photoUrl??"",
                                  type: live.liveType??"",
                                ),
                              );
                            } else if (widget.type
                                .toString()
                                .contains('audio')) {
                              return Container();
                            } else {
                              return CarouselSlider.builder(
                                itemCount: banner.length,
                                itemBuilder: (context, index, realIndex) {
                                  return GestureDetector(
                                    onTap: () {
                                      WebView.platform = AndroidWebView();
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Scaffold(
                                          body: WebView(
                                            initialUrl: banner[index].link,
                                            debuggingEnabled: true,
                                          ),
                                        );
                                      }));
                                    },
                                    child: Container(
                                      width: 400.w,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            banner[index].image??"",
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  autoPlay: true,
                                  autoPlayAnimationDuration:
                                      Duration(seconds: 2),
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.9,
                                  aspectRatio: 1.0,
                                  initialPage: 0,
                                ),
                              );
                              // return PageView.builder(
                              //     scrollDirection: Axis.horizontal,
                              //     itemCount: banner.length,
                              //     itemBuilder: (ctx, index) {
                              //       return Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 10.0),
                              //         child: GestureDetector(
                              //           onTap: () {
                              //             WebView.platform = AndroidWebView();
                              //             Navigator.push(context,
                              //                 MaterialPageRoute(
                              //                     builder: (context) {
                              //               return Scaffold(
                              //                 body: WebView(
                              //                   initialUrl: banner[index].link,
                              //                   debuggingEnabled: true,
                              //                 ),
                              //               );
                              //             }));
                              //           },
                              //           child: Container(
                              //             width: 260,
                              //             height: 60,
                              //             decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(5),
                              //                 image: DecorationImage(
                              //                     fit: BoxFit.cover,
                              //                     image: NetworkImage(
                              //                         banner[index].image))),
                              //           ),
                              //         ),
                              //       );
                              //     });
                            }
                          },
                          crossAxisCount: 2,
                          staggeredTileBuilder: (int index) {
                            if (index != 4)
                              return StaggeredTile.count(1, 1);
                            else
                              return StaggeredTile.count(
                                  2,
                                  widget.type.toString().contains('audio')
                                      ? 0.02
                                      : 0.8);
                            // return StaggeredTile.count(1, 1);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    // child: CircularProgressIndicator(),
                    child: Loading(size: 70.0),
                  );
                }
              });
        },
      ),

    );
  }
}

class ImageBoxLive extends StatelessWidget {
  final String? title;
  final String? image;
  final String? type;

  ImageBoxLive({this.type, this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
          height: MediaQuery.of(context).size.width / 2.2,
          width: MediaQuery.of(context).size.width / 2.2,
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: Color(0xFFEFAA1F),
            // ),

            image: DecorationImage(
                fit: BoxFit.cover,
                image: image != null
                    ? NetworkImage(image??"")
                    : AssetImage("images/user-large.png") as ImageProvider),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.redAccent,
          ),
          child: Container(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.red],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [.7, 1]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black54),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          child: Image.asset(type!.contains('video')
                                ? 'images/gif/video.gif'
                                : "images/gif/audio.gif",
                            color: type!.contains("video")
                                ? Colors.white
                                : Colors.white,
                          ),
                        ),
                        Text(
                          type!.contains("video") ? "Video" : "Audio",
                          style: TextStyle(
                              color: type!.contains("video")
                                  ? Color(0xffadff2f)
                                  : Color(0xff00ffff)),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title ?? "  ",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
