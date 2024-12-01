import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hdlive_latest/models/Transation_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/transcation_history_service.dart';

class DimondHistory extends StatefulWidget {
  DimondHistory({this.userid});
  String? userid;

  @override
  State<DimondHistory> createState() => _DimondHistoryState();
}

class _DimondHistoryState extends State<DimondHistory> {
  @override
  void initState() {
    TranscationService().diamomndTrascation(widget.userid??"");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          " History",
          style: TextStyle(color: Colors.red.shade900),
        ),
      ),
      body: FutureBuilder<TransactionModel>(
          future: TranscationService().diamomndTrascation(widget.userid??"").then((value) => value??TransactionModel()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            "${snapshot.data?.data?.transactions?[0].title}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Container(
                              height: MediaQuery.of(context).size.height,
                              width: 160,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                          height: 20,
                                          width: 20,
                                          child:
                                              Image.asset("images/dimond.png")),
                                    ),
                                    Text(
                                      "${snapshot?.data?.data?.transactions?[index].value}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                          //  leading: Image.asset("images/dimond.png"),
                        ),
                      ],
                    );
                  });
            } else {
              return Center(
                // child: CircularProgressIndicator(),
                child: Loading(),
              );
            }
          }),
    );
  }
}
