
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  double size;
  Loading({Key? key,this.size= 50.0}) : super(key: key);
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with  SingleTickerProviderStateMixin{
   AnimationController? _animationController;

    @override
  void initState() {
      _animationController =
      new AnimationController(vsync: this, duration: Duration(seconds: 1));
      _animationController!.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {

     return Container(
       color: Colors.transparent,
       child: Center(
         // child: SpinKitPumpingHeart(
         //
         // ),
         child:FadeTransition(
         opacity: _animationController!,
         child: Image(
         //  iconColor: Color(0xFFEFAA1F),
           width: widget.size,
           height: widget.size,
           image: AssetImage("images/loader.png"),
         ),),
       ),
     );
   }
 }

floatingLoading(context){
  return showDialog(context: context,builder: (context){
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Loading(),
    );
  });
}