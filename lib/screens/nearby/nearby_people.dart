
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive/models/banner_model.dart';
import 'package:hdlive/models/blockcheckmodel.dart';
import 'package:hdlive/models/live_model.dart';
import 'package:hdlive/screens/live/pages/audio_live.dart';
import 'package:hdlive/screens/live/pages/call.dart';
import 'package:hdlive/screens/live/pages/multi_guest_live.dart';
import 'package:hdlive/screens/shared/loading.dart';
import 'package:hdlive/screens/withAuth/go_live/current_live.dart';
import 'package:hdlive/services/firestore_services.dart';
import 'package:hdlive/services/live_service/live_service.dart';
import 'package:hdlive/services/userfollowservice.dart';
class NearbyPeopleTab extends StatefulWidget {
  @override
  _NearbyPeopleTabState createState() => _NearbyPeopleTabState();
}

class _NearbyPeopleTabState extends State<NearbyPeopleTab> {


  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {

    super.dispose();
  }


  List<Datum> banner = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirestoreServices().getAllLiveStreams(),
        builder: (context,AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data!.length == 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No Live Streaming available",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                      banner.add(snap.data!.data![i]);
                    }
                  }
                  return CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverToBoxAdapter(
                        child: StaggeredGridView.countBuilder(
                          crossAxisSpacing: 3.0,
                          shrinkWrap: true,
                          mainAxisSpacing: 3.0,
                          // controller: scrollController,
                          itemCount: snapshot.data!.length,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            LiveModel live = snapshot.data![index];
                            if (index != 4) {
                              return GestureDetector(
                                onTap: () async {
                                  if (live.liveType == "video") {
                                    BlockCheckModel? model =  await UserFollowService().callCheckBlockUser(live.userId!);
                                    if(model!.data!.hasBlocked!){
                                      Fluttertoast.showToast(msg: 'This user has been blocked you.');
                                      return;
                                    }
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CallPage(
                                          channelName: live?.liveId??"",
                                          broadcastUser: live,
                                          msgText: '',
                                          role: 2,
                                        ),
                                      ),
                                    );
                                  } else if (live.liveType == "multi_video") {
                                    BlockCheckModel? model =  await UserFollowService().callCheckBlockUser(live.userId!);
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
                                    BlockCheckModel? model =  await UserFollowService().callCheckBlockUser(live.userId!);
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
                                            msgText: '', key: ValueKey(1),
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
                                      width: 400,
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
                            }
                          },
                          crossAxisCount: 2,
                          staggeredTileBuilder: (int index) {
                            if (index != 4)
                              return StaggeredTile.count(1, 1);
                            else
                              return StaggeredTile.count(
                                  2, 0.8);
                            // return StaggeredTile.count(1, 1);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Loading(size: 70.0,),
                    // child: CircularProgressIndicator(),
                  );
                }
              });
        },
      ),

    );
  }
}
