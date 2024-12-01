import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key, this.isHome = false}) : super(key: key);
  final bool isHome;
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    print(' Auto imp ==== ${widget.isHome}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        shadowColor: Colors.black54,
        title: Text(
          'Message',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 28.sp,
              color: Colors.red.shade900),
        ),
        actions: [
          Image.asset(
            'images/gif/mail.gif',
            height: 50.h,
            width: 50.w,
          )
        ],
        leading: !widget.isHome
            ? Container()
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black54,
                )),
      ),
    );
  }
}
