import 'package:flutter/material.dart';



class NoImageFoundCoverPhoto extends StatefulWidget {
  final Function? onTap;
  NoImageFoundCoverPhoto({this.onTap});

  @override
  _NoImageFoundCoverPhotoState createState() => _NoImageFoundCoverPhotoState();
}

class _NoImageFoundCoverPhotoState extends State<NoImageFoundCoverPhoto> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFF33117), Color(0xFFAA2104)],
            ),
          ),
          child: Center(
            child: Text("UPLOAD",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          ),
        ),
       // UploadNewImage(
       //   onTap:widget.onTap,
       // )
      ],
    );
  }
}

class NoImageFoundProfilePic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFFF33117), Color(0xFFAA2104)],
        ),
      ),
      child: Center(
        child: Text("UPLOAD",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
    );
  }
}

class ProfilePicNotFound extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width*.15;
    return Image(
      width: width,
      image: AssetImage("images/user-large.png"),
    );
  }
}
