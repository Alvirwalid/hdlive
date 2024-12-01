import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class MyDeliveryProgress extends StatefulWidget {

  const MyDeliveryProgress({this.sliderValue});
  final double? sliderValue;

  @override
  _MyDeliveryProgressState createState() => _MyDeliveryProgressState();
}

class _MyDeliveryProgressState extends State<MyDeliveryProgress> {

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      values: [widget.sliderValue!],
      max: 100,
      handlerWidth: 20,
      centeredOrigin: false,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      min: 0,
      trackBar: FlutterSliderTrackBar(
          activeTrackBar: BoxDecoration(color: Colors.red.shade900),activeTrackBarDraggable:false),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        setState(() {
          print('HDD === ${upperValue}');

        });
      },
    );
  }

  customHandler(IconData icon) {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Container(
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 0.05,
                blurRadius: 5,
                offset: Offset(0, 1))
          ],
        ),
      ),
    );
  }
}
