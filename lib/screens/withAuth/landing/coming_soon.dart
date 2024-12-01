import 'package:flutter/material.dart';

class ComingSoon extends StatefulWidget {
  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/pkimage.jpeg'),
                fit: BoxFit.fitHeight)),
      ),
    );
  }
}
