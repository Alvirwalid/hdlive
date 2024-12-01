import 'package:flutter/material.dart';

class SelectionTabNearby extends StatefulWidget {
  final Function? onTap;
  SelectionTabNearby({this.onTap});
  @override
  _SelectionTabNearbyState createState() => _SelectionTabNearbyState();
}

class _SelectionTabNearbyState extends State<SelectionTabNearby> {
  int selectedChip = 0;

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SelectedChip(
            label: "RECOMMEND",
            selected: selectedChip == 0,
            onTap: () {
              setState(() {
                widget.onTap!(0);
                selectedChip = 0;
              });
            },
          ),
          SelectedChip(
            label: "LIVE",
            selected: selectedChip == 1,
            onTap: () {
              setState(() {
                widget.onTap!(1);
                selectedChip = 1;
              });
            },
          ),
          SelectedChip(
            label: "BAR",
            selected: selectedChip == 2,
            onTap: () {
              setState(() {
                widget.onTap!(2);
                selectedChip = 2;
              });
            },
          ),
          SelectedChip(
            label: "PEOPLE",
            selected: selectedChip == 3,
            onTap: () {
              setState(() {
                widget.onTap!(3);
                selectedChip = 3;
              });
            },
          ),
        ],
      ),
    );
  }
}


class SelectedChip extends StatelessWidget {
  final Function? onTap;
  final String? label;
  final bool? selected;
  SelectedChip({this.onTap, this.label, this.selected});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!(),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color:Color(0xFFE1233F) ),
            borderRadius: BorderRadius.circular(12),
            color: selected! ? Color(0xFFE1233F) : Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
          child: Text(
            label??"",
            style: TextStyle(
                color: selected! ? Colors.white : Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
