import 'package:flutter/material.dart';

class ChipIcon extends StatelessWidget {
  final Widget? avater;
  final String ?text;
  final List<Color>? color;
  final String ?BirthDate;
  ChipIcon({
    this.avater,
    this.text,
    this.color,
    this.BirthDate,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 38,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            stops: [0.1, 0.5],
            colors: color??[],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: Row(
        children: [
          SizedBox(
            width: 4,
          ),
          avater??SizedBox(),
          Spacer(),
          Text(
            text??"",
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
          SizedBox(
            width: 6,
          ),
        ],
      ),
    );
    // return Chip(
    //   visualDensity: VisualDensity.compact,
    //   backgroundColor: color,
    //   avatar: avater,
    //   shape: RoundedRectangleBorder(
    //       side: BorderSide(color: Colors.grey[400]),
    //       borderRadius: BorderRadius.circular(20)),
    //   label: Text(
    //     text,
    //     style: TextStyle(color: Colors.black),
    //   ),
    // );
  }
}

class ChipWithoutIcon extends StatelessWidget {
  final String? text;
  ChipWithoutIcon({this.text});
  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(20)),
      label: Text(
        text??"",
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
    );
  }
}
