import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

class GoLive extends StatefulWidget {
  final TextEditingController? controller;
  GoLive({this.controller});
  @override
  _GoLiveState createState() => _GoLiveState();
}

class _GoLiveState extends State<GoLive> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  CurrentUserModel? user;
  bool loading = true;
  @override
  void initState() {
    super.initState();

    getAvailableCameras();
  }

  getAvailableCameras() async {
    var i = await TokenManagerServices().getData();
    CurrentUserModel? temp = await ProfileUpdateServices().getUserInfo(i.userId, true);
    print(temp?.image == " ");
    print("ee");
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
      user = temp;
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
                                        // Positioned(
                                        //   bottom: 50,
                                        //   left: 100,
                                        //   width: 50,
                                        //   height: 50,
                                        //   child: Container(
                                        //     width: 5,
                                        //     height: 10,
                                        //     child: Image.asset(
                                        //       'images/beauty.png',
                                        //       color: Colors.white,
                                        //     ),
                                        //   ),
                                        // ),
                                        // Positioned(
                                        //   bottom: 50,
                                        //   left: 160,
                                        //   width: 50,
                                        //   height: 50,
                                        //   child: GestureDetector(
                                        //     onTap: () {},
                                        //     child: Container(
                                        //         width: 5,
                                        //         height: 10,
                                        //         child: Icon(
                                        //           Icons.filter,
                                        //           size: 50,
                                        //           color: Colors.white,
                                        //         )),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Otherwise, display a loading indicator.
                          return Center(child: Loading());
                          // return Center(child: CircularProgressIndicator());
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
                          radius: 80.r,
                          text: user?.name,
                        ),
                ),
              ],
            ),
          );
  }
}
