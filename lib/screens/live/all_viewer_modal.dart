import 'package:flutter/material.dart';
import 'package:hdlive/screens/live/pages/allviewers_list.dart';
openAllViewerModal(BuildContext context, String channelName, userid, broadcastUser, broadcaster,isVideo) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;
      return Container(
        child: Container(
            height: height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: AllViewerList(
              channelName: channelName,
              userid: userid,
              broadcastUser: broadcastUser,
                 broadcaster : broadcaster,
                isVideo:isVideo
            )),
      );
    },
  );
}
