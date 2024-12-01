import 'package:flutter/material.dart';

class Checkmyvip extends StatelessWidget {
  const Checkmyvip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Check My Vip",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
