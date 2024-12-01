import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart' as badge;
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive/models/Gifts_model.dart';
import 'package:hdlive/models/chat_model.dart';
import 'package:hdlive/models/current_user_model.dart';
import 'package:hdlive/models/gift_category.dart';
import 'package:hdlive/models/level_model.dart';
import 'package:hdlive/models/live_model.dart';
import 'package:hdlive/models/viewer_model.dart';
import 'package:hdlive/screens/live/all_viewer_modal.dart';
import 'package:hdlive/screens/live/close_live_bottom_modal.dart';
import 'package:hdlive/screens/live/pages/gift_model.dart';
import 'package:hdlive/screens/live/pages/multi_guest_render_4.dart';
import 'package:hdlive/screens/live/pages/multi_guest_render_6.dart';
import 'package:hdlive/screens/live/utils/settings.dart';
import 'package:hdlive/screens/shared/bottom_scrollsheet_message.dart';
import 'package:hdlive/screens/shared/initIcon_container.dart';
import 'package:hdlive/screens/shared/loading.dart';
import 'package:hdlive/screens/shared/network_image.dart';
import 'package:hdlive/screens/withAuth/go_live/live_header.dart';
import 'package:hdlive/services/firestore_services.dart';
import 'package:hdlive/services/gift_service.dart';
import 'package:hdlive/services/level_service.dart';
import 'package:hdlive/services/live_service/live_service.dart';
import 'package:hdlive/services/profile_update_services.dart';
import 'package:hdlive/services/timer_services.dart';
import 'package:hdlive/services/token_manager_services.dart';

import '../../../models/followmodel.dart';
import '../../../services/userfollowservice.dart';
import '../../profile/user_profile_dailog.dart';
import '../../withAuth/profile/viewprofile_model.dart';
import 'audio_live.dart';
import 'multi_guest_render_9.dart';

class MultiGuestLive extends StatefulWidget {
  final String? channelName;
  final String? msgText;
  final bool? broadcaster;
  final LiveModel? broadcastUser;
  final int? seats;
  MultiGuestLive(
      {this.channelName,
      this.msgText,
      this.broadcaster = false,
      this.broadcastUser,
      this.seats});
  @override
  _MultiGuestLiveState createState() => _MultiGuestLiveState();
}

class _MultiGuestLiveState extends State<MultiGuestLive>
    with WidgetsBindingObserver {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine? _engine;

  TextEditingController _comment = TextEditingController();

  StreamSubscription? _stream;
  StreamSubscription? _viewerStream;
  int? guest;
  int requester = 0;
  TimerServices timerServices = TimerServices();
  CurrentUserModel? user;
  bool connecting = false;
  String liveLoading = "Loading";
  Map<int, dynamic> guestInfos = {};
  List<int> us = [
    10101,
    10102,
    10103,
    10104,
    10105,
    10106,
    10107,
    10108,
    10109
  ];
  bool loading = true;
  var ind;
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _users.clear();

    _engine!.leaveChannel();
    _engine!.destroy();
    _comment.dispose();
    if (_stream != null) {
      _stream!.cancel();
    }
    timerServices.close();
    disposeLive();
    if (_viewerStream != null) {
      _viewerStream!.cancel();
    }
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   print(state);
  //   print("here");
  //   if (state == AppLifecycleState.paused) {
  //     print("HERE=======================");
  //     disposeLive();
  //   } else if (state == AppLifecycleState.detached) {
  //     print("HERE=============Dettached ==========");
  //     disposeLive();
  //   } else if (state == AppLifecycleState.inactive) {
  //     print("HERE=============inactivbe ==========");
  //     disposeLive();
  //   } else if (state == AppLifecycleState.resumed) {
  //     print("HERE=============resume ==========");
  //     if (!widget.broadcaster) {
  //       FirestoreServices.newUserJoined(widget.channelName);
  //     }
  //   }
  // }

  disposeLive() async {
    if (widget.broadcaster!) {
      print("video dispose");
      await FirestoreServices.onWillPop(widget.channelName??"");
    } else {
      await FirestoreServices.onGuestLeave(widget.channelName??"");
    }
  }

  GiftCategory? giftCategory;
  Giftsmodel? giftData;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    GiftService();
    GiftCategorys();
    // initialize agora sdk
    initialize();
    initializeViewerStream();

    if (!widget.broadcaster!) {
      FirestoreServices.newUserJoined(widget.channelName??"");
      FirestoreServices.insertNewComment(widget.channelName??"", "Joined");
      FirestoreServices.insertDefaultComment(widget.channelName??"");
    }
  }

  Future<void> initialize() async {
    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId, true);
    setState(() {
      loading = false;
    });
    // _initialPermissionsAndInitialization();

    if (widget.broadcaster!) {
      initializeForBroadcaster(us[0]);
      timerServices.startTimer();
    } else {
      initializeForOthers();
    }
  }

  // Future<void> _handlePermissions(Permission permission) async {
  //   final status = await permission.request();
  //   print(status);
  // }

  // _initialPermissionsAndInitialization() async {
  //   await _handlePermissions(Permission.camera);
  //   await _handlePermissions(Permission.microphone);
  //   bool isKeptOn = await Screen.isKeptOn;
  //   if (!isKeptOn) {
  //     Screen.keepOn(true);
  //   }
  //   // await _localRenderer.initialize();
  //   // await _remoteRenderer.initialize();
  // }

  Future<void> initializeForBroadcaster(int bid) async {
    connecting = true;
    String APP_ID = await TokenManagerServices().getAgoraAppId();
    _engine = await RtcEngine.create(APP_ID);
    await _engine!.enableVideo();
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine!.setClientRole(ClientRole.Broadcaster);

    _addAgoraEventHandlers();
    await _engine!.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration(dimensions:VideoDimensions(width: 1920, height: 1080));

    await _engine!.setVideoEncoderConfiguration(configuration);
    await _engine!.joinChannel(token:  Token,channelId:  widget.channelName??"", options: ChannelMediaOptions(),uid:  bid);

  }

  Future<void> initializeForOthers() async {
    String APP_ID = await TokenManagerServices().getAgoraAppId();
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: APP_ID));
    await _engine!.enableVideo();
    await _engine!.setChannelProfile( ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine!.setClientRole( role:ClientRoleType.clientRoleAudience,options: ClientRoleOptions());
    _addAgoraEventHandlers();
    await _engine!.joinChannel( token:  Token,channelId:  widget.channelName??"",options:  ChannelMediaOptions(),uid:  0);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine!.registerEventHandler(RtcEngineEventHandler(
        error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      print(uid);
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) async {
      Map<int, dynamic>? tempGuestInfo = await FirestoreServices.getMultiGuests(widget.channelName??"");

      setState(() {
        guestInfos = tempGuestInfo!;
        final info = 'userJoined: $uid';
        connecting = false;
        _infoStrings.add(info);
        _users.add(uid);
        print(info);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.30,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: StreamBuilder(
            stream: FirestoreServices().getChats(widget.channelName),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              List<ChatModel> chats = [];
              chats  = snapshot.data as List<ChatModel>;

              return ListView.builder(
                reverse: true,
                itemCount: chats.length,
                itemBuilder: (context, i) {
                  ChatModel chat = chats[i];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              !chat.name!.contains('null')
                                  ? GestureDetector(
                                onTap: () async {
                                  if (user?.userId == chat.userId) {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        backgroundColor: Colors.white,
                                        builder: (context) {
                                          return Viewprofile_model(
                                            userId: user?.userId,
                                            image: user?.image,
                                            name: user?.name,
                                            bio: user?.bio,
                                            countryName: user?.countryName,
                                            gender: user?.gender,
                                            uniqueId: user?.uniqueId,
                                            coverphoto:
                                            user?.coverPhotos?[1].image,
                                            userModel: user,
                                            isBrodcaster: true,
                                            channelName:
                                            widget.channelName,
                                          );
                                        });
                                  }
                                  String status = "";
                                  FollowModel? model =
                                  await UserFollowService()
                                      .checkFollowStatus(chat.userId!);
                                  FollowModel? model1 =
                                  await UserFollowService()
                                      .checkFriendStatus(chat.userId!);
                                  if (model!.data!.following! &&
                                      model1!.data!.following!) {
                                    status = "Friend";
                                  } else if (!model.data!.following! &&
                                      !model1!.data!.following!) {
                                    status = "Follow";
                                  } else if (model.data!.following !&&
                                      !model1!.data!.following!) {
                                    status = "Following";
                                  } else if (!model.data!.following! &&
                                      model1!.data!.following!) {
                                    status = "Follow back";
                                  }

                                  CurrentUserModel? userModel =
                                  await ProfileUpdateServices()
                                      .getUserProfile(chat.userId);
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isDismissible: true,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    builder: (BuildContext context) {
                                      return UserProfileDailog(
                                        userModel: userModel!,
                                        status: status,
                                        broadcaster: widget.broadcaster!,
                                        channelName: widget.channelName??"",
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                    height: 20,
                                    width: MediaQuery.of(context).size.width * 0.14,
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft,
                                          colors: [
                                            Color(int.parse(
                                                "${chat.rlColorCode!.replaceFirst("#", "0xff")}")),
                                            Colors.black87
                                          ],
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 8,
                                          backgroundImage:
                                          NetworkImage(chat.rlIcon!),
                                        ),

                                        Text(
                                          "LV.${chat.runningLevel}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                        //    Spacer(),
                                      ],
                                    )),
                              )
                                  : Container(),
                              SizedBox(
                                width: 5.w,
                              ),
                              Flexible(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      chat.name!.contains('null')
                                          ? TextSpan()
                                          : TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              if (user?.userId ==
                                                  chat.userId) {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled:
                                                    true,
                                                    isDismissible: true,
                                                    backgroundColor:
                                                    Colors.white,
                                                    builder: (context) {
                                                      return Viewprofile_model(
                                                        userId: user?.userId,
                                                        image: user?.image,
                                                        name: user?.name,
                                                        bio: user?.bio,
                                                        countryName: user
                                                            ?.countryName,
                                                        gender: user?.gender,
                                                        uniqueId:
                                                        user?.uniqueId,
                                                        coverphoto: user
                                                            ?.coverPhotos?[1]
                                                            .image,
                                                        userModel: user,
                                                        isBrodcaster: true,
                                                        channelName: widget
                                                            .channelName,
                                                      );
                                                    });
                                              }
                                              String status = "";
                                              FollowModel? model =
                                              await UserFollowService().checkFollowStatus(chat.userId!);
                                              FollowModel? model1 =
                                              await UserFollowService().checkFriendStatus(chat.userId!);
                                              if (model!.data!.following! &&
                                                  model1!.data!.following!) {
                                                status = "Friend";
                                              } else if (!model
                                                  .data!.following! &&
                                                  !model1!.data!.following!) {
                                                status = "Follow";
                                              } else if (model
                                                  .data!.following !&&
                                                  !model1!.data!.following!) {
                                                status = "Following";
                                              } else if (!model
                                                  .data!.following! &&
                                                  model1!.data!.following!) {
                                                status = "Follow back";
                                              }

                                              CurrentUserModel? userModel =
                                              await ProfileUpdateServices()
                                                  .getUserProfile(
                                                  chat.userId);
                                              showModalBottomSheet<void>(
                                                context: context,
                                                isDismissible: true,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                Colors.white,
                                                builder:
                                                    (BuildContext context) {
                                                  return UserProfileDailog(
                                                    userModel: userModel!,
                                                    status: status,
                                                    broadcaster:
                                                    widget.broadcaster!,
                                                    channelName:
                                                    widget.channelName??"",
                                                  );
                                                },
                                              );
                                            },
                                          text: '${chat.name} : ',
                                          style: TextStyle(
                                              color: Colors
                                                  .deepPurple.shade500,
                                              fontSize: 12)),
                                      chat.name!.contains('null') && chat.userId == user?.userId
                                          ? TextSpan(
                                          text: '${chat.message}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14))
                                          :!chat.name!.contains('null')?TextSpan(
                                          text: '${chat.message}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)):TextSpan(text: 'New user joined this room, come & chat together !'
                                          ,style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              chat.giftUrl != null &&
                                  !chat.giftUrl!.contains('null')
                                  ? Image.network(
                                chat.giftUrl!,
                                height: 25.h,
                                width: 25.w,
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  initializeViewerStream() async {
    _viewerStream = FirebaseFirestore.instance
        .collection("live_streams")
        .doc(widget.channelName)
        .collection("viewers")
        .where('status', whereIn: [1, 2])
        .snapshots()
        .listen((QuerySnapshot q) {
          setState(() {
            requester = q.docs.length;
          });
        });
  }

  _getRenderViews() {
    Widget? primary;
    if (widget.broadcaster!) {
      primary = RtcLocalView.SurfaceView();
    } else {
      if (_users.contains(us[0])) {
        setState(() {
          liveLoading = "Live ended by broadcaster";
        });

        primary = RtcRemoteView.SurfaceView(uid: us[0]);
      }
    }

    Map<int, Widget> guests = {};
    if (guest != null) {
      guests[guest!] = RtcLocalView.SurfaceView();
    }

    _users.forEach((int uid) {
      if (uid != us[0]) {
        guests[uid] = RtcRemoteView.SurfaceView(uid: uid);
      }
    });

    return [primary, guests];
  }

  Widget _viewRows() {
    final views = _getRenderViews();

    String? primaryName =
        widget.broadcastUser != null ? widget.broadcastUser?.name : user?.name;
    if (views[0] != null) {
      if (widget.seats == 4) {
        return MultiGuestRender4(
          primary: views[0],
          guest: views[1],
          us: us,
          guestInfo: guestInfos,
          primaryName: primaryName,
          onJoin: (val) async {
            if (!(_users.contains(val))) {
              if (!widget.broadcaster! && guest == null) {
                FirestoreServices.storeMultiGuests(
                    widget.channelName??"", val.toString());
                print("You can enter");
                guest = val;
                await _engine!.leaveChannel();
                initializeForBroadcaster(val);
              } else {
                print("You can not enter");
              }
            }
          },
        );
      } else if (widget.seats == 6) {
        return Container(
          padding: EdgeInsets.only(top: 70.h.w),
          child: MultiGuestRender6(
            primary: views[0],
            guest: views[1],
            us: us,
            guestInfo: guestInfos,
            primaryName: primaryName,
            onJoin: (val) async {
              if (!(_users.contains(val))) {
                if (!widget.broadcaster! && guest == null) {
                  FirestoreServices.storeMultiGuests(
                      widget.channelName??"", val.toString());

                  print("You can enter");
                  guest = val;
                  await _engine!.leaveChannel();
                  initializeForBroadcaster(val);
                } else {
                  print("You can not enter");
                }
              }
            },
          ),
        );
      } else if (widget.seats == 9) {
        return Container(
          padding: EdgeInsets.only(top: 70),
          child: MultiGuestRender9(
            primary: views[0],
            guest: views[1],
            us: us,
            guestInfo: guestInfos,
            primaryName: primaryName,
            onJoin: (val) async {
              if (!(_users.contains(val))) {
                if (!widget.broadcaster! && guest == null) {
                  FirestoreServices.storeMultiGuests(
                      widget.channelName??"", val.toString());
                  print("You can enter");
                  guest = val;
                  await _engine!.leaveChannel();
                  await initializeForBroadcaster(val);
                }
              }
            },
          ),
        );
      }
      return Container();
    } else {
      return Container(
        child: Center(
          child: Text(
            connecting ? "Connecting" : liveLoading,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  final player = AudioCache(prefix: '');

  List<Tab> giftTabs = [];
  bool isLoad = false;
  GiftCategorys() async {
    await LiveService().giftCategory().then((value) {
      giftCategory = value;
      for (var i = 0; i < value.data!.length; i++) {
        print("lengthhh=== ${value.data!.length}");
        giftTabs.add(Tab(
          text: value.data![i].name,
        ));
      }
      Gift(int.parse(giftCategory!.data![0].categoryId!));
    });
  }

  Gift(catid) async {
    setState(() {
      isLoad = true;
    });

    giftData =
        await LiveService().fetchallGift(catid: catid, userid: user!.userId);
    print('Gifted Data === ${giftData!.data!.length}');
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int seconds = timerServices.getCurrentTime();
        closeLiveModal(context, widget.channelName??"", seconds,"multi");
        return false;
      },
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            'images/start.gif',
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          )),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: loading
                  ? Loading()
                  : Center(
                      child: Stack(
                        children: [
                          Container(
                            // decoration: BoxDecoration(
                            //    ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: _panel(),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xEE000000)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  openModalBottomSheetForMessage(
                                                      context,
                                                      widget.channelName??"",
                                                      _comment);
                                                },
                                                icon: Icon(
                                                  Icons.message_outlined,
                                                  color: Colors.white,
                                                )),
                                            IconButton(
                                                onPressed: () {},
                                                // onPressed: () {
                                                //   showModalBottomSheet(
                                                //       context: context,
                                                //       elevation: 0,
                                                //       isScrollControlled: true,
                                                //       barrierColor:
                                                //           Colors.transparent,
                                                //       isDismissible: true,
                                                //       backgroundColor:
                                                //           Colors.transparent,
                                                //       builder: (context) {
                                                //         return StatefulBuilder(
                                                //             builder: (context,
                                                //                 state) {
                                                //           return DraggableScrollableSheet(
                                                //             expand: false,
                                                //             initialChildSize:
                                                //                 .17,
                                                //             minChildSize: .17,
                                                //             maxChildSize: .17,
                                                //             builder: (context,
                                                //                 scrollController) {
                                                //               return Container(
                                                //                 decoration: BoxDecoration(
                                                //                     color: Colors
                                                //                         .black38,
                                                //                     borderRadius: BorderRadius.only(
                                                //                         topLeft:
                                                //                             Radius.circular(
                                                //                                 30),
                                                //                         topRight:
                                                //                             Radius.circular(30))),
                                                //                 child: GridView
                                                //                     .builder(
                                                //                   itemCount: 23,
                                                //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                //                       crossAxisCount:
                                                //                           2,
                                                //                       childAspectRatio:
                                                //                           1.2,
                                                //                       crossAxisSpacing:
                                                //                           15,
                                                //                       mainAxisSpacing:
                                                //                           15),
                                                //                   scrollDirection:
                                                //                       Axis.horizontal,
                                                //                   itemBuilder:
                                                //                       (BuildContext
                                                //                               context,
                                                //                           int index) {
                                                //                     return GestureDetector(
                                                //                         // onTap:
                                                //                         //     () async {
                                                //                         //   player
                                                //                         //       .play(
                                                //                         //     emoji['song']
                                                //                         //         [
                                                //                         //         index],
                                                //                         //   );
                                                //                         // },
                                                //                         // child: Image.asset(
                                                //                         //     emoji['images']
                                                //                         //         [
                                                //                         //         index]),
                                                //                         );
                                                //                   },
                                                //                 ),
                                                //               );
                                                //             },
                                                //           );
                                                //         });
                                                //       });
                                                // },
                                                icon: Icon(
                                                  Icons.emoji_emotions_outlined,
                                                  color: Colors.white,
                                                )),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  muted = !muted;
                                                });
                                                _engine!.muteLocalAudioStream(
                                                    muted);
                                              },
                                              icon: Icon(
                                                muted
                                                    ? Icons.mic_off
                                                    : Icons.mic,
                                                color: muted
                                                    ? Colors.red
                                                    : Colors.white,
                                                size: 20.0.sp,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.menu,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    isDismissible: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                          builder:
                                                              (context, state) {
                                                        return DraggableScrollableSheet(
                                                          expand: false,
                                                          initialChildSize: .4,
                                                          minChildSize: .4,
                                                          maxChildSize: .4,
                                                          builder: (context,
                                                              scrollController) {
                                                            return Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                30),
                                                                        topRight:
                                                                            Radius.circular(30))),
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 10),
                                                                              child: IconButton(
                                                                                  iconSize: 35,
                                                                                  color: Colors.black,
                                                                                  onPressed: () {
                                                                                    _engine!.switchCamera();
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons.camera_alt_outlined,
                                                                                    color: Colors.red,
                                                                                    size: 35,
                                                                                  )),
                                                                            ),
                                                                            Text(
                                                                              'Flip',
                                                                              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 10),
                                                                              child: IconButton(
                                                                                  disabledColor: Colors.grey,
                                                                                  iconSize: 35,
                                                                                  color: Colors.black,
                                                                                  onPressed: () {
                                                                                    // _engine.switchCamera();
                                                                                  },
                                                                                  icon: Image.asset(
                                                                                    "images/share.png",
                                                                                    color: Colors.red,
                                                                                    width: 25,
                                                                                    height: 25,
                                                                                  )),
                                                                            ),
                                                                            Text(
                                                                              'Share',
                                                                              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ));
                                                          },
                                                        );
                                                      });
                                                    });
                                              },
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      isDismissible: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                state) {
                                                          return DraggableScrollableSheet(
                                                            expand: false,
                                                            initialChildSize:
                                                                .6,
                                                            minChildSize: .6,
                                                            maxChildSize: .6,
                                                            builder: (context,
                                                                scrollController) {
                                                              return Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              30),
                                                                          topRight: Radius.circular(
                                                                              30))),
                                                                  child:
                                                                      DefaultTabController(
                                                                    length: 2,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.only(left: 50),
                                                                          height:
                                                                              MediaQuery.of(context).size.height * .07,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: TabBar(
                                                                                labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 17.sp),
                                                                                unselectedLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17.sp),
                                                                                indicatorColor: Colors.red,
                                                                                labelColor: Colors.red,
                                                                                unselectedLabelColor: Colors.black,
                                                                                tabs: [
                                                                                  Container(
                                                                                    child: Text("WAITING"),
                                                                                  ),
                                                                                  Container(
                                                                                    child: Text("GUEST LIVE"),
                                                                                  )
                                                                                ],
                                                                              )),
                                                                              // Container(
                                                                              //   width:
                                                                              //       60,
                                                                              //   child:
                                                                              //       IconButton(
                                                                              //     onPressed:
                                                                              //         () {
                                                                              //       Navigator.of(context).pop();
                                                                              //     },
                                                                              //     icon:
                                                                              //         Icon(Icons.clear),
                                                                              //   ),
                                                                              // )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Container(
                                                                          padding:
                                                                              EdgeInsets.only(left: 20),
                                                                          child:
                                                                              TabBarView(
                                                                            children: [
                                                                              MultiVideoWaitList(
                                                                                channelName: widget.channelName??"",
                                                                                broadcaster: widget.broadcaster!,
                                                                                user: user!,
                                                                              ),
                                                                              VideoLiveGuestList(
                                                                                channelName: widget.channelName??"",
                                                                                broadcaster: widget.broadcaster!,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                        widget.broadcaster!
                                                                            ? Container()
                                                                            : AudioVideoJoin(
                                                                                channelName: widget.channelName,
                                                                                // onStartListen:
                                                                                // onStartListen,
                                                                                // user:
                                                                                // user,
                                                                              )
                                                                      ],
                                                                    ),
                                                                  ));
                                                            },
                                                          );
                                                        });
                                                      });
                                                },
                                                icon:badge. Badge(
                                                    badgeContent: Text(
                                                      "$requester",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    position:
                                                        BadgePosition.topEnd(),
                                                    showBadge: widget.broadcaster! &&
                                                        requester != 0
                                                        ? true
                                                        : false,
                                                    child: Image.asset(
                                                        "images/Join_live_list.png"))),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            widget.broadcaster!
                                                ? SizedBox(
                                                    width: 70.w,
                                                  )
                                                : Container(
                                                    width: 55.w,
                                                  ),
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      isDismissible: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) {
                                                        return Gift_Model(
                                                          user: user!,
                                                          broadcaster: widget
                                                              .broadcaster!,
                                                          channelName: widget
                                                              .channelName??"",
                                                          broadcastUser : widget
                                                              .broadcastUser!,
                                                        );
                                                      });
                                                },
                                                icon: Image.asset(
                                                    "images/Gift.png")),

                                            // Icon(
                                            //   Icons.share_outlined,
                                            //   color: Colors.black,
                                            // ),
                                            // Icon(
                                            //   Icons.flip_camera_ios_outlined,
                                            //   color: Colors.black,
                                            // ),
                                            // Icon(
                                            //   Icons.mic_none_outlined,
                                            //   color: Colors.black,
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _viewRows(),
                          LiveHeader(
                              isAudio: false,
                              isMute: muted,
                              broadcastUser: widget.broadcastUser!,
                              broadcaster: widget.broadcaster!,
                              channelName: widget.channelName??"",
                              msgText: widget.msgText??"",
                              userchannelId: user?.uniqueId??"",
                              onClose: () {
                                if (widget.broadcaster!) {
                                  int seconds = timerServices.getCurrentTime();
                                  closeLiveModal(context, widget.channelName??'', seconds, "multi");
                                  timerServices.close();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              onView: () {
                                openAllViewerModal(context,
                                    widget.channelName??"",
                                    user?.userId,
                                    widget.broadcastUser,
                                    widget.broadcaster,
                                    false);
                              }),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool isJoin = false;
}

getJoinUser(ViewerModel viewers, CurrentUserModel user) async {
  print(' USer id  = ${viewers.uid}');
  print(' USer id  = ${user.userId}');
  bool i = viewers.uid!.contains(user.userId!);
  return i;
}

class MultiVideoWaitList extends StatefulWidget {
  final String? channelName;
  final bool? broadcaster;
  CurrentUserModel? user;

  MultiVideoWaitList(
      {this.channelName, this.broadcaster, this.user});

  @override
  _MultiVideoWaitListState createState() => _MultiVideoWaitListState();
}

class _MultiVideoWaitListState extends State<MultiVideoWaitList> with WidgetsBindingObserver {
  bool _switchValue = false;
  int guestLive = 0;
  bool isUserJoin = false;

  @override
  void initState() {
    FirestoreServices().getVideoViewer(widget.channelName??"")!.forEach((element) {
      List<ViewerModel> viewers = element;
      guestLive = viewers.length;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
          stream: FirestoreServices().getVideoWaitingViewer(widget.channelName??""),
          builder: (context, AsyncSnapshot<List<ViewerModel>>snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            List<ViewerModel>? viewers = snapshot.data as List<ViewerModel>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    children: [
                      Text(
                        "Waiting List (${snapshot.data!.length})",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Spacer(),
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
                      ViewerModel viewer = viewers[i];
                      print("viewers listt ${viewers[i]}");

                      return ListTile(
                        leading: viewer.photoUrl != null
                            ? CircleAvatar(
                          radius: 25.r,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: HexagonProfilePicNetworkImage(
                                url: viewer.photoUrl??"",
                              )),
                        )
                            : InitIconContainer(
                          radius: 40,
                          text: viewer.name??"",
                        ),
                        title: Text(
                          viewer.name??"",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        trailing: widget.broadcaster!
                            ? Container(
                          width: 90.w,
                          height: 25.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:MaterialStatePropertyAll( Colors.red,) ,
                                shape:MaterialStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20.r)))
                            ),
                            onPressed: () async {
                              if (guestLive < 3) {
                                FirestoreServices.addUserToVideoLive(
                                    viewer.status!,
                                    widget.channelName??"",
                                    viewer.uid!);
                                isUserJoin = await getJoinUser(
                                    viewer, widget.user!);
                                // setState(() {});
                                print(
                                    'is User joined ===${viewer.uid}');
                                print(
                                    'is User joined ===${widget.user?.userId}');
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                    "Sorry! Maximum 3 Guest are Allow.");
                              }
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Icon(
                                  viewer.status == 1
                                      ? Icons.mic_none_outlined
                                      : Icons.videocam,
                                  color: Colors.white,
                                  size: 15,
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
                          width: 1,
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

class VideoLiveGuestList extends StatefulWidget {
  final String? channelName;
  final bool? broadcaster;
  VideoLiveGuestList({this.channelName, this.broadcaster});

  @override
  _VideoLiveGuestListState createState() => _VideoLiveGuestListState();
}

class _VideoLiveGuestListState extends State<VideoLiveGuestList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
      stream: FirestoreServices().getVideoGuestViewer(widget.channelName??""),
      builder: (context, AsyncSnapshot<List<ViewerModel>>snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        List<ViewerModel> viewers = snapshot.data as List<ViewerModel>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Guest List (${snapshot.data!.length})",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            Container(
                child: ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: viewers.length,
              itemBuilder: (context, i) {
                ViewerModel viewer = viewers[i];
                print(viewer);
                return ListTile(
                    leading: viewer.photoUrl != null
                        ? CircleAvatar(
                            radius: 20.r,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40.r),
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
                      style: TextStyle(fontSize: 14.sp),
                    ));
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
    ));
  }
}
