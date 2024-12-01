import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart' as badge;
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_file_manager/flutter_file_manager.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock/wakelock.dart';
import '../../../models/chat_model.dart';
import '../../../models/current_user_model.dart';
import '../../../models/emojiModel.dart';
import '../../../models/followmodel.dart';
import '../../../models/live_model.dart';
import '../../../models/roomskin_model.dart';
import '../../../models/user.dart';
import '../../../models/viewer_model.dart';
import '../../../services/emoji_service.dart';
import '../../../services/firestore_services.dart';
import '../../../services/profile_update_services.dart';
import '../../../services/roomTheame/roomskin_service.dart';
import '../../../services/timer_services.dart';
import '../../../services/token_manager_services.dart';
import '../../../services/userfollowservice.dart';
import '../../../utils/utility.dart';
import '../../profile/user_profile_dailog.dart';
import '../../shared/bottom_scrollsheet_message.dart';
import '../../shared/initIcon_container.dart';
import '../../shared/loading.dart';
import '../../shared/network_image.dart';
import '../../withAuth/go_live/live_header.dart';
import '../../withAuth/profile/caller_profile.dart';
import '../../withAuth/profile/viewprofile_model.dart';
import '../all_viewer_modal.dart';
import '../close_live_bottom_modal.dart';
import '../utils/settings.dart';
import 'GuestList.dart';
import 'audio_file.dart';
import 'audio_waitList.dart';
import 'gift_model.dart';
import 'package:native_video_view/native_video_view.dart' as native;
// import 'package:socket_io_client/socket_io_client.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

class AudioLiveNew extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String? channelName;
  final LiveModel? broadcastUser;
  final bool? broadcaster;
  final String? msgText;

  const AudioLiveNew({Key? key,
    this.channelName,
    this.msgText,
    this.broadcaster = false,
    this.broadcastUser})
      : super(key: key);

  @override
  _AudioLiveNewState createState() => _AudioLiveNewState();
}

class _AudioLiveNewState extends State<AudioLiveNew> with WidgetsBindingObserver{
  final _users = <int>[];
  int roomskinimageIndex = 0;
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine? _engine;
  Timer? timer;

  TextEditingController _comment = TextEditingController();
  CurrentUserModel? user;

  StreamSubscription? _stream;
  StreamSubscription? _viewerStream;
  bool guest = false;
  bool broadcasterLeft = false;

  int existingLive = 0;
  TimerServices timerServices = TimerServices();

  bool loading = true;

  int requester = 0;
  String giftTime = "";
  bool refreshBaens = false;
  // IO.Socket socket;

  // socketConnection() {
  //   socket = IO.io(SOCKET_URL,
  //       OptionBuilder()
  //           .setTransports(['websocket'])
  //           .setTimeout(5000)
  //           .build());
  //   socket.connect();
  //   socket.onConnect((_) {
  //     if(widget.broadcaster){
  //       print('Socket Connected');
  //       print("SendingUserId");
  //       Map body = {
  //         "roomId": widget.channelName,
  //         "user_id": "345",
  //         "user_type": "broadcaster",
  //         "broadcastType": "audio",
  //       };
  //       socket.emit(STARTBROADCASTING,body);
  //     }
  //   });
  //
  //   socket.on(ROOMUSERS, (data) {
  //     print("ROOMUSERS ${data.toString()}");
  //   });
  //
  //   socket.on(GETMESSAGE, (data) {
  //     final Map<String, dynamic> data1 = Map.from(data);
  //     print("GETMESSAGE ${data1.toString()}");
  //   });
  //
  //   // socket.on('event', (data) => print(data));
  //   socket.onDisconnect((_) {
  //     print('Socket Disconnect');
  //   });
  //
  //   socket.onConnectError((data) {
  //     print('Socket onConnectError ${data.toString()}');
  //   });
  //
  //   // socket.on('fromServer', (_) => print(_));
  // }


  @override
  void dispose() {
    // socket.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    timer?.cancel();
    FirestoreServices.insertNewComment(widget.channelName??"", "Left");

    _users.clear();
    _engine!.leaveChannel();
    _engine=null;
    _comment.dispose();
    if (_stream != null) {
      _stream!.cancel();
    }
    if (_viewerStream != null) {
      _viewerStream!.cancel();
    }
    timerServices.close();
    // disposeLive();
  }

  disposeLive() async {
    if (widget.broadcaster!) {
      print("video dispose");
      await FirestoreServices.onWillPop(widget.channelName??"");
    } else {
      await FirestoreServices.onGuestLeave(widget.channelName??"");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("ChangeApp -- $state");
    if (state == AppLifecycleState.inactive) {
      pipmod();
    }
  }

  static const platform = const MethodChannel('flutter.rortega.com.channel');

  Future<void> pipmod() async {
    await platform.invokeMethod('showNativeView');
  }

  @override
  void initState() {
    // GiftService();

    // socketConnection();
    getFiles();
    WidgetsBinding.instance.addObserver(this);

    // initialize agora sdk
    initialize();
    // initializeViewerStream();
    // userJoin();
    timer = Timer.periodic(Duration(minutes: 2), (Timer t) => Utility().getLoginStatus(context));

    super.initState();
  }

  userJoin() async {
    if (!widget.broadcaster!) {
      FirestoreServices.newUserJoined(widget.channelName??"");
      FirestoreServices.insertNewComment(widget.channelName??"", "Joined");
      // onStartListen();
    }
  }

  List<Tab> giftTabs = [];
  bool isLoad = false;
  String hostid = '';
  ViewerModel? viewer;

  initializeViewerStream() async {
    _viewerStream = await FirebaseFirestore.instance
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

  Future<void> initialize() async {
    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId, true);
    RoomskinService().Roomscreen(userId: user?.userId);
    setState(() {
      loading = false;
    });
    _initialPermissionsAndInitialization();
    _initAgoraRtcEngine();

    if (widget.broadcaster!) {
      // initializeForBroadcaster();
      timerServices.startTimer();
    } else {
      // initializeForOthers();
      _engine?.muteLocalAudioStream(true);
    }
  }

  Future<void> _handlePermissions(Permission permission) async {
    final status = await permission.request();
    print(status);
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
    // await _localRenderer.initialize();
    // await _remoteRenderer.initialize();
  }

  // Future<void> initializeForBroadcaster() async {
  //   _engine = await RtcEngine.create(APP_ID);
  //   await _engine?.enableAudio();
  //   await _engine?.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
  //
  //   await _engine?.setClientRole(ClientRole.Broadcaster);
  //
  //   _addAgoraEventHandlers();
  //   await _engine?.enableWebSdkInteroperability(true);
  //   VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
  //   configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
  //   await _engine?.setVideoEncoderConfiguration(configuration);
  //
  //   if (widget.broadcaster!) {
  //     await _engine?.joinChannel( token:Token,channelId:widget.channelName??"", options:ChannelMediaOptions(),uid:10010);
  //     print("${_engine.hashCode}");
  //   } else {
  //     // await _engine.joinChannel(Token, widget.channelName, null, 0);
  //   }
  // }
  Future<void> initializeForBroadcaster() async {
    // Create the engine
    _engine = await createAgoraRtcEngine();

    // Initialize with the app ID
    await _engine?.initialize(RtcEngineContext(appId: APP_ID));

    // Enable audio
    await _engine?.enableAudio();

    // Set the channel profile
    await _engine?.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);

    // Set the client role
    await _engine?.setClientRole(role:ClientRoleType.clientRoleBroadcaster);

    // Add event handlers (if you have a method for this)
    _addAgoraEventHandlers();

    // Enable Web SDK interoperability
    await _engine?.enableWebSdkInteroperability(true);

    // Set the video encoder configuration
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration(
      dimensions: VideoDimensions( width:1920,height:1080),
    );
    await _engine?.setVideoEncoderConfiguration(configuration);

    // Join the channel as broadcaster
    if (widget.broadcaster!) {
      await _engine?.joinChannel(token:Token,channelId:widget.channelName ?? "", uid:10010, options: ChannelMediaOptions(),);
      print("${_engine.hashCode}");
    } else {
      // You can handle joining as an audience here if needed
    }
  }
  Future<void> _initAgoraRtcEngine() async {
    String APP_ID = await TokenManagerServices().getAgoraAppId();
    _engine = await createAgoraRtcEngine();
    _engine!.initialize(RtcEngineContext(appId:APP_ID));

    await _engine?.enableAudio();
    if (widget.broadcaster!) {
      await _engine?.enableLocalAudio(true);
    } else {
      await _engine?.enableLocalAudio(false);
    }
    await _engine?.enableLocalVideo(false);

    await _engine
        ?.enableVideo()
        .then((value) => print("video has ben enabled!!"));
    await _engine?.setChannelProfile(ChannelProfileType.channelProfileCommunication);

    _addAgoraEventHandlers();
    await _engine?.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // configuration.dimensions = VideoDimensions(1920, 1080);
    print('channel name ${widget.channelName}');
    await _engine?.setVideoEncoderConfiguration(configuration);
    // await _engine.setClientRole(ClientRole.Broadcaster);
    if (widget.broadcaster!) {
      await _engine?.joinChannel(token:  Token,channelId:  widget.channelName??"", options: ChannelMediaOptions(),uid: 10010);
    } else {
      await _engine?.joinChannel(token:  Token,channelId:  widget.channelName??"", options: ChannelMediaOptions(),uid: 0);
    }
  }

  // Future<void> initializeForOthers() async {
  //   _engine = await RtcEngine.create(APP_ID);
  //   await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
  //   await _engine?.setClientRole(ClientRole.Audience);
  //   await _engine?.enableAudio();
  //   _addAgoraEventHandlers();
  //   await _engine?.joinChannel(Token, widget.channelName??"", null, 0);
  // }
  Future<void> initializeForOthers() async {
    // Create the Agora engine instance
    _engine = await createAgoraRtcEngine();

    // Initialize the engine with the app ID
    await _engine?.initialize(RtcEngineContext(appId: APP_ID));

    // Set the channel profile to live broadcasting
    await _engine?.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);

    // Set the client role to Audience
    await _engine?.setClientRole(role:ClientRoleType.clientRoleAudience);

    // Enable audio
    await _engine?.enableAudio();

    // Add event handlers for Agora events
    _addAgoraEventHandlers();

    // Join the channel as an audience
    await _engine?.joinChannel(token:Token, channelId:widget.channelName ?? "", uid:0, options: ChannelMediaOptions(),);
  }

  Map<int, User> _userMap = new Map<int, User>();
  int? _localUid;

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine?.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        setState(() {
          final info = 'onError: $msg';
          _infoStrings.add(info);
        });
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print(connection.channelId);
        setState(() {
          _localUid = connection.localUid;
          print("joinChannelSuccess: $connection, uid: ${connection.channelId}");
          final info = 'onJoinChannel: $connection, uid: ${connection.channelId}';
          _infoStrings.add(info);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        setState(() {
          final info = 'userJoined: ${remoteUid}';
          _infoStrings.add(info);
          _users.add(int.parse(connection.channelId!));
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        setState(() {
          final info = 'userOffline: ${connection.channelId}';
          if (int.parse(connection.channelId!) == 10010) {
            setState(() {
              broadcasterLeft = true;
              _infoStrings.add(info);
              _users.remove(connection.channelId);
            });
          }
        });
      },
      onFirstRemoteVideoFrame: (RtcConnection connection, int remoteUid, int width,
          int height, int elapsed) {
        setState(() {
          final info = 'firstRemoteVideo: ${connection.channelId} ${width}x $height';
          _infoStrings.add(info);
        });
      },
      onAudioVolumeIndication: (RtcConnection connection, List<AudioVolumeInfo> speakers,
          int speakerNumber, int totalVolume) {
        speakers.forEach((speaker) {
          //detecting speaking person whose volume more than 5
          if (speaker.volume! > 5) {
            try {
              _userMap.forEach((key, value) {
                if ((_localUid?.compareTo(key) == 0) && (speaker.uid == 0)) {
                  setState(() {
                    _userMap.update(key, (value) => User(key, true));
                  });
                }

                //Highlighting remote user
                else if (key.compareTo(speaker.uid!) == 0) {
                  setState(() {
                    _userMap.update(key, (value) => User(key, true));
                  });
                } else {
                  setState(() {
                    _userMap.update(key, (value) => User(key, false));
                  });
                }
              });
            } catch (error) {
              print('Error:${error.toString()}');
            }
          }
        });
      },
    ));
  }

  Widget getBroadcasterView(ismute) {
    Widget bUser;

    if (widget.broadcaster!) {
      bUser = Container(
        padding: EdgeInsets.only(top: 70.sp, left: 20.sp, right: 20.sp),
        child: Column(
          children: [
            user?.image != null
                ? CircleAvatar(
              child: CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: MediaQuery
                      .of(context)
                      .size
                      .width * .12,
                  backgroundImage: user?.image != null
                      ? CachedNetworkImageProvider(user?.image??"")
                      : Image.asset("images/profile.png") as ImageProvider),
              backgroundColor: Colors.black12,
              radius: MediaQuery
                  .of(context)
                  .size
                  .width * .15,
            )
                : InitIconContainer(
              radius: MediaQuery
                  .of(context)
                  .size
                  .width * .26,
              text: user?.name??"",
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0x66000000),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        ismute ? Icons.mic_off_rounded : Icons.volume_up,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "${user?.name}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: "'s Stream",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.white),
                              )
                            ]),
                      )
                    ],
                  )),
            )
          ],
        ),
      );
    } else {
      bUser = Container(
        padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .size
              .height * .11,
          left: 20,
          right: 20,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.broadcastUser?.photoUrl != null
                ? CircleAvatar(
                backgroundColor: Colors.black12,
                radius: MediaQuery
                    .of(context)
                    .size
                    .width * .13.w,
                backgroundImage: CachedNetworkImageProvider(
                    widget.broadcastUser?.photoUrl??""))
                : InitIconContainer(
              radius: MediaQuery
                  .of(context)
                  .size
                  .width * .26.w,
              text: widget.broadcastUser?.name??"",
            ),
            Padding(
              padding: EdgeInsets.all(14.0.h.w),
              child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w.h, vertical: 4.h.w),
                  decoration: BoxDecoration(
                    color: Color(0x66000000),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.volume_up_sharp,
                        color: Colors.white,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "",
                            style:
                            TextStyle(fontSize: 14.sp, color: Colors.white),
                            children: [
                              TextSpan(
                                text: "${widget.broadcastUser?.name}",
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: "'s Stream",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.white),
                              )
                            ]),
                      )
                    ],
                  )),
            )
          ],
        ),
      );
    }

    return bUser;
  }

  List<int> generateNumbers() => List<int>.generate(8, (i) => i + 1);

  List<Widget> list = [];
  List<ViewerModel> listViewer = [];

  Widget _viewRows(ismute) {
    print("chaneel name ==${widget.channelName}");
    listViewer.clear();
    return Container(
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('live_streams')
                .doc(widget.channelName)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                return Container(
                  padding:
                  EdgeInsets.only(top: 70.sp, left: 20.sp, right: 20.sp),
                  child: Column(
                    children: [
                      snapshot.data!.get("photoUrl") != ""
                          ? CircleAvatar(
                        child: CircleAvatar(
                            backgroundColor: Colors.black12,
                            radius:
                            MediaQuery
                                .of(context)
                                .size
                                .width * .12,
                            backgroundImage:
                            snapshot.data?.get("photoUrl") != ""
                                ? CachedNetworkImageProvider(
                                snapshot.data!.get("photoUrl"))
                                : Image.asset("images/profile.png") as ImageProvider),
                        backgroundColor: Colors.black12,
                        radius: MediaQuery
                            .of(context)
                            .size
                            .width * .15,
                      )
                          : InitIconContainer(
                        radius: MediaQuery
                            .of(context)
                            .size
                            .width * .26,
                        text: snapshot.data!.get("name"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0x66000000),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  snapshot.data!.get('isMute')
                                      ? Icons.mic_off_rounded
                                      : Icons.volume_up,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: "${snapshot.data!.get("name")}",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(
                                          text: "'s Stream",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.white),
                                        )
                                      ]),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                  child: SizedBox(
                    height: 200,
                  ),
                );
              }
            },
          ),
          StreamBuilder(
            stream: FirestoreServices().getUserSeatList(widget.channelName??""),
            builder: (context, snapshot) {
              listViewer.clear();
              emojiViewers.clear();
              if (snapshot.hasData) {
                List<ViewerModel> viewers = snapshot.data as List<ViewerModel>;
                for (var i = 0; i < 8; i++) {
                  listViewer.add(ViewerModel(name: "0", seatno: i));
                }
                if (viewers.length != 0) {
                  for (var i = 0; i < viewers.length; i++) {
                    viewer = viewers[i];
                    if (viewers[i].uid == user?.userId) {
                      onNewUserMuteListen(viewers[i].isMute!, viewers[i].uid!);
                    }
                    emojiViewers.add(SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 4,
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Column(
                          children: [
                            viewer?.photoUrl != null
                                ? ClipRRect(
                              child: Image.network(
                                viewer!.photoUrl!,
                                height: 25,
                                width: 25,
                              ),
                              borderRadius: BorderRadius.circular(40.r),
                            )
                                : InitIconContainer(
                              radius: 10,
                              text: viewer?.name??"",
                            ),
                          ],
                        ),
                      ),
                    ));
                    for (var j = 0; j < listViewer.length; j++) {
                      if (listViewer[j].seatno == viewers[i].seatno) {
                        listViewer.removeAt(j);
                        listViewer.insert(j, viewers[i]);
                      }
                    }
                  }
                }

                return GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  childAspectRatio: 1.1,
                  children: listViewer.map((e) {
                    return Container(
                      child: Column(
                        children: [
                          e.name == "0"
                              ? CircleAvatar(
                            radius:
                            MediaQuery
                                .of(context)
                                .size
                                .width * .06,
                            backgroundColor: Colors.black38,
                            child: Center(
                              child: Container(
                                height: 25,
                                width: 25,
                                child: Image.asset(
                                  "images/chair2.png",
                                ),
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () async {
                              bool brodcaster = false;
                              if (widget.broadcaster! ||
                                  user!.userId != e.uid) {
                                brodcaster = true;
                              }
                              CurrentUserModel? userModel =
                              await ProfileUpdateServices()
                                  .getUserProfile(e.uid);
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return CallerProfile(
                                      userId: userModel?.userId??"",
                                      image: userModel?.image??"",
                                      name: userModel?.name??"",
                                      bio: userModel?.bio??"",
                                      countryName: userModel?.countryName??"",
                                      gender: userModel?.gender??"",
                                      uniqueId: userModel?.uniqueId??"",
                                      coverphoto: userModel!.coverPhotos![1].image!,
                                      isBrodcaster: brodcaster,
                                      muted: e.isMute!,
                                      channelName: widget.channelName??"",
                                      viewerModel: e,
                                      broadcastUser: widget.broadcastUser!,
                                      broadcaster_mute:
                                      e.broadcaster_mute!,
                                      userModel: userModel,
                                      callEnd: () async {
                                        _engine!.leaveChannel();
                                        _initAgoraRtcEngine();
                                        // await _engine.setChannelProfile(ChannelProfile.Communication);
                                        // await _engine.setClientRole(ClientRole.Audience);
                                      },
                                    );
                                  });
                              //do what you want here
                            },
                            child: Container(
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  CircleAvatar(
                                    radius: MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        .06,
                                    backgroundImage:
                                    NetworkImage(e.photoUrl!),
                                  ),
                                  e.isMute!
                                      ? Icon(
                                    Icons.mic_off,
                                    color: Colors.red.shade900,
                                    size: 32,
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            e.name == "0" ? (e.seatno! + 1).toString():e.name.toString(),
                            // (e!.seatno + 1).toString() : e.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            textScaleFactor:
                            MediaQuery
                                .of(context)
                                .textScaleFactor,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                background: Paint()
                                  ..strokeWidth = 17
                                  ..color = Colors.black12),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else {
                for (var i = 0; i < 8; i++) {
                  listViewer.add(ViewerModel(name: "0", seatno: i));
                }
                return GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  childAspectRatio: 1.3,
                  children: listViewer.map((e) {
                    return Container(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: MediaQuery
                                .of(context)
                                .size
                                .width * .06,
                            backgroundColor: Colors.black26,
                            child: Center(
                              child: Container(
                                height: 25,
                                width: 25,
                                child: Image.asset(
                                  "images/chair2.png",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            (e.seatno! + 1).toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                background: Paint()
                                  ..strokeWidth = 17
                                  ..color = Colors.black12),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  int? index;

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
              List<ChatModel> chats = snapshot.data as List<ChatModel>;
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
                                            userId: user?.userId??"",
                                            image: user?.image??"",
                                            name: user?.name??"",
                                            bio: user?.bio??"",
                                            countryName: user?.countryName??"",
                                            gender: user?.gender??"",
                                            uniqueId: user?.uniqueId??"",
                                            coverphoto: user!.coverPhotos?[1].image,
                                            userModel: user,
                                            isBrodcaster: true,
                                            channelName:
                                            widget.channelName,
                                          );
                                        });
                                  }
                                  String status = "";
                                  FollowModel? model =
                                  await UserFollowService().checkFollowStatus(chat.userId!);
                                  FollowModel? model1 = await UserFollowService().checkFriendStatus(chat.userId!);
                                  if (model!.data!.following! &&
                                      model1!.data!.following!) {
                                    status = "Friend";
                                  } else if (!model!.data!.following! &&
                                      !model1!.data!.following!) {
                                    status = "Follow";
                                  } else if (model!.data!.following! &&
                                      !model1!.data!.following!) {
                                    status = "Following";
                                  } else if (!model!.data!.following! &&
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
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        0.14,
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft,
                                          colors: [
                                            Color(int.parse(
                                                "${chat.rlColorCode!.replaceFirst(
                                                    "#", "0xff")}")),
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
                                              if (user!.userId ==
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
                                                        userId: user!.userId,
                                                        image: user!.image,
                                                        name: user!.name,
                                                        bio: user!.bio,
                                                        countryName: user
                                                            !.countryName,
                                                        gender: user!.gender,
                                                        uniqueId:
                                                        user!.uniqueId,
                                                        coverphoto: user
                                                            !.coverPhotos![1]
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
                                              } else if (!model!.data!.following! &&
                                                  !model1!.data!.following!) {
                                                status = "Follow";
                                              } else if (model!.data!.following! &&
                                                  !model1!.data!.following!) {
                                                status = "Following";
                                              } else if (!model!.data!.following! && model1!.data!.following!) {
                                                status = "Follow back";
                                              }

                                              CurrentUserModel? userModel = await ProfileUpdateServices().getUserProfile(chat.userId);
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
                                      chat.name!.contains('null')
                                          ? TextSpan(
                                          text: '${chat.message}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14))
                                          : TextSpan(
                                          text: '${chat.message}',
                                          style: TextStyle(
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
                                chat.giftUrl??"",
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

  List roomSkinImages = [];
  bool changeBackground = false;

  void call_end() async {
    _stream = await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(widget.channelName)
        .collection("viewers")
        .where('status', whereIn: [3, 4])
        .snapshots()
        .listen((QuerySnapshot q) {
      if (q.docs.length > 0) {
        q.docs.forEach((d) async {
          if (user!.userId == d.id) {
            guest = true;
            _engine!.leaveChannel();
            if (widget.broadcaster!) {
              // initializeForBroadcaster();
            }
          }
        });
      }
    });
  }

  /*New User Join Seat*/
  void onNewUserMuteListen(bool isMute, String uid) async {
    // await _engine.setChannelProfile(ChannelProfile.Communication);
    // await _engine.setClientRole(ClientRole.Broadcaster);
    print("Current User Mute --> $isMute");
    await _engine!.enableAudioVolumeIndication(interval:  250,smooth:  3,reportVad:true);
    await _engine!.enableLocalAudio(true);
    _engine!.muteLocalAudioStream(isMute);
  }

  bool ismute = false;
  final player = AudioCache(prefix: '');
  List<Widget> emojiViewers = [];
  bool isJoin = false;
  int? ind;

  getBackgroundUrl() async {
    var collection = FirebaseFirestore.instance
        .collection('live_streams')
        .doc(widget.channelName)
        .collection("broadcaster_view")
        .doc(widget.channelName);
    var docSnapshot = await collection.get();
    Map<String, dynamic>? data = docSnapshot.data();
    print("Screen background ----- ${data!['background_url']}");
    if (data.isNotEmpty && data['background_url'] != roomSkinImages[0]) {
      setState(() {
        roomSkinImages.clear();
        roomSkinImages.add(data['background_url']);
        changeBackground = true;
      });
    }
  }

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
                      'AudioPage Gifts--- ${snapshot.data!.get('time')
                          .toString()}');
                  print(
                      'AudioPage Gifts--- ${snapshot.data!.get('gifturl')
                          .toString()}');
                  if (snapshot.data!.get('time') == giftTime) {
                    print("get Gift Time --$giftTime");
                    return Container();
                  } else {
                    giftTime = snapshot.data!.get('time');

                    if (snapshot.data
                        !.get('gifturl')
                        .toString()
                        .isNotEmpty &&
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
                        ? snapshot.data
                        !.get('gifturl')
                        .toString()
                        .isNotEmpty
                        ? Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                                height: 400,
                                width: 400,
                                alignment: Alignment.center,
                                child: NativeVideoView(
                                  keepAspectRatio: true,
                                  showMediaController: false,
                                  enableVolumeControl: false,
                                  onCreated: (controller) {
                                    controller.setVideoSource(
                                      snapshot.data
                                          !.get('gifturl'),
                                      sourceType:native.VideoSourceType.network,
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
              .doc(user!.userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              if (user!.userId == snapshot.data!.get("uid")) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Spacer(),
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 4,
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
                                            .doc(user!.userId)
                                            .delete();
                                        bool seat = false;
                                        for (var j = 0;
                                        j < listViewer.length;
                                        j++) {
                                          if (!seat &&
                                              listViewer[j].name == "0") {
                                            seat = true;
                                            FirestoreServices
                                                .callInvitionAccept(user?.userId??"",
                                                widget.channelName??"", j);
                                            setState(() {
                                              isJoin = !isJoin;
                                            });
                                          }
                                        }
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
                                            isEqualTo: user?.userId??"")
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

    getBackView() {
      return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('live_streams')
              .doc(widget.channelName)
              .collection("broadcaster_view")
              .doc(widget.channelName)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.exists &&
                snapshot.data!['background_url'] != roomSkinImages[0]) {
              Future.delayed(const Duration(seconds: 1), () async {
                setState(() {
                  roomSkinImages.clear();
                  roomSkinImages.add(snapshot.data!['background_url']);
                  changeBackground = true;
                });
              });
              return Container();
            } else {
              return Container();
            }
          });
    }

    if (viewer != null) {
      // _engine.muteLocalAudioStream(viewer.isMute);
    }
    return WillPopScope(
      onWillPop: () async {
        if (widget.broadcaster!) {
          int seconds = timerServices.getCurrentTime();
          closeLiveModal(context, widget.channelName??"", seconds, "audio");
          return false;
        } else {
          return true;
        }
      },
      child: Container(
        child: loading
            ? Loading()
            : FutureBuilder<Roomskinmodel>(
          future: RoomskinService().Roomscreen(
            userId: user!.userId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              roomSkinImages.add(snapshot.data!.data![0].image);
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: changeBackground
                            ? NetworkImage(roomSkinImages[0])
                            : roomSkinImages != null
                            ? NetworkImage(roomSkinImages[0])
                            : AssetImage(
                            "images/audioCallwating.jpeg") as ImageProvider,
                        fit: BoxFit.cover)),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    child: loading
                        ? Loading()
                        : Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xA8000000)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [.5, 1])),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: _panel(),
                                  ),
                                ),
                                Container(
                                  color: Colors.transparent,
                                  child: widget.broadcaster!
                                      ? Row(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                onPressed:
                                                    () {
                                                  openModalBottomSheetForMessage(
                                                      context, widget.channelName??"", _comment);
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .message_outlined,
                                                  color: Colors
                                                      .white,
                                                )),
                                            IconButton(
                                                onPressed:
                                                    () {
                                                  showModalBottomSheet(
                                                      context:
                                                      context,
                                                      elevation:
                                                      0,
                                                      isScrollControlled:
                                                      true,
                                                      barrierColor:
                                                      Colors
                                                          .transparent,
                                                      isDismissible:
                                                      true,
                                                      backgroundColor:
                                                      Colors
                                                          .transparent,
                                                      builder:
                                                          (context) {
                                                        return StatefulBuilder(
                                                            builder:
                                                                (context,
                                                                state) {
                                                              return DraggableScrollableSheet(
                                                                expand: false,
                                                                initialChildSize: .17,
                                                                minChildSize: .17,
                                                                maxChildSize: .17,
                                                                builder: (
                                                                    context,
                                                                    scrollController) {
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .black87,
                                                                        borderRadius: BorderRadius
                                                                            .only(
                                                                            topLeft: Radius
                                                                                .circular(
                                                                                30
                                                                                    .r),
                                                                            topRight: Radius
                                                                                .circular(
                                                                                30
                                                                                    .r))),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        SingleChildScrollView(
                                                                          scrollDirection: Axis
                                                                              .horizontal,
                                                                          child: Row(
                                                                            children: emojiViewers,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child: FutureBuilder<
                                                                                EmojiModel>(
                                                                              future: EmojiService().getEmoji().then((value) => value?? EmojiModel()),
                                                                              builder: (
                                                                                  context,
                                                                                  snapshot) {
                                                                                if (snapshot
                                                                                    .hasData) {
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .all(
                                                                                        8.0),
                                                                                    child: Container(
                                                                                      child: GridView
                                                                                          .builder(
                                                                                        shrinkWrap: true,
                                                                                        itemCount: snapshot.data!.data!.length,
                                                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                            crossAxisCount: 1,
                                                                                            childAspectRatio: 2,
                                                                                            crossAxisSpacing: 15,
                                                                                            mainAxisSpacing: 15),
                                                                                        scrollDirection: Axis
                                                                                            .horizontal,
                                                                                        itemBuilder: (
                                                                                            BuildContext context,
                                                                                            int index) {
                                                                                          return GestureDetector(
                                                                                            // onTap: () async {
                                                                                            //   player.play(emoji['song'][index],
                                                                                            //   );
                                                                                            // },
                                                                                            // child: Image.asset(snapshot.data.data[index].file),
                                                                                              child: Image.network(snapshot.data!.data![index].file!));
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  return Container();
                                                                                }
                                                                              },
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            });
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .emoji_emotions_outlined,
                                                  color: Colors
                                                      .white,
                                                )),
                                            IconButton(
                                                onPressed:
                                                    () {
                                                  setState(
                                                          () {
                                                        ismute =
                                                        !ismute;
                                                      });
                                                  if (widget.broadcaster!) {
                                                    _engine!.muteLocalAudioStream(ismute);
                                                    FirestoreServices.onMute(widget.channelName??"", ismute);
                                                  }
                                                },
                                                icon: Icon(
                                                  ismute
                                                      ? Icons
                                                      .mic_off
                                                      : Icons
                                                      .mic_sharp,
                                                  color: Colors
                                                      .white,
                                                )),
                                            IconButton(
                                                onPressed:
                                                    () {
                                                  showModalBottomSheet(
                                                      context:
                                                      context,
                                                      isScrollControlled:
                                                      true,
                                                      isDismissible:
                                                      true,
                                                      backgroundColor:
                                                      Colors
                                                          .transparent,
                                                      builder:
                                                          (context) {
                                                        return StatefulBuilder(
                                                            builder:
                                                                (context,
                                                                state) {
                                                              return DraggableScrollableSheet(
                                                                  expand: false,
                                                                  initialChildSize: .2,
                                                                  minChildSize: .2,
                                                                  maxChildSize: .2,
                                                                  builder: (
                                                                      context,
                                                                      scrollController) {
                                                                    return Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius
                                                                              .only(
                                                                              topLeft: Radius
                                                                                  .circular(
                                                                                  30
                                                                                      .r),
                                                                              topRight: Radius
                                                                                  .circular(
                                                                                  30
                                                                                      .r))),
                                                                      child: Column(
                                                                        children: [
                                                                          ListTile(
                                                                            leading: Text(
                                                                              "Room Option",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .black,
                                                                                  fontSize: 18
                                                                                      .sp),
                                                                            ),
                                                                          ),
                                                                          Divider(
                                                                            color: Colors
                                                                                .black38,
                                                                            height: 1,
                                                                            endIndent: 30,
                                                                            indent: 30,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  ShowRoomSkin();
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets
                                                                                      .only(
                                                                                      left: 20
                                                                                          .h
                                                                                          .w,
                                                                                      top: 10
                                                                                          .h
                                                                                          .w,
                                                                                      right: 10
                                                                                          .h
                                                                                          .w),
                                                                                  child: Container(
                                                                                    height: 25
                                                                                        .h,
                                                                                    width: 25
                                                                                        .w,
                                                                                    child: Image
                                                                                        .asset(
                                                                                      "images/paint.png",
                                                                                      color: Colors
                                                                                          .red,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  showAudio();
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets
                                                                                      .only(
                                                                                      left: 20
                                                                                          .h
                                                                                          .w,
                                                                                      top: 10
                                                                                          .h
                                                                                          .w,
                                                                                      right: 10
                                                                                          .h
                                                                                          .w),
                                                                                  child: Container(
                                                                                    height: 25
                                                                                        .h,
                                                                                    width: 25
                                                                                        .w,
                                                                                    child: Image
                                                                                        .asset(
                                                                                      "images/headphones.png",
                                                                                      color: Colors
                                                                                          .red,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () async {
                                                                                  // final dynamicLinkParams = DynamicLinkParameters(
                                                                                  //   link: Uri.parse("https://www.example.com/"),
                                                                                  //   uriPrefix: "https://lovello.page.link",
                                                                                  //   androidParameters: const AndroidParameters(packageName: "com.example.app.android"),
                                                                                  //   iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
                                                                                  // );
                                                                                  // final dynamicLink =
                                                                                  // await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

                                                                                  List<
                                                                                      String> imagePaths = [
                                                                                  ];
                                                                                  imagePaths
                                                                                      .add(
                                                                                      "images/hdlive.jpg");

                                                                                  final box = context
                                                                                      .findRenderObject() as RenderBox;
                                                                                  await Share
                                                                                      .share(
                                                                                      "https://play.google.com/store/apps/details?id=com.lovello.lovello",
                                                                                      subject: "HDLive",
                                                                                      sharePositionOrigin: box
                                                                                          .localToGlobal(
                                                                                          Offset
                                                                                              .zero) & box
                                                                                          .size);
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets
                                                                                      .only(
                                                                                      left: 20
                                                                                          .h
                                                                                          .w,
                                                                                      top: 10
                                                                                          .h
                                                                                          .w,
                                                                                      right: 10
                                                                                          .h
                                                                                          .w),
                                                                                  child: Container(
                                                                                    height: 25
                                                                                        .h,
                                                                                    width: 25
                                                                                        .w,
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
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  });
                                                            });
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.menu,
                                                  color: Colors
                                                      .white,
                                                )),
                                            IconButton(
                                                onPressed:
                                                    () {
                                                  showModalBottomSheet(
                                                      context:
                                                      context,
                                                      isScrollControlled:
                                                      true,
                                                      isDismissible:
                                                      true,
                                                      backgroundColor:
                                                      Colors
                                                          .transparent,
                                                      builder:
                                                          (context) {
                                                        return StatefulBuilder(
                                                            builder:
                                                                (context,
                                                                state) {
                                                              return DraggableScrollableSheet(
                                                                expand: false,
                                                                initialChildSize: .6,
                                                                minChildSize: .6,
                                                                maxChildSize: .6,
                                                                builder: (
                                                                    context,
                                                                    scrollController) {
                                                                  return Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius
                                                                              .only(
                                                                              topLeft: Radius
                                                                                  .circular(
                                                                                  30
                                                                                      .r),
                                                                              topRight: Radius
                                                                                  .circular(
                                                                                  30
                                                                                      .r))),
                                                                      child: DefaultTabController(
                                                                        length: 2,
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              padding: EdgeInsets
                                                                                  .only(
                                                                                  left: 50
                                                                                      .h
                                                                                      .w),
                                                                              height: MediaQuery
                                                                                  .of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  .07,
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                      child: TabBar(
                                                                                        labelStyle: TextStyle(
                                                                                            color: Colors
                                                                                                .red,
                                                                                            fontWeight: FontWeight
                                                                                                .w600,
                                                                                            fontSize: 17
                                                                                                .sp),
                                                                                        unselectedLabelStyle: TextStyle(
                                                                                            color: Colors
                                                                                                .black,
                                                                                            fontWeight: FontWeight
                                                                                                .w600,
                                                                                            fontSize: 17
                                                                                                .sp),
                                                                                        indicatorColor: Colors
                                                                                            .red,
                                                                                        labelColor: Colors
                                                                                            .red,
                                                                                        unselectedLabelColor: Colors
                                                                                            .black,
                                                                                        tabs: [
                                                                                          Container(
                                                                                            child: Text(
                                                                                                "WAITING"),
                                                                                          ),
                                                                                          Container(
                                                                                            child: Text(
                                                                                                "GUEST LIVE"),
                                                                                          )
                                                                                        ],
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                                child: Container(
                                                                                  padding: EdgeInsets
                                                                                      .only(
                                                                                      left: 20
                                                                                          .h
                                                                                          .w),
                                                                                  child: TabBarView(
                                                                                    children: [
                                                                                      AudioWaitList(
                                                                                        channelName: widget.channelName??"",
                                                                                        broadcaster: widget.broadcaster!,
                                                                                        listViewer: listViewer,
                                                                                      ),
                                                                                      GuestList(
                                                                                        channelName: widget.channelName??"",
                                                                                        broadcaster: widget.broadcaster!,
                                                                                        isVideo: false,
                                                                                        callEnd: () async {
                                                                                          // await _engine.setChannelProfile(ChannelProfile.Communication);
                                                                                          // await _engine.setClientRole(ClientRole.Audience);
                                                                                          _engine!.leaveChannel();
                                                                                          _initAgoraRtcEngine();
                                                                                        },
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                            // widget.broadcaster
                                                                            //     ? Container()
                                                                            //     : AudioVideoJoin(channelName: widget.channelName,onStartListen:onStartListen ,)
                                                                          ],
                                                                        ),
                                                                      ));
                                                                },
                                                              );
                                                            });
                                                      });
                                                },
                                                icon: badge.Badge(
                                                    badgeContent:
                                                    Text(
                                                      "$requester",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white),
                                                    ),
                                                    position:
                                                    BadgePosition
                                                        .topEnd(),
                                                    showBadge: requester !=
                                                        0
                                                        ? true
                                                        : false,
                                                    child: Image
                                                        .asset(
                                                        "images/Join_live_list.png"))),
                                            SizedBox(
                                              width: 60,
                                            ),
                                            IconButton(
                                                onPressed:
                                                    () async {
                                                  if (broadcasterLeft) {
                                                    Fluttertoast
                                                        .showToast(
                                                        msg: 'Sorry! You can not send gift.');
                                                    return;
                                                  }
                                                  var i = await TokenManagerServices()
                                                      .getData();
                                                  user =
                                                  await ProfileUpdateServices()
                                                      .getUserInfo(
                                                      i.userId,
                                                      true);
                                                  showModalBottomSheet(
                                                      context:
                                                      context,
                                                      isScrollControlled:
                                                      true,
                                                      isDismissible:
                                                      true,
                                                      backgroundColor:
                                                      Colors
                                                          .transparent,
                                                      builder:
                                                          (context) {
                                                        return Gift_Model(
                                                          user: user!,
                                                          channelName:
                                                          widget.channelName??"",
                                                          broadcastUser:
                                                          widget.broadcastUser!,
                                                          broadcaster: widget.broadcaster!,
                                                        );
                                                      });
                                                },
                                                icon: Image.asset(
                                                    "images/Gift.png")),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                      : Container(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height *
                                        0.1,
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width
                                        .w,
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed:
                                                      () {
                                                    openModalBottomSheetForMessage(context, widget.channelName??"", _comment);
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .message_outlined,
                                                    color: Colors
                                                        .white,
                                                  )),
                                              IconButton(
                                                  onPressed:
                                                      () {
                                                    showModalBottomSheet(
                                                        context:
                                                        context,
                                                        elevation:
                                                        0,
                                                        isScrollControlled:
                                                        true,
                                                        barrierColor: Colors
                                                            .transparent,
                                                        isDismissible:
                                                        true,
                                                        backgroundColor: Colors
                                                            .transparent,
                                                        builder:
                                                            (context) {
                                                          return StatefulBuilder(
                                                              builder:
                                                                  (context,
                                                                  state) {
                                                                return DraggableScrollableSheet(
                                                                  expand: false,
                                                                  initialChildSize: .17,
                                                                  minChildSize: .17,
                                                                  maxChildSize: .17,
                                                                  builder: (
                                                                      context,
                                                                      scrollController) {
                                                                    return Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .black87,
                                                                          borderRadius: BorderRadius
                                                                              .only(
                                                                              topLeft: Radius
                                                                                  .circular(
                                                                                  30
                                                                                      .r),
                                                                              topRight: Radius
                                                                                  .circular(
                                                                                  30
                                                                                      .r))),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment
                                                                            .start,
                                                                        children: [
                                                                          SingleChildScrollView(
                                                                            scrollDirection: Axis
                                                                                .horizontal,
                                                                            child: Row(
                                                                              children: emojiViewers,
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                              child: FutureBuilder<
                                                                                  EmojiModel>(
                                                                                future: EmojiService().getEmoji().then((value) => value??EmojiModel()),
                                                                                builder: (
                                                                                    context,
                                                                                    snapshot) {
                                                                                  if (snapshot
                                                                                      .hasData) {
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .all(
                                                                                          8.0),
                                                                                      child: Container(
                                                                                        child: GridView
                                                                                            .builder(
                                                                                          shrinkWrap: true,
                                                                                          itemCount: snapshot.data?.data?.length??0,
                                                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                              crossAxisCount: 1,
                                                                                              childAspectRatio: 2,
                                                                                              crossAxisSpacing: 15,
                                                                                              mainAxisSpacing: 15),
                                                                                          scrollDirection: Axis
                                                                                              .horizontal,
                                                                                          itemBuilder: (
                                                                                              BuildContext context,
                                                                                              int index) {
                                                                                            return GestureDetector(
                                                                                              // onTap: () async {
                                                                                              //   player.play(emoji['song'][index],
                                                                                              //   );
                                                                                              // },
                                                                                              // child: Image.asset(snapshot.data.data[index].file),
                                                                                                child: Image.network(snapshot.data!.data![index].file!));
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    return Container();
                                                                                  }
                                                                                },
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              });
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .emoji_emotions_outlined,
                                                    color: Colors
                                                        .white,
                                                  )),
                                              IconButton(
                                                  onPressed:
                                                      () {
                                                    showModalBottomSheet(
                                                        context:
                                                        context,
                                                        isScrollControlled:
                                                        true,
                                                        isDismissible:
                                                        true,
                                                        backgroundColor: Colors
                                                            .transparent,
                                                        builder:
                                                            (context) {
                                                          return StatefulBuilder(
                                                              builder:
                                                                  (context,
                                                                  state) {
                                                                return DraggableScrollableSheet(
                                                                    expand: false,
                                                                    initialChildSize: .1,
                                                                    minChildSize: .1,
                                                                    maxChildSize: .1,
                                                                    builder: (
                                                                        context,
                                                                        scrollController) {
                                                                      return Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .white,
                                                                            borderRadius: BorderRadius
                                                                                .only(
                                                                                topLeft: Radius
                                                                                    .circular(
                                                                                    30
                                                                                        .r),
                                                                                topRight: Radius
                                                                                    .circular(
                                                                                    30))),
                                                                        child: Row(
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                final box = context
                                                                                    .findRenderObject() as RenderBox;
                                                                                await Share
                                                                                    .share(
                                                                                    "https://play.google.com/store/apps/details?id=com.lovello.lovello",
                                                                                    subject: "HDLive",
                                                                                    sharePositionOrigin: box
                                                                                        .localToGlobal(
                                                                                        Offset
                                                                                            .zero) & box
                                                                                        .size);
                                                                              },
                                                                              child: Padding(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    left: 20
                                                                                        .h
                                                                                        .w,
                                                                                    top: 10
                                                                                        .h
                                                                                        .w,
                                                                                    right: 10
                                                                                        .h
                                                                                        .w),
                                                                                child: Container(
                                                                                  height: 30
                                                                                      .h,
                                                                                  width: 30
                                                                                      .w,
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
                                                                        ),
                                                                      );
                                                                    });
                                                              });
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .menu,
                                                    color: Colors
                                                        .white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        !widget.broadcaster!
                                            ? Container(
                                          width: MediaQuery
                                              .of(
                                              context)
                                              .size
                                              .width *
                                              0.3.w,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              IconButton(
                                                  onPressed:
                                                      () async {
                                                    var i =
                                                    await TokenManagerServices()
                                                        .getData();
                                                    user =
                                                    await ProfileUpdateServices()
                                                        .getUserInfo(i.userId,
                                                        true);
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: true,
                                                        isDismissible: true,
                                                        backgroundColor: Colors
                                                            .transparent,
                                                        builder: (context) {
                                                          return Gift_Model(
                                                            user: user!,
                                                            channelName: widget.channelName??"",
                                                            broadcastUser: widget.broadcastUser!,
                                                            broadcaster: widget.broadcaster!,
                                                          );
                                                        });
                                                  },
                                                  icon:
                                                  Image.asset(
                                                      "images/Gift.png")),
                                              ButtonTheme(
                                                child:
                                                GestureDetector(
                                                  onTap:
                                                      () async {
                                                    print(
                                                        'Viewres UId  === ${widget.broadcastUser?.name}');
                                                    if (!isJoin) {
                                                      await FirestoreServices
                                                          .joinVideo(
                                                        1,
                                                        widget.channelName??"",
                                                      );
                                                      setState(() {
                                                        isJoin = !isJoin;
                                                      });
                                                    } else {
                                                      return showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Are you sure you want to leave?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    'No'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  await FirestoreServices
                                                                      .joinVideo(
                                                                    0,
                                                                    widget.channelName??"",
                                                                  );
                                                                  _engine!.leaveChannel();
                                                                  _initAgoraRtcEngine();
                                                                  // await _engine.setChannelProfile(ChannelProfile.Communication);
                                                                  // await _engine.setClientRole(ClientRole.Audience);
                                                                  setState(() {
                                                                    isJoin =
                                                                    !isJoin;
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Yes',
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .red)),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child:
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .black12,
                                                                      Colors
                                                                          .black12
                                                                    ],
                                                                    begin: Alignment
                                                                        .bottomLeft,
                                                                    end: Alignment
                                                                        .bottomRight)),
                                                            child: Image.asset(
                                                              "images/hand.png",
                                                              height: 25.h,
                                                              width: 35.w,
                                                              color: isJoin
                                                                  ? Colors.red
                                                                  : Colors
                                                                  .white,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .all(5.0),
                                                            child: Text(
                                                              'Raise',
                                                              style: TextStyle(
                                                                  color: !isJoin
                                                                      ? Colors
                                                                      .red
                                                                      .shade800
                                                                      : Colors
                                                                      .transparent,
                                                                  fontSize: 11.0,
                                                                  fontWeight: FontWeight
                                                                      .w800),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          broadcasterLeft
                              ? Center(
                            child: Container(
                              child: Center(
                                child: Text(
                                  "Live ended by broadcaster",
                                  style: TextStyle(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                              : _viewRows(ismute),
                          LiveHeader(
                              isAudio: true,
                              broadcastUser: widget.broadcastUser!,
                              broadcaster: widget.broadcaster!,
                              channelName: widget.channelName??"",
                              userchannelId: hostid,
                              msgText: widget.msgText??"",
                              isMute: muted,
                              onClose: () {
                                if (widget.broadcaster!) {
                                  int seconds = timerServices
                                      .getCurrentTime();
                                  closeLiveModal(
                                      context,
                                      widget.channelName??"",
                                      seconds,
                                      "audio");
                                  timerServices.close();
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
                                    false);
                              }),
                          getGift()!,
                          getInvite(),
                          getBackView(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: Loading(),
              );
            }
          },
        ),
      ),
    );
  }

  // var files;
  List<FileSystemEntity>? files;

  void getFiles() async {

    try{
      // Get the root directory
      Directory? rootDirectory = await getExternalStorageDirectory();
      if (rootDirectory == null) {
        print("Root directory not found");
        return;
      }

      // Start searching for .mp3 files
      files = await _fetchFiles(rootDirectory, extensions: ['mp3']);
      // Update the UI
      setState(() {});
    }catch(e){
      print("Error: $e");
    }

    //asyn function to get list of files
    // List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    // var root = storageInfo[0]
    //     .rootDir; //storageInfo[1] for SD card, geting the root directory
    // var fm = FileManager(root: Directory(root)); //
    // files = await fm.filesTree(
    //     extensions: ["mp3"] //optional, to filter files, list only mp3 files
    // );
    // setState(() {}); //update the UI
  }

  Future<List<FileSystemEntity>> _fetchFiles(Directory directory, {List<String> extensions = const []}) async {
    List<FileSystemEntity> allFiles = [];
    try {
      var entities = directory.listSync(recursive: true);
      for (var entity in entities) {
        if (entity is File && extensions.any((ext) => entity.path.endsWith(ext))) {
          allFiles.add(entity);
        }
      }
    } catch (e) {
      print("Error accessing directory: $e");
    }
    return allFiles;
  }

   showAudio() {
    getFiles();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AudioFiles(files: files?.whereType<File>().toList() ?? []);
        });
  }

   ShowRoomSkin() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // return StatefulBuilder(builder: (context, setState) {
          return FutureBuilder<Roomskinmodel>(
            future: RoomskinService().Roomscreen(userId: user?.userId),
            builder: (context, snapshot) {
              print("data----11${snapshot.data}");
              if (snapshot.hasData) {
                print("data----22${snapshot.data}");
                return Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .15,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .8,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.data?.length??0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print(
                                "image====${snapshot.data!.data![index].image}");
                            print("roomskin$roomskinimageIndex");
                            // roomSkinImages.clear();
                            // roomSkinImages.add("${snapshot.data.data[index].image}");
                            FirestoreServices.setBroadcasterView(
                                widget.channelName??"",
                                snapshot.data!.data![index].image!);
                            // setState(() {
                            //   roomskinimageIndex = index;
                            //   roomSkinImages;
                            //   changeBackground = true;
                            // });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: roomskinimageIndex == index
                                            ? Colors.transparent
                                            : Colors.transparent,
                                        width: 2)),
                                child: Image.network(
                                  snapshot.data?.data?[index].image??"",
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                children: [
                                  snapshot.data!.data![index].useType!.contains("free")
                                      ? Container()
                                      : Image.asset(
                                    'images/dimond.png',
                                    height: 8,
                                    width: 8,
                                  ),
                                  Text("${snapshot.data?.data?[index].value}"),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                );
              } else {
                return Center(
                  child: Loading(),
                );
              }
            },
          );
          // });
        });
  }
}

class VideoView extends StatefulWidget {
  final String url;

  VideoView(this.url);

  @override
  _StatefulWidgetState createState() => _StatefulWidgetState();
}

class _StatefulWidgetState extends State<VideoView> {
  Widget _buildVideoPlayerWidget(String url) {
    return Container(
      alignment: Alignment.center,
      child: NativeVideoView(
        keepAspectRatio: true,
        showMediaController: true,
        enableVolumeControl: true,
        onCreated: (controller) {
          controller.setVideoSource(
            url,
            sourceType: native.VideoSourceType.network,
            requestAudioFocus: true,
          );
        },
        onPrepared: (controller, info) {
          debugPrint('NativeVideoView: Video prepared');
          controller.play();
        },
        onError: (controller, what, extra, message) {
          debugPrint(
              'NativeVideoView: Player Error ($what | $extra | $message)');
        },
        onCompletion: (controller) {
          debugPrint('NativeVideoView: Video completed');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildVideoPlayerWidget(widget.url),
    );
  }
}

class AudioVideoJoin extends StatefulWidget {
  final String? channelName;
  final Function? onStartListen;

  AudioVideoJoin({this.channelName, this.onStartListen});

  @override
  _AudioVideoJoinState createState() => _AudioVideoJoinState();
}

class _AudioVideoJoinState extends State<AudioVideoJoin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * .1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.red))
              )
            ),
            onPressed: () async {
              await FirestoreServices.joinVideo(1, widget.channelName??"");
              widget.onStartListen!();
            },
            child: Row(
              children: [
                Icon(
                  Icons.mic_none_outlined,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Audio Join",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
                shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                )
            ),
            onPressed: () async {
              await FirestoreServices.joinVideo(2, widget.channelName??"");
              widget.onStartListen!();
            },
            child: Row(
              children: [
                Icon(
                  Icons.videocam,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Video Join",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

int? selectedIndex;

class VideoLiveGuestList extends StatefulWidget {
  final String? channelName;
  final bool? broadcaster;
  final Function? callEnd;
  bool? isVideo = false;

  VideoLiveGuestList(
      {this.channelName, this.broadcaster, this.callEnd, this.isVideo});

  @override
  _VideoLiveGuestListState createState() => _VideoLiveGuestListState();
}

class _VideoLiveGuestListState extends State<VideoLiveGuestList> {
  List<Widget> guestListWidget = [];

  getList() {
    return FirestoreServices().getVideoGuestViewer(widget.channelName??"")!.forEach((element) {
      List<ViewerModel> viewers = element;
      if (guestListWidget.isNotEmpty) {
        guestListWidget.clear();
      }
      print('Viewers == ${viewers.length}');
      for (var i = 0; i < viewers.length; i++) {
        ViewerModel viewer = viewers[i];
        guestListWidget.add(ListTile(
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
            maxLines: 1,
            style: TextStyle(fontSize: 14.sp),
          ),
          trailing: widget.broadcaster!
              ? Container(
            width: widget.isVideo! ? 150.h : 100.h,
            height: 70.w,
            child: Row(
              children: [
                !viewer.isMute!
                    ? GestureDetector(
                  onTap: () {
                    if (widget.broadcaster!) {
                      FirestoreServices
                          .broadcasterRightUserMuteUnmute(
                          widget.channelName??"", true, viewer.uid!);
                    } else {
                      if (!viewer.broadcaster_mute!) {
                        FirestoreServices.joinUserMuteUnmute(
                            widget.channelName??"", true, viewer.uid!);
                      } else {
                        Fluttertoast.showToast(
                            msg:
                            "Sorry! You can't unmute audio to yourself now");
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: (20),
                    backgroundColor: Colors.red,
                    child: ClipRRect(
                      child: Icon(
                        Icons.mic_none_outlined,
                        color: Colors.white,
                        size: 18.0,
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    FirestoreServices
                        .broadcasterRightUserMuteUnmute(
                        widget.channelName??"", false, viewer.uid!);
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: (20),
                    backgroundColor: Colors.red,
                    child: ClipRRect(
                      child: Icon(Icons.mic_off_rounded,
                          color: Colors.white, size: 18.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                  width: 10,
                ),
                widget.isVideo!
                    ? GestureDetector(
                  onTap: () {
                    if (widget.broadcaster!) {
                      if (!viewer.isCamera!) {
                        viewer.isCamera = !viewer.isCamera!;
                        FirestoreServices
                            .broadcasterRightUserVideoMuteUnmute(
                            widget.channelName??"",
                            viewer.isCamera!,
                            viewer.uid!);
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                            msg:
                            "Sorry! You can't on camera of Viewers.");
                      }
                    } else {
                      if (!viewer.broadcaster_video_mute!) {
                        viewer.isCamera = !viewer.isCamera!;
                        FirestoreServices.joinUserStream(
                            widget.channelName??"",
                            viewer.isCamera!,
                            viewer.uid!);
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                            msg:
                            "Sorry! You can't unmute video to yourself now");
                      }
                    }
                  },
                  child: CircleAvatar(
                    radius: (20),
                    backgroundColor: Colors.red,
                    child: ClipRRect(
                      child: Icon(
                          !viewer.isCamera!
                              ? Icons.video_call
                              : Icons.videocam_off_rounded,
                          color: Colors.white,
                          size: 18.0),
                    ),
                  ),
                )
                    : Container(),
                widget.isVideo!
                    ? SizedBox(
                  width: 10,
                )
                    : Container(),
                GestureDetector(
                  onTap: () {
                    widget.callEnd!();
                    FirestoreServices.joinUserRemove(
                        widget.channelName??"", viewer.uid!);
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: (20),
                    backgroundColor: Colors.red,
                    child: ClipRRect(
                      child: Icon(Icons.call_end,
                          color: Colors.white, size: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          )
              : Container(),
        ));
      }
      setState(() {});
    });
  }

  var isMute = false;

  @override
  Widget build(BuildContext context) {
    getList();
    // if (guestListWidget.isNotEmpty) {
    //   guestListWidget.clear();
    // }
    // print('Widget list lenmgth ==== ${guestListWidget.length}');
    // Padding(
    //   padding: const EdgeInsets.only(left: 30),
    //   child: Text(
    //     "Guest List (${
    //     snapshot.data.length})",
    //     style: TextStyle(color: Colors.grey[600]),
    //   ),
    // ),
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: guestListWidget);
  }
}
