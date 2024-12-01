import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiamondOffers extends StatefulWidget {
  @override
  _DiamondOffersState createState() => _DiamondOffersState();
}

class _DiamondOffersState extends State<DiamondOffers> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: 8,  // The length Of the array
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // childAspectRatio: 0.6,
          // crossAxisSpacing: 4,
          // mainAxisSpacing: 4,
        ), // The size of the grid box
        itemBuilder: (context, index) => Container(
          child:Padding(
            padding: EdgeInsets.all(2),
            child: Container(

              width: size.width/3.2,
              height: size.width/3.4,

              decoration: BoxDecoration(
                border: index==0?Border.all(color: Colors.red):Border.all(color: Colors.white),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("images/diamonds.svg",height: 20,),
                        Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text("3500",style: TextStyle(color: Color(0xFF161523),fontSize: 15,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text("+2000",style: TextStyle(color: Color(0xFFD8300E),fontSize:12,fontWeight: FontWeight.normal),),
                        Text("Diamonds",style: TextStyle(color: Color(0xFFD8300E),fontSize:12,fontWeight: FontWeight.normal),)
                      ],
                    ),
                  ),
                  Text("BDT 100",style: TextStyle(color: Color(0xFFD8300E),fontSize:14,fontWeight: FontWeight.w500),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
