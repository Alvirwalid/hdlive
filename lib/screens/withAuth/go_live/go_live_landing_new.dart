import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:hdlive_latest/screens/live/pages/audio_live.dart';
import 'package:hdlive_latest/screens/live/pages/audio_live_new.dart';
import 'package:hdlive_latest/screens/live/pages/call.dart';
import 'package:hdlive_latest/screens/live/pages/multi_guest_live.dart';
import 'package:hdlive_latest/screens/live/pages/theater_live.dart';
import 'package:hdlive_latest/screens/withAuth/go_live/Theater_live.dart';
import 'package:hdlive_latest/screens/withAuth/go_live/go_audio_live.dart';
import 'package:hdlive_latest/screens/withAuth/go_live/go_live.dart';
import 'package:hdlive_latest/screens/withAuth/go_live/go_multi_guest_live.dart';
import 'package:hdlive_latest/services/firestore_services.dart';
import 'package:hdlive_latest/services/live_service/live_service.dart';
import 'package:uuid/uuid.dart';

class GoLiveLandingNew extends StatefulWidget {
  @override
  _GoLiveLandingNewState createState() => _GoLiveLandingNewState();
}

class _GoLiveLandingNewState extends State<GoLiveLandingNew> {
  int activeIdx = 2;

  TextEditingController _title = TextEditingController();
  CountDownController _countDownController = CountDownController();
  bool showCountdown = false;
  String? liveId;

  int seats = 4;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            activeIdx == 1
                ? GoLive(
                    controller: _title,
                  )
                : activeIdx == 2
                    ? GoAudioLive(
                        controller: _title,
                      )
                    : activeIdx == 0
                        ? GoMultiGuestLive(
                            controller: _title,
                            changeSeats: (val) {
                              seats = val;
                            },
                          )
                        : GoTheaterLive(),
            showCountdown
                ? Center(
                    child: CircularCountDownTimer(
                      duration: 3,
                      initialDuration: 0,
                      controller: _countDownController,
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      ringColor: Colors.grey[300]!,
                      ringGradient: null,
                      fillColor: Colors.red[200]!,
                      fillGradient: null,
                      backgroundColor: Colors.red[500]!,
                      backgroundGradient: null,
                      strokeWidth: 20.0,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                          fontSize: 33.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textFormat: CountdownTextFormat.S,
                      isReverse: true,
                      isReverseAnimation: true,
                      isTimerTextShown: true,
                      autoStart: false,
                      onComplete: () async {
                        Navigator.of(context).pop();
                        if (activeIdx == 1) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => CallPage(
                                channelName: liveId,
                                msgText: _title.text,
                                role: 1,
                                broadcaster: true,
                              ),
                            ),
                          );
                        } else if (activeIdx == 2) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => AudioLiveNew(
                                      msgText: _title.text,
                                      channelName: liveId,
                                      broadcaster: true,
                                    )),
                          );
                        } else if (activeIdx == 0) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => MultiGuestLive(
                                channelName: liveId,
                                broadcaster: true,
                                seats: seats,
                                msgText: _title.text,
                              ),
                            ),
                          );
                        } else if (activeIdx == 3) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => TheaterLive()),
                          );
                        }
                      },
                    ),
                  )
                : Container(),
            Container(
              child: Column(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          const Color(0xFFF12408),
                          const Color(0xFFAE2104),
                        ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:MaterialStatePropertyAll(Colors.white) ,
                              shape: MaterialStatePropertyAll( RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)))
                            ),
                            onPressed: () async {
                              if (!showCountdown) {
                                // await _handleCameraAndMic(Permission.camera);
                                // await _handleCameraAndMic(
                                //     Permission.microphone);
                                setState(() {
                                  showCountdown = true;
                                });

                                Future.delayed((Duration(milliseconds: 200)),
                                    () {
                                  _countDownController.start();
                                });
                                if (activeIdx != 3) {
                                  var id = Uuid();

                                  liveId = "Live_Id--${id.v1()}";

                                  if(activeIdx == 1){
                                    await LiveService().isTimeLiveCall("video", "start");
                                  }else if(activeIdx == 2){
                                    await LiveService().isTimeLiveCall("audio", "start");
                                  }

                                  await FirestoreServices.createNewLive(liveId??"",
                                      _title.text, context, activeIdx, seats);
                                }
                              } else {}
                            },
                            child: Text(
                              showCountdown ? 'Please Wait Working' : "GO LIVE",
                              style: TextStyle(
                                  color: Color(0xFFD8300E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              LiveOptions(
                                option: "Multi-guest LIVE",
                                width: MediaQuery.of(context).size.width * 0.28,
                                active: activeIdx == 0,
                                onTap: () {
                                  setState(() {
                                    activeIdx = 0;
                                  });
                                },
                              ),
                              LiveOptions(
                                option: "LIVE",
                                width: MediaQuery.of(context).size.width * 0.09,
                                active: activeIdx == 1,
                                onTap: () {
                                  setState(() {
                                    activeIdx = 1;
                                  });
                                },
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.30,
                                child: LiveOptions(
                                  option: "Audio LIVE",
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  active: activeIdx == 2,
                                  onTap: () {
                                    setState(() {
                                      activeIdx = 2;
                                    });
                                  },
                                ),
                              ),

                              // LiveOptions(
                              //   option: "THEATER",
                              //   width: MediaQuery.of(context).size.width * 0.17,
                              //   active: activeIdx == 3,
                              //   onTap: () {
                              //     setState(() {
                              //       activeIdx = 3;
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _handleCameraAndMic(Permission permission) async {
  //   final status = await permission.request();
  //   print(status);
  // }
}

class LiveOptions extends StatelessWidget {
  final String? option;
  final double? width;
  final bool? active;
  final Function? onTap;
  LiveOptions({this.option, this.width, this.active, this.onTap});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap!(),
      child: Container(
        width: width,
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              child: Text(
                option??"",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: size * 0.032),
              ),
            ),
            active!
                ? Divider(
                    color: Colors.white,
                    height: 15,
                    thickness: 3,
                  )
                : Container(
                    height: 15,
                  ),
          ],
        ),
      ),
    );
  }
}
