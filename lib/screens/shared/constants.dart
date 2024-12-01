import 'package:flutter/material.dart';

TextStyle lableStyle =
    TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 14);
TextStyle selectedLableStyle = TextStyle(
    fontWeight: FontWeight.w700, color: Color(0xFFAA2104), fontSize: 14);

InputDecoration loginInputDecoration = InputDecoration(
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[200]!)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red)),
    hintStyle: TextStyle(color: Colors.grey));

InputDecoration signupInputDecoration = InputDecoration(
    // contentPadding: EdgeInsets.all(8),
    // errorStyle: TextStyle(height: 0,color: Colors.transparent),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[200]!)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red)),
    hintStyle: TextStyle(color: Colors.grey));

Color primaryColor = Color(0xFFF32408);

String errorText = "Bad Internet Connection";

Map emoji = {
  'images': [
    'images/emoji/img_1.png',
    'images/emoji/img_2.png',
    'images/emoji/img_3.png',
    'images/emoji/img_4.png',
    'images/emoji/img_5.png',
    'images/emoji/img_6.png',
    'images/emoji/img_7.png',
    'images/emoji/img_8.png',
    'images/emoji/img_9.png',
    'images/emoji/img_10.png',
    'images/emoji/img_11.png',
    'images/emoji/img_13.png',
    'images/emoji/img_14.png',
    'images/emoji/img_25.png',
    'images/emoji/img_26.png',
    'images/emoji/img_27.png',
    'images/emoji/img_28.png',
    'images/emoji/img_29.png',
    'images/emoji/img_30.png',
    'images/emoji/img_31.png',
    'images/emoji/img_32.png',
    'images/emoji/img_33.png',
    'images/emoji/img_34.png',
  ],
  'song': [
    //'images/emoji_sound/default.mp3',
    'images/emoji_sound/sou_1.ogg',
    'images/emoji_sound/sou_2.ogg',
    'images/emoji_sound/sou_3.ogg',
    'images/emoji_sound/sou_4.ogg',
    'images/emoji_sound/sou_5.ogg',
    'images/emoji_sound/sou_6.ogg',
    'images/emoji_sound/sou_7.ogg',
    'images/emoji_sound/sou_8.ogg',
    'images/emoji_sound/sou_9.ogg',
    'images/emoji_sound/sou_10.ogg',
    'images/emoji_sound/sou_11.ogg',
    // 'images/emoji_sound/sou_12.ogg',
    'images/emoji_sound/sou_13.ogg',
    'images/emoji_sound/sou_14.ogg',
    'images/emoji_sound/sou_25.ogg',
    'images/emoji_sound/sou_26.ogg',
    'images/emoji_sound/sou_27.ogg',
    'images/emoji_sound/sou_28.ogg',
    'images/emoji_sound/sou_29.ogg',
    'images/emoji_sound/sou_30.ogg',
    'images/emoji_sound/sou_31.ogg',
    'images/emoji_sound/sou_32.ogg',
    'images/emoji_sound/sou_33.ogg',
    'images/emoji_sound/sou_34.ogg',
  ]
};
