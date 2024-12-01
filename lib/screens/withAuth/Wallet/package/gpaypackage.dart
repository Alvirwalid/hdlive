import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdlive_latest/models/package_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/package_service/package_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Gpaypackage extends StatefulWidget {
  Gpaypackage({this.userid});

  String? userid;

  @override
  State<Gpaypackage> createState() => _GpaypackageState();
}

class _GpaypackageState extends State<Gpaypackage> {
  @override
  void initState() {
    PackageService().Packageservicec(widget.userid??"");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffffe87c),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Gpay wallet",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.red),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Packagemodel>(
                future: PackageService().Packageservicec(widget.userid??""),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: snapshot.data?.data?.plans?.google?.length??0,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      "${snapshot.data?.data?.plans?.google?[index].diamonds} + ${snapshot.data?.data?.plans?.google?[index].extra}"),
                                  trailing: Container(
                                      height: 30.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                          color: Color(0xffee9a40),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: Text(
                                          "${snapshot.data?.data?.plans?.google?[index].price}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                  leading: Image.asset("images/dimond.png"),
                                ),
                              ],
                            );
                          }),
                    );
                  } else {
                    return Center(
                      // child: CircularProgressIndicator(),
                      child: Loading(),
                    );
                  }
                }),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 30),
          //   child: Container(
          //     height: MediaQuery.of(context).size.height * 0.05,
          //     width: MediaQuery.of(context).size.width * 0.5,
          //     decoration: BoxDecoration(
          //         color: Colors.brown, borderRadius: BorderRadius.circular(20)),
          //     child: Center(
          //       child: Text(
          //         'SUBMIT',
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
