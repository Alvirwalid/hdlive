

import 'package:flutter/material.dart';

class TeenPati extends StatefulWidget {
  const TeenPati({Key? key}) : super(key: key);

  @override
  _TeenPatiState createState() => _TeenPatiState();
}

class _TeenPatiState extends State<TeenPati> {
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: Colors.brown,
       ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 100,
                    child: Image
                        .asset(
                      "images/chair_game.jpg",
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 100,
                    child: Image
                        .asset(
                      "images/chair_game.jpg",
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 100,
                    child: Image
                        .asset(
                      "images/chair_game.jpg",
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
