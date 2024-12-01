import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'multi_guest_render_4.dart';

class MultiGuestRender6 extends StatefulWidget {
  final Widget? primary;
  final Map<int, Widget>? guest;
  final List<int> ?us;
  final Function? onJoin;
  final Map<int, dynamic>? guestInfo;
  final String? primaryName;
  MultiGuestRender6(
      {this.primary,
      this.guest,
      this.us,
      this.onJoin,
      this.guestInfo,
      this.primaryName});
  @override
  _MultiGuestRender6State createState() => _MultiGuestRender6State();
}

class _MultiGuestRender6State extends State<MultiGuestRender6> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> getVideos() {
    List<Widget> list = [];

    for (var i = 1; i < 3; i++) {
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
              // widget.onJoin(widget.us[i]);
              print(widget.us?[i]);
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
              padding: EdgeInsets.all(3.w.h),
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
              print(widget.us![i]);
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
            flex: 2,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                        padding: EdgeInsets.all(3.h.w),
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
                  Expanded(
                    child: Container(
                      child: Column(
                        children: getVideos(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            child: Row(children: getVideos2()),
          ))
        ],
      ),
    );
  }
}
