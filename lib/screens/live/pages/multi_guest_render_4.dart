import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiGuestRender4 extends StatefulWidget {
  final Widget? primary;
  final Map<int, Widget>? guest;
  final List<int>? us;
  final Function? onJoin;
  final Map<int, dynamic>? guestInfo;
  final String? primaryName;
  MultiGuestRender4(
      {this.primary,
      this.guest,
      this.us,
      this.onJoin,
      this.guestInfo,
      this.primaryName});
  @override
  _MultiGuestRender4State createState() => _MultiGuestRender4State();
}

class _MultiGuestRender4State extends State<MultiGuestRender4> {
  String name = "";
  @override
  void initState() {
    super.initState();
  }

  List<Widget> getVideos() {
    List<Widget> list = [];

    for (var i = 1; i < 4; i++) {
      if (widget.guest!.containsKey(widget.us![i])) {
        list.add(Expanded(
          child: Container(
              padding: EdgeInsets.all(3),
              child: Stack(
                children: [
                  widget.guest![widget.us![i]]!,
                  PositionedName(
                    name: widget.guestInfo![widget.us![i]]["name"].toString(),
                  )
                ],
              )),
        ));
      } else {
        list.add(Expanded(
          child: ContainerWithoutVideo4(
            onTap: () {
              //  widget.onJoin(widget.us[i]);
            },
          ),
        ));
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height / 1.6,
      child: Column(
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.all(3),
                child: Stack(
                  children: [
                    widget.primary!,
                    PositionedName(
                      name: widget.primaryName.toString(),
                      host: true,
                    )
                  ],
                )),
          ),
          Container(
            height: height / 5,
            child: Row(children: getVideos()),
          )
        ],
      ),
    );
  }
}

class ContainerWithoutVideo4 extends StatelessWidget {
  final Function? onTap;
  ContainerWithoutVideo4({this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!(),
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Image.asset("images/chair2.png", width: 30),
          ),
        ),
      ),
    );
  }
}

class VideoWithAspectRatio extends StatelessWidget {
  final Widget? child;
  VideoWithAspectRatio({this.child});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: child,
      ),
    );
  }
}

class PositionedName extends StatelessWidget {
  final String? name;
  final bool? host;
  PositionedName({this.name, this.host = false});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Color(0x33000000),
        child: Container(
            padding: host!
                ? EdgeInsets.symmetric(horizontal: 6, vertical: 8)
                : EdgeInsets.all(3),
            child: Text(
              name ?? " ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            )),
      ),
    );
  }
}
