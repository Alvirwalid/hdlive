import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:hdlive_latest/models/checklevel_model.dart';
import 'package:hdlive_latest/models/leveldata_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/level_service.dart';

class Levelscreen extends StatefulWidget {
  const Levelscreen({Key? key}) : super(key: key);

  @override
  State<Levelscreen> createState() => _LevelscreenState();
}

class _LevelscreenState extends State<Levelscreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  var type = 'run';

  @override
  void initState() {
    LevelService().level();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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
          backgroundColor: Colors.white,
          title: Text(
            "Level",
            style: TextStyle(
              fontSize: 23,
              color: Colors.red,
            ),
          ),
        ),
        body: FutureBuilder<GetLevelModelbroad>(
          future: LevelService().getlevel(type).then((value) => value??GetLevelModelbroad()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double cal = 0.0;
              if (type.contains('run')) {
                print('runnig data ==${type}');
                var i = snapshot.data?.data?.neededXpForLevelup != null
                    ? snapshot.data!.data!.neededXpForLevelup! *
                                100 /
                                snapshot.data!.data!.yourtotalsentxp! !=
                            null
                        ? snapshot.data!.data!.yourtotalsentxp!
                        : 0
                    : 0;
                cal = i / 10000;
              } else {
                print('enter in else');
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 90, top: 8),
                          child: Container(
                              child: Text(
                            //'LV',
                            'Lv.${snapshot.data?.data?.nextLevel??""}',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )),
                        ),
                        Image.asset(
                          "images/livephotos.gif",
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Required Points to next level',
                            style:
                                TextStyle(fontSize: 10, color: Colors.black)),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(children: [
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              //'L.V',
                              'Lv.${snapshot.data?.data?.currentLevel??""}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            type.contains("run")
                                ? Text(
                                    //'EXP:',

                                    'Exp:${snapshot.data?.data?.yourtotalsentxp??""}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )
                                : Text(
                                    //'EXP:',
                                    'Exp:${snapshot.data?.data?.yourTotalRecieveXp??""}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: 150,
                        height: 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: cal / 100,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                            backgroundColor: Color(0xffD6D6D6),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          //'EXP,',
                          "EXP:${snapshot.data?.data?.neededXpForLevelup??""}",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                  ),
                  // Container(
                  //   height: 20,
                  //   color: Colors.white,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(bottom: 5),
                  //         child: Text(
                  //           //'request point',
                  //           "Required Points to next level ${snapshot.data.data.neededXpForLevelup}",
                  //           style: TextStyle(color: Colors.black, fontSize: 12),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    flex: 1,
                    child: TabBar(
                      controller: _tabController,
                      onTap: (v) {
                        print('index of tabs  ==== $v');
                        setState(() {
                          if (v == 0) {
                            type = 'run';
                          } else {
                            type = 'brod';
                          }
                        });
                        setState(() {});
                      },
                      tabs: [
                        Tab(
                          child: Text("User Level"),
                        ),
                        Tab(
                          child: Text("Broadcasting Level"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        FutureBuilder<Leveldatamodel>(
                          future: LevelService().runniglevel(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.data?.length??0,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4.0,
                                        childAspectRatio: 4 / 4,
                                        mainAxisSpacing: 4.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          // color: Color(int.parse("${snapshot.data.data[index].colorCode.replaceFirst("#", "0xff")}")),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  backgroundImage: NetworkImage(
                                                      "${snapshot.data?.data?[index].icon??""}"),
                                                  radius: 15,
                                                ),
                                              ),
                                            ),
                                            Text(
                                                '${snapshot.data?.data?[index].name??""}',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Center(
                                                child: Text(
                                                  'Exp: ${snapshot.data?.data?[index].xpNeeded??""}',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25.0),
                                              child: Container(
                                                height: 25,
                                                width: 150,
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.centerRight,
                                                      end: Alignment.centerLeft,
                                                      colors: [
                                                        Color(int.parse(
                                                            "${snapshot.data?.data?[index].colorCode?.replaceFirst("#", "0xff")}")),
                                                        Colors.black87
                                                      ],
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 12,
                                                      backgroundImage:
                                                          NetworkImage(snapshot.data?.data?[index].icon??""),
                                                    ),
                                                    Spacer(),
                                                    // avater,
                                                    Text(
                                                      "LV.${snapshot.data?.data?[index].levelName}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                // child: CircularProgressIndicator(),
                                child: Loading(),
                              );
                            }
                          },
                        ),
                        FutureBuilder<Leveldatamodel>(
                          future: LevelService().broadLevel().then((value) => value??Leveldatamodel()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.data?.length??0,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4.0,
                                        childAspectRatio: 4 / 4,
                                        mainAxisSpacing: 4.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          // color: Color(int.parse("${snapshot.data.data[index].colorCode.replaceFirst("#", "0xff")}")),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  backgroundImage: NetworkImage(
                                                      "${snapshot.data?.data?[index].icon??""}"),
                                                  radius: 15,
                                                ),
                                              ),
                                            ),
                                            Text(
                                                '${snapshot.data?.data?[index].name??""}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                    fontSize: 10)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0),
                                              child: Center(
                                                child: Text(
                                                  'Exp: ${snapshot.data?.data?[index].xpNeeded??""}',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25.0),
                                              child: Container(
                                                height: 25,
                                                width: 150,
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.centerRight,
                                                      end: Alignment.centerLeft,
                                                      colors: [
                                                        Color(int.parse(
                                                            "${snapshot.data?.data?[index].colorCode?.replaceFirst("#", "0xff")}")),
                                                        Colors.black87
                                                      ],
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 12,
                                                      backgroundImage:
                                                          NetworkImage(snapshot.data?.data?[index].icon??""),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "BL.${snapshot.data?.data?[index].levelName??""}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Loading(),
                                // child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              print("whyy////");
              return Loading();
            }
          },
        )
        // } else {
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        );
  }
}
