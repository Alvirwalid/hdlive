import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BeanHeader extends StatelessWidget {
  BeanHeader({this.beans});
  final String? beans;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.blue,
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black, Colors.red]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              height: 65,
                              width: 60,
                              child: Image.asset(
                                "images/beans.png",
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 10, left: 5),
                                child: Text(
                                  beans.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                )),
                            SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          "Current beans",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // decoration: BoxDecoration(
                    //   // color: Colors.blue,
                    //   gradient: LinearGradient(
                    //       begin: Alignment.centerLeft,
                    //       end: Alignment.centerRight,
                    //       colors: [Colors.purple.shade700, Colors.red]),
                    // ),
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "images/Withdrawal_History.svg",
                          height: 25,
                          color: Colors.white,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            "beans record",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
