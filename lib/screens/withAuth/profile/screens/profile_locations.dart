import 'package:flutter/material.dart';

class ProfileLocation extends StatelessWidget {
  final String? location;
  ProfileLocation({this.location});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined),
          Text(
            location ?? "No Location Found",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          )
        ],
      ),
    );
  }
}
