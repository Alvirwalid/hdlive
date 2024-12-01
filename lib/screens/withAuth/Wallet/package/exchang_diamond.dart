import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/convert_beansto_diamond_model.dart';
import 'package:hdlive_latest/models/exchangemodel.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/diamond_service/exdimond_service.dart';

class ExchangeDiamond extends StatefulWidget {
  ExchangeDiamond({this.userid});
  String? userid;

  @override
  State<ExchangeDiamond> createState() => _ExchangeDiamondState();
}

class _ExchangeDiamondState extends State<ExchangeDiamond> {
  @override
  void initState() {
    print("useriddd===${widget.userid}");
    ExdimondService().exchangedimond(id: widget.userid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Exdimondmodel>(
        future: ExdimondService().exchangedimond(id: widget.userid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                backgroundColor: Colors.white,
                title: Text(
                  "Current Beans",
                  style: TextStyle(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/coffe.png',
                          height: 40.h,
                          width: 40.w,
                        ),
                        Text(
                          "${snapshot.data?.data?.totalReceivedPearls??""}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: snapshot.data?.data?.converters?.length??0,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "images/dimond.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        Text(
                                          "${snapshot.data?.data?.converters?[index].valueInDiamond}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      ConvertBeanstoDiamond data =
                                          await ExdimondService()
                                              .BeansToDiamondConvert(
                                                  convertId:
                                                      "${snapshot.data?.data?.converters?[index].id}");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        // color: Colors.blue,
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.amber.shade900,
                                              Colors.amber
                                            ]),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${snapshot.data?.data?.converters?[index].requiredPearls}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown.shade900),
                                            ),
                                            Image.asset(
                                              "images/coffe.png",
                                              height: 30,
                                              width: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //leading: Image.asset("images/dimond.png"),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return Center(
                          // child: CircularProgressIndicator(),
                          child: Loading(),
                        );
                      }
                    }),
              ),
            );
          } else {
            return Center(
              // child: CircularProgressIndicator(),
              child: Loading(),
            );
          }
        });
  }
}
