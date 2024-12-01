import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

class SignInSignUpRichText extends StatelessWidget {
  final String? plainText;
  final String? coloredText;
  final String? route;
  SignInSignUpRichText({this.plainText, this.coloredText, this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route??"");
      },
      child: EasyRichText(
        "$plainText $coloredText",
        defaultStyle: TextStyle(color: Colors.white, fontSize: 9),
        patternList: [
          EasyRichTextPattern(
              targetString: coloredText,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
