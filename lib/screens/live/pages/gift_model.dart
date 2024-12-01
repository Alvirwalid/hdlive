import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive/models/Gifts_model.dart';
import 'package:hdlive/models/current_user_model.dart';
import 'package:hdlive/models/gift_category.dart';
import 'package:hdlive/models/live_model.dart';
import 'package:hdlive/models/viewer_model.dart';
import 'package:hdlive/screens/shared/initIcon_container.dart';
import 'package:hdlive/screens/shared/loading.dart';
import 'package:hdlive/screens/shared/network_image.dart';
import 'package:hdlive/services/daimond_send_service.dart';
import 'package:hdlive/services/firestore_services.dart';
import 'package:hdlive/services/gift_service.dart';
import 'package:hdlive/services/live_service/live_service.dart';
import 'package:hdlive/services/token_manager_services.dart';
import 'package:video_player/video_player.dart';

class Gift_Model extends StatefulWidget {
  Gift_Model({this.channelName,
    this.user,
    this.broadcaster = false,
    this.viewer,
    this.broadcastUser});

  final CurrentUserModel? user;
  final LiveModel? broadcastUser;

  final String? channelName;
  final bool? broadcaster;
  final ViewerModel? viewer;

  @override
  _Gift_ModelState createState() => _Gift_ModelState();
}

class _Gift_ModelState extends State<Gift_Model> {
  Giftsmodel? giftData;
  GiftCategory? giftCategory;
  List<Tab>? giftTabs = [];
  int? ind;
  TextEditingController agencyid = TextEditingController();
  String itemPrice = "0";

  GiftCategorys() async {
    await LiveService().giftCategory().then((value) {
      giftCategory = value;
      for (var i = 0; i < value.data!.length; i++) {
        print("lengthhh=== ${value.data!.length}");
        giftTabs!.add(Tab(
          text: value.data![i].name,
        ));
      }
      Gift(giftCategory!.data![0].categoryId);
    });
  }

  Gift(catid) async {
    setState(() {
      isLoad = true;
    });

    giftData = await LiveService()
        .fetchallGift(catid: catid, userid: widget.user?.userId);
    print('Gifted Data === ${giftData?.data?.length}');
    setState(() {
      isLoad = false;
    });
  }

  bool isLoad = false;
  bool userVisible = false;

  @override
  void initState() {
    GiftCategorys();
    super.initState();
  }

  String? _pickingType;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: .4,
        minChildSize: .4,
        maxChildSize: .4,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                  height: 270.h,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r))),
                  child: giftCategory != null
                      ? DefaultTabController(
                    length: giftCategory?.data?.length??0,
                    child: StatefulBuilder(builder: (context, setState) {
                      var select2 = false;
                      //  print("viewer photo${viewer.photoUrl}");
                      return Column(
                        children: [
                          Container(
                            height: 50,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                /*  Container(
                                    child:
                                    StreamBuilder<List<ViewerModel>>(
                                      stream: FirestoreServices()
                                          .getAllViewersList(
                                          widget.channelName,
                                          widget.user.userId),
                                      builder: (context, snapshot) {
                                        List<Widget> people = [];
                                        if (snapshot.hasData) {
                                          var lenth = snapshot.data.length;
                                          if (lenth > 0) {
                                            if (people.isNotEmpty) {
                                              people.clear();
                                              for (var i = 0; i < lenth; i++) {
                                                ViewerModel v = snapshot.data[i];
                                                people.add(GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    child: snapshot.data[i].photoUrl != null
                                                        ? CircleAvatar(
                                                      backgroundImage:
                                                      NetworkImage(snapshot.data[i].photoUrl,),
                                                      radius: 14,
                                                    )
                                                        : CircleAvatar(
                                                      radius: 14,
                                                      backgroundImage:
                                                      AssetImage(
                                                          "images/profile.jpeg"),
                                                    ),
                                                  ),
                                                ));
                                              }
                                            } else {
                                              print("else part ===");
                                              for (var i = 0;
                                              i < lenth;
                                              i++) {
                                                ViewerModel v =
                                                snapshot.data[i];
                                                widget.brodcast != null
                                                    ? people
                                                    .add(CircleAvatar(
                                                  radius: 13,
                                                  backgroundImage:
                                                  NetworkImage(widget
                                                      .brodcast
                                                      .photoUrl),
                                                ))
                                                    : CircleAvatar(
                                                  radius: 13,
                                                  backgroundImage:
                                                  AssetImage(
                                                      "images/profile.jpeg"),
                                                );
                                                if (snapshot
                                                    .data[i].uid !=
                                                    widget.user.userId) {
                                                  people.add(
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(width: 2, color: select2 ? Colors.red : Colors.transparent)),
                                                          child: snapshot.data[i].photoUrl != null ? CircleAvatar(
                                                            radius: 13,
                                                            backgroundImage: NetworkImage(snapshot.data[i].photoUrl,),
                                                          ) : CircleAvatar(radius: 13, backgroundImage:
                                                            AssetImage("images/profile.jpeg"),
                                                          ),
                                                        ),
                                                      ));
                                                } else {}
                                              }
                                            }
                                          }
                                        } else {}

                                        return Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // widget.onView();
                                                    },
                                                    child: Container(
                                                      child: Wrap(
                                                        children: people,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              )
                                            ]);
                                      },
                                    ),
                                  ),*/
                                  widget.viewer != null?
                                  CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(widget.viewer?.photoUrl??"",),
                                    radius: 14,
                                  ):Container(),
                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('live_streams')
                                        .doc(widget.channelName)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                                      if (snapshot.hasData && snapshot.data!.exists) {
                                        return  snapshot.data!.get("photoUrl") != "" || snapshot.data!.get("gender") != ""
                                            ? Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: snapshot.data!.get("gender") == "Male"
                                                  ? Color(0xff3a9bdc)
                                                  : Color(0xfffe6f5e)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 14,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(13),
                                                      child:
                                                      HexagonProfilePicNetworkImage(url: snapshot.data!.get("photoUrl"))),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Color(0x582AF900),
                                                      borderRadius: BorderRadius.circular(25)),
                                                  child:  Text(
                                                    "Host",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 10.sp),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                            : InitIconContainer(radius: 13, text: snapshot.data!.get("name"),);
                                      }else{
                                        return Container(
                                          child: SizedBox(height: 10,),
                                        );
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBar(
                              labelStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp),
                              unselectedLabelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp),
                              indicatorColor: Colors.red,
                              labelColor: Colors.red,
                              unselectedLabelColor: Colors.white,
                              tabs: giftTabs!,
                              onTap: (val) async {
                                setState(() {
                                  isLoad = true;
                                });
                                print(
                                    "categoryid==${giftCategory?.data?[val]
                                        .categoryId}");
                                await Gift(
                                    giftCategory?.data?[val].categoryId);
                                setState(() {
                                  isLoad = false;
                                });
                              },
                            ),
                          ),
                          giftData == null
                              ? Center(child: Loading())
                              : isLoad
                              ? Center(
                            child: Loading(),
                          )
                              : Container(
                            height: 130.h,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: TabBarView(
                                children: List.generate(
                                    giftCategory?.data?.length??0, (index) =>
                                    Container(height: 100,color: Colors.black, width: MediaQuery.of(context).size.width, child:
                                          GridView.builder(scrollDirection: Axis.horizontal, itemCount: giftData?.data?.length??0,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4 / 4, crossAxisSpacing: 4, mainAxisSpacing: 4),
                                              itemBuilder: (context, index) {
                                                var select = false;
                                                return Padding(padding:
                                                  const EdgeInsets.all(2.0),
                                                  child: Container(height: MediaQuery.of(context).size.height,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: ind == index ? Colors.red.shade900 : Colors.transparent, width: 1)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          select = !select;
                                                          //  GiftService().sendGift(giftData.data[index].value);
                                                          //  GiftService().sendGift(giftData.data[index].value);
                                                          //  GiftService().sendGift(giftData.data[index].value);
                                                          ind = index;
                                                          print("Select Item Price > ${giftData?.data?[index].value}");
                                                          itemPrice = giftData?.data?[index].value??"";
                                                        });
                                                      },
                                                      child:
                                                      Column(
                                                        children: [
                                                          Image.network(select ? (giftData!.data![index].image ?? '') : (giftData!.data![index].image ?? ''), height: 28.h, width: 28.w,),
                                                          Text(
                                                            "${giftData?.data?[index].giftName}",
                                                            maxLines: 1,
                                                            style: TextStyle(color: Colors.white,
                                                                fontSize: 10.sp,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 0),
                                                           child: Text("${giftData?.data?[index].value}", style: TextStyle(color: Colors.grey, fontSize: 11.sp, fontWeight: FontWeight.bold),),
                                                            // child: Row(children: [Image.asset('images/dimond.png', height: 10, width: 5,),
                                                            //     Text("${giftData.data[index].value}", style: TextStyle(color: Colors.grey, fontSize: 11.sp, fontWeight: FontWeight.bold),)
                                                            // ],
                                                            // ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ))),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 12.w,
                              ),
                              Image.asset("images/dimond.png",
                                  height: 20, width: 20),
                              Container(
                                  child: widget.user?.diamondcount != null
                                      ? Text(
                                    "${widget.user?.diamondcount}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight:
                                        FontWeight.w500),
                                  )
                                      : Text(
                                    '0.0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp),
                                  )
                                // : Text(
                                //     '0.0',
                                //     style: TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 20.sp,
                                //         fontWeight:
                                //             FontWeight.w500),
                                //   )
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                              widget.broadcaster!
                                  ? Container()
                                  : Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Send  ",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Colors.grey)),
                                      Container(
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.2,
                                        child: Text(
                                            "${widget.viewer != null? widget.viewer?.name : widget.broadcastUser?.name}",
                                            style: TextStyle(
                                                overflow:
                                                TextOverflow
                                                    .ellipsis,
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              widget.broadcaster!
                                  ? Spacer(
                                flex: 7,
                              )
                                  : SizedBox(
                                width: 20,
                              ),
                              widget.broadcaster!
                                  ? Row(
                                children: [
                                  Text('1',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15)),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                                  : Row(
                                children: [
                                  Text('1',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15)),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  var i =  widget.user?.diamondcount;
                                  if(i!.contains("K")){
                                    i = i.replaceAll("K", "");
                                    i = (double.parse(i) * 1000).toString() ;
                                    print("User Diamond == $i");
                                  }
                                  print(widget.broadcastUser);
                                  // Navigator.pop(context);
                                  // FirestoreServices.sendGiftNew(widget.channelName,giftData.data[ind].image);

                                  if(itemPrice == "0"){
                                    // Navigator.pop(context);
                                    Fluttertoast.showToast(msg: 'Please select one gift.');
                                  }
                                  else if(widget.viewer == null && widget.broadcaster!){
                                    // FirestoreServices.sendGiftNew(widget.channelName,widget.brodcast.userId,giftData.data[ind].image);
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(msg: "Sorry! You can't send gifts to yourself");
                                  }
                                  else if(widget.viewer != null &&  widget.user?.userId == widget.viewer?.uid){
                                    // FirestoreServices.sendGiftNew(widget.channelName,widget.brodcast.userId,giftData.data[ind].image);
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(msg: "Sorry! You can't send gifts to yourself");

                                  }
                                  else if(double.parse(i.replaceAll(",", "")) < double.parse(itemPrice.replaceAll(",", ""))){
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(msg: 'Your balance is not enough for send to gifts.');
                                  }else {
                                    setState(() {
                                      isLoad = true;
                                    });
                                    bool i = await DaimondSendService().sendDiamond(widget.viewer != null ?widget.viewer?.uid??"":widget.broadcastUser?.userId??"", itemPrice);

                                   /* setState(() {
                                      isLoad = false;
                                    });*/
                                    if(i){
                                      print("Successfully Sent!");
                                      // GiftService()
                                      //     .sendGift(giftData.data[indquery document length].value
                                      //     .replaceAll(',', ''))
                                      //     .then((value) {});

                                      String giftMessage = "";
                                      if(widget.viewer != null){
                                        giftMessage = "sent to ${widget.viewer?.name} 1 ${giftData?.data?[ind!].giftName}";
                                      }else{
                                        giftMessage = "I sent to host 1 ${giftData?.data?[ind!].giftName}";
                                      }

                                      FirestoreServices.sendGiftNew(widget.channelName??"",giftData?.data?[ind!].image??"");
                                      FirestoreServices.sendGiftMessage(widget.channelName??"",giftMessage,giftData?.data?[ind!].image??"");

                                      Navigator.pop(context);
                                    }else {
                                      Fluttertoast.showToast(msg: 'Please try again later.');
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(right: 20.h.w),
                                  child:InkWell(
                                    child: Container(
                                        width: 50.w,
                                        height: 30.h,
                                        // height: 20,

                                        color: Colors.red.shade900,
                                        child: Center(
                                          child: Text(
                                            'Send',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight:
                                                    FontWeight.bold),
                                          ),
                                        )),
                               /*     onTap: () async {
                                     var i =  widget.user.diamondcount;
                                     if(i.contains("K")){
                                       i = i.replaceAll("K", "");
                                       i = (double.parse(i) * 1000).toString() ;
                                       print("User Diamond == $i");
                                     }

                                     if(itemPrice == "0"){
                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                         content: Text("Please select one gift."),
                                       ));
                                     }else if(widget.user.userId == widget.brodcast.userId){
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("Sorry! You can't send gifts to yourself"),
                                        ));
                                      }else if(double.parse(i) < double.parse(itemPrice.replaceAll(",", ""))){
                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                         content: Text("Your balance is not enough for send to gifts "),
                                       ));
                                     }else {
                                        setState(() {
                                          isLoad = true;
                                        });
                                        bool i = await  DaimondSendService().sendDiamond(widget.viewer.uid, itemPrice);
                                        setState(() {
                                          isLoad = false;
                                        });
                                        if(i){
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text("Successfully Sent!"),
                                          ));
                                          print("Successfully Sent!");
                                        }else {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text("Please try again later."),
                                          ));
                                        }
                                      }
                                    },*/
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                      );
                    }),
                  )
                      : Center(
                    child: Loading(),
                    // child: CircularProgressIndicator(),
                  )),
            ],
          );
        },
      );
    });
  }

}
