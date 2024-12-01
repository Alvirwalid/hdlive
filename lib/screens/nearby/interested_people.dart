import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestedPeople extends StatefulWidget {
  @override
  _InterestedPeopleState createState() => _InterestedPeopleState();
}

class _InterestedPeopleState extends State<InterestedPeople> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 45.h,
            padding: EdgeInsets.only(left: 30),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 180,
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: AssetImage('images/img-01.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    right: 150,
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: AssetImage('images/img-02.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 60,
                    right: 120,
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: AssetImage('images/img-03.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 90,
                    right: 90,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('images/img-04.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    right: 60,
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: AssetImage('images/img-05.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    right: 30,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('images/img-06.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 180,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: AssetImage('images/img-07.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              "7 People nearby are interested in you",
              style: TextStyle(color: Colors.grey, fontSize: 11.sp),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              child: Text(
                "Say Hello",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
