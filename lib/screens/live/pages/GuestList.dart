
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/models/viewer_model.dart';
import 'package:hdlive_latest/screens/shared/initIcon_container.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/services/firestore_services.dart';

class GuestList extends StatefulWidget {
  final String? channelName;
  final bool? broadcaster;
  final Function? callEnd;
  bool? isVideo = false;

  GuestList({this.channelName, this.broadcaster,this.callEnd,this.isVideo});

  @override
  _GuestListState createState() => _GuestListState();
}

class _GuestListState extends State<GuestList> {
  bool isData = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreServices().getVideoGuestViewer(widget.channelName??""),
        builder: (context,snapshot){
          if (!snapshot.hasData && !isData) {
            print("Empty View");
          return Container();
          }
          List<ViewerModel> viewers = snapshot.data as List<ViewerModel>;
          return Container(
            child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                shrinkWrap: false,
                itemCount: viewers.length,
                itemBuilder: (BuildContext context, int index) {
                  return listItem(context, viewers[index]);
                },
          ));
        },
      );
  }

  Widget
  listItem(BuildContext context, ViewerModel viewer) {
    return Container(
      child: Row(
        children: <Widget>[
          viewer.photoUrl != null
              ? CircleAvatar(
            radius: 20,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: HexagonProfilePicNetworkImage(
                  url: viewer.photoUrl??"",
                )),
          ) : InitIconContainer(radius: 40, text: viewer.name??"",),
          SizedBox(width: 10,),
          Expanded(child:  Text(viewer?.name??"", maxLines:1, style: TextStyle(fontSize: 14),),),
          widget.broadcaster!? Wrap(
            spacing: 5,
            children: [
              !viewer.isMute!?GestureDetector(
                onTap: (){
                  if(widget.broadcaster!) {
                    FirestoreServices.broadcasterRightUserMuteUnmute(widget.channelName??"", true, viewer.uid??"");
                  }
                  Navigator.pop(context);
                },
                child:  CircleAvatar(radius: (20),
                  backgroundColor: Colors.red,
                  child: ClipRRect(
                    child: Icon(
                      Icons.mic_none_outlined,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  ),
                ),
              ) :GestureDetector(onTap:(){
                FirestoreServices.broadcasterRightUserMuteUnmute(widget.channelName??"",false,viewer.uid??"");
                Navigator.pop(context);
              }, child:CircleAvatar(radius: (20),
                backgroundColor: Colors.red,
                child: ClipRRect(
                  child: Icon(Icons.mic_off_rounded, color: Colors.white,size: 18.0),),),),
              /*      SizedBox(height:18,width: 10,),*/
              widget.isVideo! ? GestureDetector(
                onTap:(){
                  if(widget.broadcaster!) {
                    if(viewer.isCamera!) {
                      viewer.isCamera = !viewer.isCamera!;
                      FirestoreServices.broadcasterRightUserVideoMuteUnmute(
                          widget.channelName??"", viewer.isCamera!, viewer.uid??"");
                      Navigator.pop(context);
                    }else{
                      Fluttertoast.showToast(msg: "Sorry! You can't on camera of Viewers.");
                    }
                  }else{
                    if(!viewer.broadcaster_video_mute!) {
                      viewer.isCamera = !viewer.isCamera!;
                      FirestoreServices.joinUserStream(
                          widget.channelName??"", viewer.isCamera!, viewer.uid??"");
                      Navigator.pop(context);
                    }else{
                      Fluttertoast.showToast(msg: "Sorry! You can't unmute video to yourself now");
                    }
                  }

                },
                child:CircleAvatar(radius: (20),
                  backgroundColor: Colors.red,
                  child: ClipRRect(child: Icon(!viewer.isCamera!? Icons.video_call: Icons.videocam_off_rounded, color: Colors.white,size: 18.0),),),) :Container(),
              /* widget.isVideo ? SizedBox(width: 10,) :Container(),*/
              GestureDetector(
                onTap:(){
                  FirestoreServices.joinUserRemove(widget.channelName??"",viewer.uid??"");
                  // widget.callEnd();
                  Navigator.pop(context);
                },
                child:CircleAvatar(radius: (20),
                  backgroundColor: Colors.red,
                  child: ClipRRect(child: Icon(Icons.call_end, color: Colors.white,size: 18.0),),),),
            ],
          ):Container(height: 15, width: 30,),
        ],
      ),
    );
  }
}
