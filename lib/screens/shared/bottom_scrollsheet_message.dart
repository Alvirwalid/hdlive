import 'package:flutter/material.dart';
import 'package:hdlive_latest/services/firestore_services.dart';

openModalBottomSheetForMessage(
    BuildContext context, String channelName, TextEditingController comment) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 30,
            right: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chat",
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.2),
                child: Divider(
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        // padding: EdgeInsets.only(
                        //     bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
                          autofocus: true,
                          controller: comment,
                          decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Chat with everyone",
                              hintStyle: TextStyle(fontSize: 13)),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            if (comment.text.isNotEmpty) {
                              FirestoreServices.insertNewComment(
                                  channelName, comment.text);
                              comment.text = "";
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
