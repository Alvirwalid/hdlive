import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

class InitIconContainer extends StatelessWidget {
  final double? radius;
  final String? text;

  InitIconContainer({this.radius, this.text});
  @override
  Widget build(BuildContext context) {
    return Initicon(
      size: radius??0,
      text: text,
    );
  }
}
