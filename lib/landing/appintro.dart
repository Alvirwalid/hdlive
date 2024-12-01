import 'package:flutter/material.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:video_player/video_player.dart';

class AppIntroPage extends StatefulWidget {

  @override
  _AppIntroPageState createState() => _AppIntroPageState();
}

class _AppIntroPageState extends State<AppIntroPage> {
   VideoPlayerController? _controller;

   @override
   void dispose() {
     _controller!.dispose();
     super.dispose();
   }
  @override
  void initState() {
     _controller = VideoPlayerController.asset(
        'images/hdlive_video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(child: NativeVideoView(
      keepAspectRatio: true,
      showMediaController: false,
      enableVolumeControl: false,
      onCreated: (controller) {
        controller.setVideoSource(
          'images/hdlive_video.mp4',
          sourceType: VideoSourceType.asset,
          requestAudioFocus: true,
        );
      },
      onPrepared: (controller, info) {
        debugPrint('NativeVideoView: Video prepared');
        controller.play();
      },
      onError: (controller, what, extra, message) {
        setState(() {
        });
        debugPrint(
            'NativeVideoView: Player Error ($what | $extra | $message)');
        Navigator.popAndPushNamed(context, '/login');
      },
      onCompletion: (controller) {
        setState(() {
        });
        debugPrint('NativeVideoView: Video completed');
        Navigator.popAndPushNamed(context, '/login');
      },
    ));
  }
}
