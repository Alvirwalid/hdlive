
import 'package:flutter/material.dart';

import 'package:hdlive_latest/services/firestore_services.dart';


class LinearSocialButtonGroupPhone extends StatelessWidget {
  final BuildContext? context;

  LinearSocialButtonGroupPhone({this.context});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(

        children: [
       Container(width: 40,),
          Container(
            child: Image(
              image: AssetImage(
                  "images/facebook.png"
              ),
            ),
          ), //facebook
          GestureDetector(
            onTap: () async{
            },
            child: Container(
              child: Image(
                image: AssetImage(
                    "images/google.png"
                ),
              ),
            ),
          ), //google
           //twitter
        ],
      ),
    );
  }
}
