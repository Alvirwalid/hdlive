import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

class GoMultiGuestLive extends StatefulWidget {
  final TextEditingController? controller;

  final Function? changeSeats;
  GoMultiGuestLive({this.controller, this.changeSeats});
  @override
  _GoMultiGuestLiveState createState() => _GoMultiGuestLiveState();
}

class _GoMultiGuestLiveState extends State<GoMultiGuestLive> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int seat = 4; //available 4,6,9
  CurrentUserModel? user;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    print("on Init");
    getAvailableCameras();
  }

  getAvailableCameras() async {
    var i = await TokenManagerServices().getData();
    user = await ProfileUpdateServices().getUserInfo(i.userId, true);
    final cameras = await availableCameras();

    var firstCamera;

    for (var i = 0; i < cameras.length; i++) {
      var camera = cameras[i];
      if (camera.lensDirection == CameraLensDirection.front) {
        firstCamera = camera;
      }
    }

    if (firstCamera == null) {
      firstCamera = cameras.first;
    }
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller?.initialize();
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    print("on dispose");
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the preview.
                          return Transform.scale(
                            scale: 1.0,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: OverflowBox(
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                                    width: size.width,
                                    // height: size.height,
                                    child: Stack(
                                      children: <Widget>[
                                        CameraPreview(_controller!),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Otherwise, display a loading indicator.
                          // return Center(child: CircularProgressIndicator());
                          return Center(child: Loading());
                        }
                      },
                    )),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    // border: Border(bottom: BorderSide(color: Colors.black))
                  ),
                  height: MediaQuery.of(context).size.height * .1,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.25 + 20,
                        top: MediaQuery.of(context).size.height * .03),
                    child: TextFormField(
                      expands: true,
                      autofocus: false,
                      maxLines: null,
                      controller: widget.controller,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add a title to chat",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: user?.image != null
                      ? CircleAvatar(
                          radius: 40,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: HexagonProfilePicNetworkImage(
                                url: user?.image,
                              )),
                        )
                      : InitIconContainer(
                          radius: 80,
                          text: user?.name,
                        ),
                ),
                Container(
                  child: Column(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SeatSelectionForMultiGuest(
                              active: seat == 4,
                              image: "4.png",
                              seats: 4,
                              onTap: () {
                                widget.changeSeats!(4);
                                setState(() {
                                  seat = 4;
                                });
                              },
                            ),
                            SeatSelectionForMultiGuest(
                              active: seat == 6,
                              image: "6.png",
                              seats: 6,
                              onTap: () {
                                widget.changeSeats!(6);
                                setState(() {
                                  seat = 6;
                                });
                              },
                            ),
                            SeatSelectionForMultiGuest(
                              active: seat == 9,
                              image: "9.png",
                              seats: 9,
                              onTap: () {
                                widget.changeSeats!(9);
                                setState(() {
                                  seat = 9;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 120,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

class SeatSelectionForMultiGuest extends StatelessWidget {
  final String? image;
  final bool? active;
  final int? seats;
  final Function? onTap;
  SeatSelectionForMultiGuest({this.image, this.active, this.seats, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: active! ? Colors.red : Colors.transparent)),
                padding: EdgeInsets.all(3),
                child: Image(
                  width: 20,
                  image: AssetImage("images/${image}"),
                )),
            Container(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                "$seats Seats",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
