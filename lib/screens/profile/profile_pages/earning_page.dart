import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hdlive/models/Aboutus_model.dart';
import 'package:hdlive/screens/shared/loading.dart';
import 'package:hdlive/services/diamond_service/AboutService/about_Service.dart';

import 'TelentAppy_screen.dart';
import 'live_data.dart';

class EarningPage extends StatefulWidget {
  EarningPage({this.id,this.isVerify});
  String? id;
  String? isVerify;
  @override
  State<EarningPage> createState() => _EarningPageState();
}

class _EarningPageState extends State<EarningPage> {
  bool agreed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Telent Pointing',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 28,
              color: Colors.red.shade900),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'images/gif/doller.gif',
              width: 55,
              height: 55,
            ),
          )
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
      ),
      body: FutureBuilder<AboutusModel>(
          future: AboutSevice().aboutus(id: '5'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    HtmlWidget(
                      """${snapshot.data!.data![0].description}""",  // Your HTML content
                      textStyle: TextStyle(
                        fontSize: 18.0.sp,  // Using ScreenUtil for responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              widget.isVerify == "0"?
                              Checkbox(
                                activeColor: Colors.red,
                                value: agreed,
                                onChanged: (v) {
                                  print(v);
                                  setState(() {
                                    agreed = v!;
                                  });
                                },
                              ):Container(),
                              widget.isVerify == "0"?
                              Text(
                                "I Accept the above conditions.",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.grey[600]),
                              ):Container(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child:widget.isVerify == "0"? GestureDetector(
                            onTap: () {
                              if (agreed) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (
                                  context,
                                ) {
                                  return TeletApply();
                                }));
                              } else {}
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: agreed
                                      ? Colors.red.shade700
                                      : Colors.grey.shade500,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 40.h,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Center(
                                child: Text(
                                  ' Telent Apply',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 22.sp),
                                ),
                              ),
                            ),
                          ):Container(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (
                              context,
                            ) {
                              return LiveData(id: widget.id!);
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color:   widget.isVerify == "0"?Colors.grey.shade500:Colors.red.shade700,
                                borderRadius: BorderRadius.circular(20)),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Center(
                              child: Text(
                                ' Live Data',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                // child: CircularProgressIndicator(),
                child: Loading(),
              );
            }
          }),
    );
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 20),
    //       child: Row(
    //         children: [
    //           Checkbox(
    //             activeColor: Colors.red,
    //             value: agreed,
    //             onChanged: (v) {
    //               print(v);
    //               setState(() {
    //                 agreed = v;
    //               });
    //             },
    //           ),
    //           Text(
    //             "I Accept the above conditions.",
    //             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    //           ),
    //         ],
    //       ),
    //     ),
    //     SizedBox(
    //       height: 10,
    //     ),
    //     Center(
    //       child: GestureDetector(
    //         onTap: () {
    //           if (agreed) {
    //             Navigator.push(context, MaterialPageRoute(builder: (
    //               context,
    //             ) {
    //               return TeletApply();
    //             }));
    //           } else {}
    //         },
    //         child: Container(
    //           decoration: BoxDecoration(
    //               color:
    //                   agreed ? Colors.red.shade700 : Colors.grey.shade500,
    //               borderRadius: BorderRadius.circular(20)),
    //           height: 40,
    //           width: MediaQuery.of(context).size.width * 0.7,
    //           child: Center(
    //             child: Text(
    //               ' Telent Apply',
    //               style: TextStyle(
    //                   color: Colors.white,
    //                   fontWeight: FontWeight.normal,
    //                   fontSize: 22),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 5,
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         Navigator.push(context, MaterialPageRoute(builder: (
    //           context,
    //         ) {
    //           return LiveData();
    //         }));
    //       },
    //       child: Container(
    //         decoration: BoxDecoration(
    //             color: Colors.grey.shade500,
    //             borderRadius: BorderRadius.circular(20)),
    //         height: 40,
    //         width: MediaQuery.of(context).size.width * 0.5,
    //         child: Center(
    //           child: Text(
    //             ' Live Data',
    //             style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 22),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // ));
  }
}
