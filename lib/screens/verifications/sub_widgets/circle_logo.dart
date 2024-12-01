import 'package:flutter/material.dart';

class CircleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * .2,
      width: height * .2,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              "images/hdlive.jpg",
            ),
            fit: BoxFit.fill),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 1)
        ],
      ),
    );
  }
}

class CircleLogoWithRadius extends StatelessWidget {
  final double? h;
  CircleLogoWithRadius({this.h});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * .13,
      width: height * .13,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              "images/hdliveicon1.jpg",
            ),
            fit: BoxFit.cover),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 1)
        ],
      ),
    );
  }
}
