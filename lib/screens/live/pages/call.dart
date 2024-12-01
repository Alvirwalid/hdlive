import 'dart:async';
import 'dart:math';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart' as badge;
import 'package:badges/badges.dart%20';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive/models/chat_model.dart';
import 'package:hdlive/models/current_user_model.dart';
import 'package:hdlive/models/followmodel.dart';
import 'package:hdlive/models/live_model.dart';
import 'package:hdlive/models/viewer_model.dart';
import 'package:hdlive/screens/live/all_viewer_modal.dart';
import 'package:hdlive/screens/live/close_live_bottom_modal.dart';
import 'package:hdlive/screens/live/pages/GuestList.dart';
import 'package:hdlive/screens/live/pages/gift_model.dart';
import 'package:hdlive/screens/profile/user_profile_dailog.dart';
import 'package:hdlive/screens/shared/bottom_scrollsheet_message.dart';
import 'package:hdlive/screens/shared/initIcon_container.dart';
import 'package:hdlive/screens/shared/network_image.dart';
import 'package:hdlive/screens/withAuth/go_live/live_header.dart';
import 'package:hdlive/screens/withAuth/profile/viewprofile_model.dart';
import 'package:hdlive/services/firestore_services.dart';
import 'package:hdlive/services/profile_update_services.dart';

import 'package:hdlive/services/timer_services.dart';
import 'package:hdlive/services/token_manager_services.dart';
import 'package:hdlive/services/userfollowservice.dart';
import 'package:hdlive/utils/utility.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock/wakelock.dart';
import '../../shared/loading.dart';
import '../utils/settings.dart';
import 'package:native_video_view/native_video_view.dart' as native;
class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String? channelName;
  final String? msgText;

  /// non-modifiable client role of the page
  final int? role;
  final bool? broadcaster;
  final LiveModel? broadcastUser;

  /// Creates a call page with given channel name.
  const CallPage(
      {Key? key,
      this.channelName,
      this.msgText,
      this.role,
      this.broadcastUser,
      this.broadcaster = false})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> with WidgetsBindingObserver {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool iscamera = false;
  RtcEngine? _rtcEngine;

  TextEditingController _comment = TextEditingController();

  StreamSubscription? _stream;
  StreamSubscription? _viewerStream;
  bool guest = false;
  bool userAudioMute = true;
  bool broadcasterAudioMute = false;
  bool broadcasterVideoMute = false;
  TimerServices timerServices = TimerServices();

  String liveLoading = "Loading";
  int requester = 0;
  CurrentUserModel? user;
  String appId = "";

  List<ViewerModel> Viewers = [];

  //video disable
  bool videoDisabled = false;
  bool inviteView = false;
  Timer? timer;
  bool broadcasterLeft = false;
  bool volumeOff = false;

  @override
  void dispose() {
    timer?.cancel();
    FirestoreServices.insertNewComment(widget.channelName??"", "Left");
    _users.clear();

    _rtcEngine!.leaveChannel();

    _rtcEngine=null;
    _comment.dispose();
    if (_stream != null) {
      _stream!.cancel();
    }

    if (_viewerStream != null) {
      _viewerStream!.cancel();
    }
    timerServices.close();
    disposeLive();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool pipmode = false;
  bool pipButtonmode = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("ChangeApp -- $state");
    if (state == AppLifecycleState.resumed) {
      setState(() {
        pipmode = false;
        pipButtonmode = false;
      });
    } else if (state == AppLifecycleState.inactive) {
      if(!pipButtonmode){
        pipmod();
      }
      setState(() {
        pipmode = true;
      });
    }
  }


  static const platform = const MethodChannel('flutter.rortega.com.channel');

  Future<void> pipmod() async {
    await platform.invokeMethod('showNativeView');
  }

  disposeLive() async {
    if (widget.broadcaster!) {
      await FirestoreServices.onWillPop(widget.channelName??"");
    } else {
      await FirestoreServices.onGuestLeave(widget.channelName??"");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    // initialize agora sdk
    getuser();
    initialize();
    join.clear();
    initializeViewerStream();

    if (!widget.broadcaster!) {
      FirestoreServices.newUserJoined(widget.channelName??"");
      FirestoreServices.insertNewComment(widget.channelName??"", "Joined");
      FirestoreServices.insertDefaultComment(widget.channelName??"");
    }
    timer = Timer.periodic(
        Duration(minutes: 2), (Timer t) => Utility().getLoginStatus(context));
    
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

  getuser() async {
    print("userphotoooooo>>>>>>>>>");

    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId, true);
    print("userphotoooooo>>>>>>>>>$user");
    setState(() {
      inviteView = true;
    });
  }

  Future<void> initialize() async {
    appId = await TokenManagerServices().getAgoraAppId();
    _initialPermissionsAndInitialization();
    if (widget.broadcaster!) {
      initializeForBroadcaster();
      timerServices.startTimer();

      // dependencies.stopwatch.start();
    } else {
      initializeForOthers();
    }
  }

  Future<void> _handlePermissions(Permission permission) async {
    await permission.request();
  }

  _initialPermissionsAndInitialization() async {
    await _handlePermissions(Permission.camera);
    await _handlePermissions(Permission.microphone);
    bool isKeptOn = await Wakelock.enabled;
    if (!isKeptOn) {
      Wakelock.enable();
    }
    // bool isKeptOn = await Screen.isKeptOn;
    // if (!isKeptOn) {
    //   Screen.keepOn(true);
    // }
  }

  Future<void> initializeForBroadcaster() async {
    String APP_ID = await TokenManagerServices().getAgoraAppId();
    _rtcEngine = await createAgoraRtcEngine();
    _rtcEngine!.initialize(RtcEngineContext(appId: APP_ID));
    await _rtcEngine!.enableVideo();
    await _rtcEngine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);

    await _rtcEngine!.setClientRole(role:ClientRoleType.clientRoleBroadcaster,options:ClientRoleOptions());

    _addAgoraEventHandlers();

    await _rtcEngine!.enableWebSdkInteroperability(true);

    VideoEncoderConfiguration configuration = VideoEncoderConfiguration(dimensions: VideoDimensions(width: 1920, height: 1080));
    await _rtcEngine!.setVideoEncoderConfiguration(configuration);

    // Join the channel (broadcaster or audience based on widget.broadcaster)
    if (widget.broadcaster!) {
      await _rtcEngine!.joinChannel(
        token: Token,
        channelId: widget.channelName ?? "",
        uid: 10010, // Set the broadcaster UID
        options: ChannelMediaOptions(),
      );
    } else {
      await _rtcEngine!.joinChannel(
        token: Token,
        channelId: widget.channelName ?? "",
        uid: 0, // Set the audience UID
        options: ChannelMediaOptions(),
      );
    }
  }

  // Future<void> initializeForBroadcaster() async {
  //   String APP_ID = await TokenManagerServices().getAgoraAppId();
  //   _rtcEngine = await RtcEngine.create(APP_ID);
  //
  //   await _rtcEngine!.enableVideo();
  //   await _rtcEngine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
  //   await _rtcEngine!.setClientRole(ClientRole.Broadcaster);
  //
  //   _addAgoraEventHandlers();
  //   await _rtcEngine!.enableWebSdkInteroperability(true);
  //   VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
  //   configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
  //   await _rtcEngine!.setVideoEncoderConfiguration(configuration);
  //   if (widget.broadcaster!) {
  //     await _rtcEngine!.joinChannel(Token, widget.channelName??"", null, 10010);
  //   } else {
  //     await _rtcEngine!.joinChannel(Token, widget.channelName??"", null, 0);
  //   }
  // }

  Future<void> initializeForOthers() async {
    String APP_ID = await TokenManagerServices().getAgoraAppId();
    RtcEngine _engine = await createAgoraRtcEngine();
    _engine.initialize(RtcEngineContext(appId:APP_ID));
    await _rtcEngine!.enableVideo();
    await _rtcEngine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _rtcEngine!.setClientRole(role:ClientRoleType.clientRoleAudience);
    _addAgoraEventHandlers();

    await _rtcEngine!.joinChannel(token:Token,channelId:widget.channelName??"", options: ChannelMediaOptions(),uid:  0);
  }

  bool _joined = false;

  Future<void> initPlatformState(bool mute) async {
    await _rtcEngine!.muteAllRemoteAudioStreams(mute);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _rtcEngine!.registerEventHandler(
        RtcEngineEventHandler(
            onError: (ErrorCodeType err, String msg) {
      setState(() {
        final info = 'onError: $msg';
        _infoStrings.add(info);
      });
    },
    onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      setState(() {
        final info = 'onJoinChannel: $connection, uid: $elapsed';
        _infoStrings.add(info);
        setState(() {
          _joined = true;
        });
      });
    },
  onLeaveChannel: (RtcConnection connection, RtcStats stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    },
 onUserJoined: (RtcConnection uid,int remoteId, int elapsed) {
              setState(() {
                // Update the info string with the user join info
                final info = 'User Joined: $remoteId';
                _infoStrings.add(info);

                // Add the user UID to the list of users
                _users.add(remoteId);
              });
            },
 onUserOffline: (RtcConnection connection, int remoteUid,
                UserOfflineReasonType reason) {
      setState(() {
        final info = 'userOffline: $remoteUid';
        _infoStrings.add(info);
        if (remoteUid == 10010) {
          liveLoading = "Live ended by broadcaster";
          broadcasterLeft = true;
          _users.remove(remoteUid);
        }
      });
    },
            onFirstRemoteVideoFrame: (RtcConnection connection, int remoteUid, int width,int height, int elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $remoteUid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  bool showmenu = false;
  bool isCameraShown = false;
  dynamic views;

  /// Video layout wrapper
  Widget _viewRows() {
    views = _getRenderViews();
    print("views-- $views");
    if (views != null && views[0] != null) {
      print("videolistttt${views[0]}");
      return (Stack(
        children: [
          views[0],
        ],
      ));
    } else {
      return Container(
        child: Center(
          child: Text(
            "$liveLoading",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  bool isMute = false;
  bool isNext = true;

  _getRenderViews() {
    Widget primary;
    FirestoreServices().getVideoViewer(widget.channelName??"")!.forEach((element) {
      Viewers = element;

      print("getRenderViews ---- ${Viewers} ");
    });
    if (widget.broadcaster!) {
      primary = SurfaceView();
      FirebaseFirestore.instance
          .collection("live_streams")
          .doc(widget.channelName)
          .collection("viewers")
          .where('uid')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          var i = element.data();
          if (Viewers.length != 0 &&
              i['uid'].toString().contains(Viewers[0].uid!)) {
            FirebaseFirestore.instance
                .collection("live_streams")
                .doc(widget.channelName)
                .collection("viewers")
                .doc(Viewers[0].uid.toString())
                .get()
                .then((value) {
              isCameraShown = value.get('iscamera');
            });
          }
        });
      });
    } else {
      primary = RtcRemoteView.SurfaceView(uid: 10010);
    }
    List<Widget> guests = [];

    print("Viewers ${Viewers.length}");
    print("camera status====>$isCameraShown");

    print("total guests---${guests.length}");
    return [primary, guests];
  }

  /// Info panel to show logs
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
                                            user!.coverPhotos?[1].image,
                                            userModel: user,
                                            isBrodcaster: true,
                                            channelName:
                                            widget.channelName,
                                          );
                                        });
                                  }
                                  String status = "";
                                  FollowModel? model = await UserFollowService().checkFollowStatus(chat.userId!);
                                  FollowModel? model1 = await UserFollowService().checkFriendStatus(chat.userId!);
                                  if (model!.data!.following! &&
                                      model1!.data!.following!) {
                                    status = "Friend";
                                  } else if (!model.data!.following! &&
                                      !model1!.data!.following!) {
                                    status = "Follow";
                                  } else if (model.data!.following! &&
                                      !model1!.data!.following!) {
                                    status = "Following";
                                  } else if (!model.data!.following! &&
                                      model1!.data!.following!) {
                                    status = "Follow back";
                                  }

                                  CurrentUserModel? userModel = await ProfileUpdateServices().getUserProfile(chat.userId);
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
                                              FollowModel? model = await UserFollowService().checkFollowStatus(chat.userId!);
                                              FollowModel? model1 = await UserFollowService().checkFriendStatus(chat.userId!);
                                              if (model!.data!.following! &&
                                                  model1!.data!.following!) {
                                                status = "Friend";
                                              } else if (!model
                                                  .data!.following! &&
                                                  !model1!.data!.following!) {
                                                status = "Follow";
                                              } else if (model
                                                  .data!.following! &&
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

  void _onCallEnd(BuildContext context) async {
    await _rtcEngine!.setClientRole(role:ClientRoleType.clientRoleAudience,options: ClientRoleOptions());
    FirestoreServices.joinUserRemove(widget.channelName??"", user?.userId??"");
    setState(() {
      guest = false;
      Navigator.pop(context);
    });
  }

  void _onCallEndUser(BuildContext context) async {}

  Future<void> _onToggleMute() async {
    setState(() {
      muted = !muted;
    });
    await _rtcEngine!.muteLocalAudioStream(muted);
    await _rtcEngine!.muteLocalVideoStream(muted);
    FirestoreServices.onMute(widget.channelName??"", muted);
  }

  void _onTogglecamera() {
    setState(() {
      iscamera = !iscamera;
    });
    if (widget.broadcaster!) {
      FirestoreServices.oncamera(widget.channelName??"", iscamera);
    }
    _rtcEngine!.muteLocalVideoStream(true);
  }

  void _onSwitchCamera() {
    _rtcEngine!.switchCamera();
  }

  void onStartListen() async {
    _stream = FirebaseFirestore.instance
        .collection("live_streams")
        .doc(widget.channelName)
        .collection("viewers")
        .where('status', whereIn: [3, 4, 6])
        .snapshots()
        .listen((QuerySnapshot q) {
          if (q.docs.length > 0) {
            q.docs.forEach((d) async {
              Map<String, dynamic> data = d.data() as Map<String, dynamic>;
              print('firebase doc data ==== ${d.id}');
              print('firebase doc data ==== ${d.exists}');

              if (user!.userId == d.id &&
                  (data['status'] == 3 || data['status'] == 4)) {
                guest = true;

                // await _engine.leaveChannel();
                await _rtcEngine!.setClientRole(role:ClientRoleType.clientRoleBroadcaster,options: ClientRoleOptions());

                // initializeForBroadcaster();
                broadcasterAudioMute = data['broadcaster_mute'];
                broadcasterVideoMute = data['broadcaster_video_mute'];
                if ((data['broadcaster_mute'] && data['isMute']) ||
                    (!data['broadcaster_mute'] && !data['isMute'])) {

                   _rtcEngine!.muteLocalAudioStream(broadcasterAudioMute);
                   _rtcEngine!.muteLocalVideoStream(broadcasterVideoMute);
                }
              } else if (user!.userId == d.id &&
                  (data['status'] == 6 ||
                      data['status'] == 0 ||
                      data['status'] == 5)) {
                guest = false;
                await _rtcEngine!.setClientRole(role:ClientRoleType.clientRoleAudience,options: ClientRoleOptions());
              }
            });
          }
        });
  }

  final player = AudioCache(prefix: '');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isdrawerOpen = false;
  bool isdbarOpen = false;
  String giftTime = "";

  //flutterSoundPlayer.release();

  @override
  void deactivate() {
    print('==========  Code Deactivate ===========');
    // TODO: implement deactivate
    super.deactivate();
  }

  List<BeautyModel> beautyList = [
    BeautyModel("images/beauty/7.jpeg"),
    BeautyModel("images/beauty/3.jpeg"),
    BeautyModel("images/beauty/9.jpeg"),
    BeautyModel("images/beauty/2.jpeg"),
    BeautyModel("images/beauty/1.jpeg"),
    BeautyModel("images/beauty/4.jpeg"),
    BeautyModel("images/beauty/5.jpeg"),
    BeautyModel("images/beauty/6.jpeg"),
    BeautyModel("images/beauty/10.jpeg"),
    BeautyModel("images/beauty/8.jpeg"),
    BeautyModel("images/beauty/11.jpeg"),
  ];


  @override
  Widget build(BuildContext context) {
    getGift() {
      try {
        if (FirebaseFirestore.instance
                .collection("live_streams")
                .doc(widget.channelName)
                .collection("gifts") !=
            null) {
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('live_streams')
                  .doc(widget.channelName)
                  .collection("gifts")
                  .doc(widget.channelName)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  print(
                      'AudioPage Gifts--- ${snapshot.data!.get('time').toString()}');
                  print(
                      'AudioPage Gifts--- ${snapshot.data!.get('gifturl').toString()}');
                  if (snapshot.data!.get('time') == giftTime) {
                    print("get Gift Time --$giftTime");
                    return Container();
                  } else {
                    giftTime = snapshot.data!.get('time');

                    if (snapshot.data!.get('gifturl').toString().isNotEmpty &&
                        !snapshot.data
                            !.get('gifturl')
                            .toString()
                            .contains("mp4")) {
                      Future.delayed(const Duration(seconds: 12), () {
                        setState(() {
                          giftTime = snapshot.data!.get('time');
                        });
                      });
                    }
                    return snapshot.data!.exists
                        ? snapshot.data!.get('gifturl').toString().isNotEmpty
                            ? Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    AnimatedAlign(
                                      curve: Curves.easeInOut,
                                      alignment: Alignment.center,
                                      duration: Duration(seconds: 5),
                                      child: snapshot.data
                                              !.get('gifturl')
                                              .toString()
                                              .contains("mp4")
                                          ? Container(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 70, bottom: 60),
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                alignment: Alignment.center,
                                                child: NativeVideoView(
                                                  keepAspectRatio: true,
                                                  showMediaController: false,
                                                  enableVolumeControl: false,
                                                  onCreated: (controller) {
                                                    controller.setVideoSource(
                                                      snapshot.data
                                                          !.get('gifturl'),
                                                      sourceType:
                                                          native.VideoSourceType
                                                              .network,
                                                      requestAudioFocus: true,
                                                    );
                                                  },
                                                  onPrepared:
                                                      (controller, info) {
                                                    debugPrint(
                                                        'NativeVideoView: Video prepared');
                                                    controller.play();
                                                  },
                                                  onError: (controller, what,
                                                      extra, message) {
                                                    setState(() {});
                                                    debugPrint(
                                                        'NativeVideoView: Player Error ($what | $extra | $message)');
                                                  },
                                                  onCompletion: (controller) {
                                                    setState(() {});
                                                    debugPrint(
                                                        'NativeVideoView: Video completed');
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 400,
                                              width: 400,
                                              child: Image.network(
                                                  snapshot.data!.get('gifturl')),
                                            ),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                        : Container();
                  }
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              });
        } else {
          return Center(
            child: Container(),
          );
        }
      } catch (e) {
        print(e);
      }
    }
    getInvite() {
      return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('live_streams')
              .doc(widget.channelName)
              .collection("invite")
              .doc(user?.userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              if (user?.userId == snapshot.data!.get("uid")) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Spacer(),
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'You have to invite this call. '
                                'Are you join call?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('live_streams')
                                            .doc(widget.channelName)
                                            .collection("invite")
                                            .doc(user?.userId)
                                            .delete();

                                        FirestoreServices.addUserToVideoLive(
                                            1,
                                            widget.channelName??"",
                                            snapshot.data!.get("uid"));
                                        guest = true;
                                        await _rtcEngine!.setClientRole(role:ClientRoleType.clientRoleBroadcaster,options: ClientRoleOptions());
                                        broadcasterAudioMute = snapshot.data
                                            !.get("broadcaster_mute");
                                        broadcasterVideoMute = snapshot.data
                                            !.get("broadcaster_video_mute");
                                        await _rtcEngine!.muteLocalAudioStream(
                                            broadcasterAudioMute);
                                        await _rtcEngine!.muteLocalVideoStream(
                                            broadcasterVideoMute);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xC2F90000),
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        child: Text(
                                          "Join Call",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        var collection = FirebaseFirestore
                                            .instance
                                            .collection('live_streams')
                                            .doc(widget.channelName)
                                            .collection("invite");
                                        var snapshot = await collection
                                            .where('uid',
                                                isEqualTo: user?.userId)
                                            .get();
                                        for (var doc in snapshot.docs) {
                                          await doc.reference.delete();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xC2F90000),
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        child: Text(
                                          "No",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Container(),
                );
              }
            } else {
              return Center(
                child: Container(),
              );
            }
          });
    }
    return WillPopScope(
      onWillPop: () async {
        if (widget.broadcaster!) {
          int seconds = timerServices.getCurrentTime();
          closeLiveModal(context, widget.channelName??"", seconds, "video");
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        endDrawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 50,
        drawerDragStartBehavior: DragStartBehavior.down,
        drawerScrimColor: Colors.transparent,
        onDrawerChanged: (val) {
          setState(() {
            isdbarOpen = val;
          });
        },
        key: _scaffoldKey,
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.43,
          decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.10),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: StreamBuilder<List<ViewerModel>>(
            stream: FirestoreServices().getViewerLive(widget.channelName??""),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.length > 0) {
                var lenth = snapshot.data!.length;
                print("Live User $lenth");
                List<ViewerModel> viewers = snapshot.data as List<ViewerModel>;
                return Container(
                    child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  shrinkWrap: false,
                  itemCount: viewers.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("LiveUserList ===${_users.length}");
                    return _users.length > 0? listItem(context, viewers[index], _users[index]):Container();
                  },
                ));
              } else {
                return Container();
              }
            },
          ),
        ),
        backgroundColor: Color(0xFFF42408),
        body: GestureDetector(
          onTap: () {
            setState(() {
              isdrawerOpen = true;
            });
            Future.delayed(Duration(seconds: 2)).then((value) {
              setState(() {
                isdrawerOpen = false;
              });
            });
          },
          child: SafeArea(
            child: Center(
              child: Stack(
                children: <Widget>[
                  _joined
                      ? _viewRows()
                      : Container(
                          child: Center(
                            child: Loading(size: 100.0,),
                           /* child: Text(
                              "$liveLoading",
                              style: TextStyle(color: Colors.white),
                            ),*/
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Color(0xEE000000)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                      stops: [.5, 1])),
                    child: pipmode ?Container(): Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: _panel(),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            //colors: [Colors.transparent, Color(0xEE000000)],
                            colors: [Colors.transparent, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            //stops: [.5, 1]
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
                                        icon: Image.asset("images/Chat.png")),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.emoji_emotions_outlined,
                                          color: Colors.white,
                                        )),

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
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                  builder: (context, state) {
                                                return DraggableScrollableSheet(
                                                  expand: false,
                                                  initialChildSize: .2,
                                                  minChildSize: .2,
                                                  maxChildSize: .2,
                                                  builder: (context,
                                                      scrollController) {
                                                    return Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        30),
                                                                topRight: Radius
                                                                    .circular(
                                                                        30))),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                widget.broadcaster!
                                                                    ? IconButton(
                                                                        iconSize:
                                                                            35,
                                                                        color: Colors
                                                                            .black,
                                                                        onPressed:
                                                                            () {
                                                                          // _setVideoBeauti();
                                                                          Navigator.pop(
                                                                              context);
                                                                          viewBeauty();
                                                                        },
                                                                        icon: Image.asset(
                                                                            "images/beauty.png"))
                                                                    : Container(),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    final box =
                                                                        context.findRenderObject()
                                                                            as RenderBox;
                                                                    await Share.share(
                                                                        "https://play.google.com/store/apps/details?id=com.lovello.lovello",
                                                                        subject:
                                                                            "HDLive",
                                                                        sharePositionOrigin:
                                                                            box.localToGlobal(Offset.zero) &
                                                                                box.size);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 10
                                                                            .h
                                                                            .w,
                                                                        top: 0
                                                                            .h
                                                                            .w,
                                                                        right: 10
                                                                            .h
                                                                            .w),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          25.h,
                                                                      width:
                                                                          25.w,
                                                                      child: Image
                                                                          .asset(
                                                                        "images/forward.png",
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    ),
                                                                  ),
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

                                    // widget.broadcaster
                                    //     ?
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
                                                    builder: (context, state) {
                                                  return DraggableScrollableSheet(
                                                    expand: false,
                                                    initialChildSize: .6,
                                                    minChildSize: .6,
                                                    maxChildSize: .6,
                                                    builder: (context,
                                                        scrollController) {
                                                      return Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30))),
                                                          child:
                                                              DefaultTabController(
                                                            length: 2,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              50),
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .07,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child:
                                                                              TabBar(
                                                                        labelStyle: TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 17.sp),
                                                                        unselectedLabelStyle: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 17.sp),
                                                                        indicatorColor:
                                                                            Colors.red,
                                                                        labelColor:
                                                                            Colors.red,
                                                                        unselectedLabelColor:
                                                                            Colors.black,
                                                                        tabs: [
                                                                          Container(
                                                                            child:
                                                                                Text("WAITING"),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Text("GUEST LIVE"),
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
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20),
                                                                  child:
                                                                      TabBarView(
                                                                    children: [
                                                                      VideoWaitList(
                                                                        channelName:
                                                                            widget.channelName??"",
                                                                        broadcaster:
                                                                            widget.broadcaster!,
                                                                        user: user!,
                                                                      ),
                                                                      GuestList(
                                                                        channelName:
                                                                            widget.channelName,
                                                                        broadcaster:
                                                                            widget.broadcaster,
                                                                        isVideo:
                                                                            true,
                                                                        callEnd:
                                                                            () async {
                                                                          _onCallEndUser(
                                                                              context);
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                                widget.broadcaster!
                                                                    ? Container()
                                                                    : AudioVideoJoin(
                                                                        channelName:
                                                                            widget.channelName??"",
                                                                        onStartListen:
                                                                            onStartListen,
                                                                        user:user!,
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
                                            position: BadgePosition.topEnd(),
                                            showBadge: widget.broadcaster! &&
                                                    requester != 0
                                                ? true
                                                : false,
                                            child: Image.asset(
                                                "images/Join_live_list.png"))),
                                    //     :
                                    // Container(),

                                    widget.broadcaster!
                                        ? IconButton(
                                            onPressed: _onToggleMute,
                                            icon: Icon(
                                              muted ? Icons.mic_off : Icons.mic,
                                              color: muted
                                                  ? Colors.red
                                                  : Colors.white,
                                              size: 20.0,
                                            ),
                                          )
                                        : Container(),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            volumeOff = !volumeOff;
                                          });
                                          initPlatformState(volumeOff);
                                        },
                                        icon: Icon(
                                          volumeOff?
                                          Icons.volume_off:Icons.volume_up,
                                          color: Colors.white,
                                        )),
                                    //      widget.broadcaster

                                    // ? IconButton(
                                    //     onPressed: () {
                                    //       _engine.switchCamera();
                                    //     },
                                    //     icon: Image.asset("images/Flip.png"))
                                    // : Container(),
                                    // IconButton(
                                    //     onPressed: () {
                                    //       if (videoDisabled) {
                                    //         _engine.enableVideo();
                                    //         videoDisabled = false;
                                    //       } else {
                                    //         _engine.disableVideo();
                                    //         videoDisabled = true;
                                    //       }
                                    //     },
                                    //     icon: Image.asset(
                                    //         "images/Video_turn_off.png")),
                                  ],
                                ),
                              ),
                              widget.broadcaster!
                                  ? SizedBox(
                                      width: 0,
                                    )
                                  : SizedBox(
                                      width: 80,
                                    ),
                              IconButton(
                                  onPressed: () async {
                                    if (broadcasterLeft) {
                                      Fluttertoast.showToast(
                                          msg: 'Sorry! You can not send gift.');
                                      return;
                                    }
                                    var i =
                                        await TokenManagerServices().getData();
                                    user = await ProfileUpdateServices()
                                        .getUserInfo(i.userId, true);
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return Gift_Model(
                                            user: user,
                                            broadcaster: widget.broadcaster,
                                            channelName: widget.channelName,
                                            broadcastUser: widget.broadcastUser,
                                          );
                                        });
                                  },
                                  icon: Image.asset("images/Gift.png")),
                              /*widget.broadcaster
                                  ?IconButton(
                                  onPressed: () {
                                    setState(() {
                                      volumeOff = !volumeOff;
                                    });
                                    initPlatformState(volumeOff);
                                  },
                                  icon:  IconButton(
                                      onPressed: () {},
                                      icon: Image.asset("images/PK.png")))
                                  : Container(),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  !isdrawerOpen || isdbarOpen
                      ? Container()
                      : Positioned(
                          height: MediaQuery.of(context).size.height,
                          left: 0,
                          child: IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 30.sp,
                              ))),
                  pipmode?Container():
                  LiveHeader(
                    isAudio: false,
                    broadcastUser: widget.broadcastUser!,
                    broadcaster: widget.broadcaster!,
                    channelName: widget.channelName??"",
                    msgText: '${widget.msgText}',
                    userchannelId: "user.uniqueId",
                    isMute: true,
                    onClose: () {
                      if (widget.broadcaster!) {
                        int seconds = timerServices.getCurrentTime();
                        closeLiveModal(
                            context, widget.channelName??"", seconds, "video");
                        //timerServices.close();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    onView: () {
                      openAllViewerModal(
                          context,
                          widget.channelName??"",
                          user?.userId,
                          widget.broadcastUser,
                          widget.broadcaster,
                          true);
                    },
                    onGiftView: (){
                      dialogGiftView();
                    },
                    onPipMode: (){
                      pipButtonmode = true;
                      pipmod();
                    },),

              /* widget.broadcaster?Padding(
                    padding: const EdgeInsets.only(top: 70.0,left: 20.0),
                    child: Text('${format(timerService.currentDuration)}'),
                  ):Container(),*/

                  pipmode ? Container():getGift()!,
                  inviteView ? getInvite() : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int randomNote = Random().nextInt(6);
  int randomType = Random().nextInt(6);
  Timer? timerCall;
  String changeTimer = 'Start Timer';

  void stopTimer() {
    timerCall?.cancel();
  }
  Future<void> dialogGiftView() async {
    if (broadcasterLeft) {
      Fluttertoast
          .showToast(
          msg: 'Sorry! You can not send gift.');
      return;
    }
    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId,
        true);
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        isDismissible:true,
        backgroundColor: Colors.transparent,
        builder:(context) {
          return Gift_Model(
            user: user,
            channelName: widget.channelName,
            broadcastUser: widget.broadcastUser,
            broadcaster: widget.broadcaster,
          );
        });
  }

  Widget listItem(BuildContext context, ViewerModel viewer, int userAgora) {
    return Column(
      children: [
        viewer.uid == user?.userId
            ? Container(
                height: 150,
                width: 150,
                // padding: EdgeInsets.only(top: 20),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (viewer.uid != user?.userId) {
                          openProfile(viewer?.uid??"");
                        }
                      },
                      child: isCameraShown && !broadcasterVideoMute
                          ? RtcLocalView.SurfaceView()
                          : Image.network(user?.image??"",
                              width: 300, fit: BoxFit.cover),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          /* color: Colors.black45,*/
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    if (!broadcasterAudioMute) {
                                      setState(() {
                                        isMute = !isMute;
                                      });
                                      print("isMute --> $isMute");
                                      _rtcEngine!.muteLocalAudioStream(isMute);
                                       _rtcEngine!.muteLocalVideoStream(isMute);
                                      // FirestoreServices.broadcasterRightUserMuteUnmute(widget.channelName,isMute,viewer.uid);

                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Sorry! You can't unmute audio to yourself now");
                                    }
                                  },
                                  icon: Icon(
                                    isMute || broadcasterAudioMute
                                        ? Icons.mic_off_rounded
                                        : Icons.mic,
                                    color: Colors.white,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    if (!broadcasterVideoMute) {
                                      setState(() {
                                        isCameraShown = !isCameraShown;
                                      });
                                      _rtcEngine!.muteLocalVideoStream(isCameraShown);
                                      FirestoreServices.joinUserStream(
                                          widget.channelName??"",
                                          isCameraShown,
                                          viewer.uid??"");
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Sorry! You can't unmute video to yourself now");
                                    }
                                  },
                                  icon: Icon(
                                    isCameraShown || broadcasterVideoMute
                                        ? Icons.videocam_off_rounded
                                        : Icons.video_call,
                                    color: Colors.white,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    _onCallEnd(context);
                                  },
                                  icon: Icon(
                                    Icons.call_end,
                                    color: Colors.red.shade900,
                                  )),
                            ],
                          ),
                        ))
                  ],
                ),
              )
            : userAgora != 10010
                ? Padding(
                    padding:
                        EdgeInsets.only(bottom: _users.length == 1 ? 5.0 : 5.0),
                    child: GestureDetector(
                      onTap: () {
                        openProfile(viewer.uid??"");
                      },
                      child: Container(
                        height: 130,
                        width: 130,
                        child: viewer.isCamera!
                            ? RtcRemoteView.SurfaceView(uid: userAgora)
                            : viewer != null
                                ? Image.network(
                                    viewer.photoUrl??"",
                                    width: 130,
                                    height: 130,
                                  )
                                : Image.asset('images/profile.png',
                                    height: 130, width: 130, fit: BoxFit.cover),
                      ),
                    ),
                  )
                : Container(),
      ],
    );
  }

  void _setVideoBeauti(int j) {
    if (j == 0) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled: true,
      options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastLow,
              lighteningLevel: 0.0,
              smoothnessLevel: 0.0,
              rednessLevel: 0.0),
 );
    } else if (j == 1) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:true,
          options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastLow,
              lighteningLevel: 0.0,
              smoothnessLevel: 0.9,
              rednessLevel: 1.0));
    } else if (j == 2) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:true,
          options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastNormal,
              lighteningLevel: 0.5,
              smoothnessLevel: 0.5,
              rednessLevel: 0.5));
    } else if (j == 3) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:true,
          options: BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastNormal,
              lighteningLevel: 0.0,
              smoothnessLevel: 0.7,
              rednessLevel: 1.0));
    } else if (j == 4) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:true,
          options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastHigh,
              lighteningLevel: 0.1,
              smoothnessLevel: 0.1,
              rednessLevel: 0.1));
    } else if (j == 5) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:true,
          options: BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastHigh,
              lighteningLevel: 0.3,
              smoothnessLevel: 0.3,
              rednessLevel: 0.3));
    } else if (j == 6) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:true,
          options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastHigh,
              lighteningLevel: 0.5,
              smoothnessLevel: 0.5,
              rednessLevel: 0.5));
    } else if (j == 7) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:true,
          options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastHigh,
              lighteningLevel: 0.7,
              smoothnessLevel: 0.7,
              rednessLevel: 0.7));
    } else if (j == 8) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled: true,
          options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastHigh,
              lighteningLevel: 1.0,
              smoothnessLevel: 0.0,
              rednessLevel: 0.0));
    } else if (j == 9) {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:true,
          options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastHigh,
              lighteningLevel: 1.0,
              smoothnessLevel: 1.0,
              rednessLevel: 1.0));
    } else {
      _rtcEngine!.setBeautyEffectOptions(
          enabled:false,
          options:BeautyOptions(
              lighteningContrastLevel: LighteningContrastLevel.lighteningContrastNormal,
              lighteningLevel: 1.0,
              smoothnessLevel: 1.0,
              rednessLevel: 1.0));
    }
    
  }

  int beautyItem = -1;

   viewBeauty() {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        isScrollControlled: true,
        isDismissible: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: .1,
              minChildSize: .1,
              maxChildSize: .1,
              builder: (context, scrollController) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, index) {
                    BeautyModel model = beautyList[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: beautyItem == index
                                    ? Colors.red.shade900
                                    : Colors.transparent,
                                width: 2)),
                        child: GestureDetector(
                          onTap: () {
                            _setVideoBeauti(index);
                            setState(() {
                              beautyItem = index;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              model._imagePath,
                              fit: BoxFit.cover,
                              height: 60.0,
                              width: 60.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: beautyList.length,
                );
              },
            );
          });
        });
  }

  Future<void> openProfile(String userId) async {
    String status = "";
    FollowModel? model = await UserFollowService().checkFollowStatus(userId);
    FollowModel? model1 = await UserFollowService().checkFriendStatus(userId);
    if (model!.data!.following! && model1!.data!.following!) {
      status = "Friend";
    } else if (!model.data!.following! && !model1!.data!.following!) {
      status = "Follow";
    } else if (model.data!.following! && !model1!.data!.following!) {
      status = "Following";
    } else if (!model.data!.following! && model1!.data!.following!) {
      status = "Follow back";
    }

    CurrentUserModel? userModel = await ProfileUpdateServices().getUserProfile(userId);
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return UserProfileDailog(
          userModel: userModel,
          status: status,
          broadcaster: widget.broadcaster,
          channelName: widget.channelName,
        );
      },
    );
  }
}

class BeautyModel {
  String _imagePath;

  get imagePath => _imagePath;

  set imagePath(value) {
    _imagePath = value;
  }

  BeautyModel(this._imagePath);
}

List join = [];

class AudioVideoJoin extends StatefulWidget {
  final String? channelName;
  final Function? onStartListen;
  CurrentUserModel? user;

  AudioVideoJoin({this.user, this.channelName, this.onStartListen});

  @override
  _AudioVideoJoinState createState() => _AudioVideoJoinState();
}

class _AudioVideoJoinState extends State<AudioVideoJoin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(color: Colors.red))),
              backgroundColor: MaterialStatePropertyAll(Colors.white)
            ),
            onPressed: () async {
              await FirestoreServices.joinVideo(1, widget.channelName??"");
              widget.onStartListen!();
              Navigator.pop(context);
            },

            child: Row(
              children: [
                Icon(
                  Icons.mic_none_outlined,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "Audio Join",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
          !join.contains(widget.user?.userId)
              ? ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)))
            ),
                  onPressed: () async {
                    await FirestoreServices.joinVideo(2, widget.channelName??"");
                    widget.onStartListen!();
                    Navigator.pop(context);
                    if (join.isNotEmpty) {
                      join.clear();
                      join.add(widget.user?.userId);
                    } else {
                      join.add(widget.user?.userId);
                    }
                    setState(() {});
                  },

                  child: Row(
                    children: [
                      Icon(
                        Icons.videocam,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Video Join",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.white),
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

getJoinUser(ViewerModel viewers, CurrentUserModel user) async {
  print(' USer id  = ${viewers.uid}');
  print(' USer id  = ${user.userId}');
  bool? i = viewers.uid?.contains(user.userId!);
  return i;
}


class VideoWaitList extends StatefulWidget {
  final String? channelName;
  CurrentUserModel?user;
  final bool? broadcaster;

  VideoWaitList({this.channelName, this.broadcaster, this.user});

  @override
  _VideoWaitListState createState() => _VideoWaitListState();
}

class _VideoWaitListState extends State<VideoWaitList> {
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
      builder: (context,AsyncSnapshot<dynamic>snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        List<ViewerModel> viewers = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                children: [
                  Text(
                    "Waiting List (${snapshot.data.length})",
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
                        ViewerModel viewer = viewers[i];
                        print("viewers listt ${viewers[i]}");

                        return ListTile(
                          leading: viewer.photoUrl != null
                              ? CircleAvatar(
                                  radius: 25.r,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: HexagonProfilePicNetworkImage(
                                        url: viewer.photoUrl,
                                      )),
                                )
                              : InitIconContainer(
                                  radius: 40,
                                  text: viewer.name,
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
                                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)))
                                    ),
                                    onPressed: () async {
                                      if (guestLive < 2) {
                                        FirestoreServices.addUserToVideoLive(
                                            viewer?.status??0,
                                            widget.channelName??"",
                                            viewer.uid??"");
                                        isUserJoin = await getJoinUser(viewer, widget.user!);
                                        // setState(() {});
                                        print('is User joined ===${viewer.uid}');
                                        print('is User joined ===${widget.user?.userId}');
                                        Navigator.pop(context);
                                      } else {
                                        Fluttertoast.showToast(msg: "Sorry! Maximum 2 Guest are Allow.");
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

class ElapsedTime {
  final int? hundreds;
  final int? seconds;
  final int? minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle = const TextStyle(
    fontSize: 17.0,
  );
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});

  final Dependencies? dependencies;

  TimerTextState createState() =>
      new TimerTextState(dependencies: dependencies??Dependencies());
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});

  final Dependencies? dependencies;
  Timer? timer;
  int? milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies?.timerMillisecondsRefreshRate??0),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies!.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies!.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds! / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies!.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RepaintBoundary(
          child: SizedBox(
            height: 20.0,
            child: MinutesAndSeconds(dependencies: dependencies),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});

  final Dependencies? dependencies;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies??Dependencies());
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});

  final Dependencies? dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies!.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes!;
        seconds = elapsed.seconds!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return Text('$minutesStr:$secondsStr', style: dependencies?.textStyle);
  }
}
