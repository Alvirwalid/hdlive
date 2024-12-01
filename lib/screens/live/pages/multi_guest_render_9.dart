import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/screens/live/pages/multi_guest_render_4.dart';

class MultiGuestRender9 extends StatefulWidget {
  final Widget? primary;
  final Map<int, Widget>? guest;
  final List<int>? us;
  final Function? onJoin;
  final Map<int, dynamic>? guestInfo;
  final String? primaryName;
  MultiGuestRender9(
      {this.primary,
      this.guest,
      this.us,
      this.onJoin,
      this.guestInfo,
      this.primaryName});
  @override
  _MultiGuestRender9State createState() => _MultiGuestRender9State();
}

class _MultiGuestRender9State extends State<MultiGuestRender9> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> getVideos() {
    List<Widget> list = [];

    list.add(
      Expanded(
        child: Container(
            padding: EdgeInsets.all(3.h.w),
            child: Stack(
              children: [
                widget.primary!,
                PositionedName(
                  name: widget.primaryName.toString(),
                  host: false,
                )
              ],
            )),
      ),
    );

    for (var i = 1; i < 3; i++) {
      if (widget.guest!.containsKey(widget.us![i])) {
        list.add(Expanded(
          child: Container(
              padding: EdgeInsets.all(3.h.w),
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
              // widget.onJoin(widget.us[i]);
            },
          ),
        ));
      }
    }

    return list;
  }

  List<Widget> getVideos2() {
    List<Widget> list = [];

    for (var i = 3; i < 6; i++) {
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

  List<Widget> getVideos3() {
    List<Widget> list = [];

    for (var i = 6; i < 9; i++) {
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
              //widget.onJoin(widget.us[i]);
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
    return Container(
      height: height / 1.9,
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Row(
                children: getVideos(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: getVideos2(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: getVideos3(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
