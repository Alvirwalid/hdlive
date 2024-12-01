// import 'package:flutter/material.dart';
// import 'package:hexagon/hexagon.dart';
// import 'package:hive/screens/agora/pages/call.dart';
// import 'package:hive/screens/live/current_live.dart';
// import 'package:hive/screens/peoples/nearby_people.dart';
// import 'package:hive/shared/constants.dart';
// import 'package:permission_handler/permission_handler.dart';
//
//
//
// class FilteredLanding extends StatefulWidget {
//   @override
//   _FilteredLandingState createState() => _FilteredLandingState();
// }
//
// class _FilteredLandingState extends State<FilteredLanding> {
//   double withSub = 95;
//   double withoutSub = 65;
//   int selected = 0;
//   bool subExists = true;
//   int selectedChip = 0;
//
//   bool live = false;
//   bool people= false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           backgroundColor: Colors.transparent,
//           child: Image.asset("images/icon-06.png")),
//       bottomNavigationBar: SizedBox(
//         height: 50,
//         child: BottomNavigationBar(
//           onTap: (idx){
//             if(idx==2){
//               Navigator.of(context).pushNamed("/go_live_landing");
//             }else if(idx==4){
//               Navigator.of(context).pushNamed("/profile");
//             }
//           },
//
//           iconSize: 10,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           items: [
//             BottomNavigationBarItem(
//               label: "",
//               icon: HexagonWidget.flat(
//                 cornerRadius: 10,
//                 height: 20,
//                 width: 45,
//                 color: Color(0xFFEFAA1F),
//                 padding: 4.0,
//                 child: Image(
//
//                   image: AssetImage("images/icon-01.png"),
//                 ),
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: "",
//               icon: HexagonWidget.flat(
//                 cornerRadius: 10,
//                 height: 20,
//                 width: 45,
//                 color: Color(0xFFF1F1F2),
//
//                 child: Image(
//
//                   image: AssetImage("images/icon-02.png"),
//                 ),
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: "",
//               icon: HexagonWidget.flat(
//                 cornerRadius: 10,
//                 height: 20,
//                 width: 45,
//                 color: Color(0xFFF1F1F2),
//                 padding: 4.0,
//                 child: Image(
//                   image: AssetImage("images/icon-05.png"),
//                 ),
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: "",
//               icon: HexagonWidget.flat(
//                 cornerRadius: 10,
//                 height: 20,
//                 width: 45,
//                 color: Color(0xFFF1F1F2),
//                 padding: 4.0,
//                 child: Image(
//                   image: AssetImage("images/icon-03.png"),
//                 ),
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: "",
//               icon: HexagonWidget.flat(
//                 cornerRadius: 10,
//                 height: 20,
//                 width: 45,
//                 color: Color(0xFFF1F1F2),
//
//                 child: Image(
//                   image: AssetImage("images/icon-04.png"),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               height: subExists ? withSub : withoutSub,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 40,
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               LabelText(
//                                 label: "NEARBY",
//                                 selected: selected == 0,
//                                 onTap: () {
//                                   setState(() {
//                                     live = false;
//                                     people= false;
//                                     if (selected != 0) selectedChip = 0;
//                                     selected = 0;
//                                     subExists = true;
//                                   });
//                                 },
//                               ),
//                               LabelText(
//                                 label: "POPULAR",
//                                 selected: selected == 1,
//                                 onTap: () {
//                                   setState(() {
//                                     live = false;
//                                     people= false;
//                                     selected = 1;
//                                     subExists = false;
//                                   });
//                                 },
//                               ),
//                               LabelText(
//                                 label: "PARTY",
//                                 selected: selected == 2,
//                                 onTap: () {
//                                   setState(() {
//                                     live = false;
//                                     people= false;
//                                     selected = 2;
//                                     subExists = false;
//                                   });
//                                 },
//                               ),
//                               LabelText(
//                                 label: "GAME",
//                                 selected: selected == 3,
//                                 onTap: () {
//                                   setState(() {
//                                     live = false;
//                                     people= false;
//                                     selected = 3;
//                                     subExists = false;
//                                   });
//                                 },
//                               ),
//                               LabelText(
//                                 label: "PK",
//                                 selected: selected == 4,
//                                 onTap: () {
//                                   setState(() {
//                                     live = false;
//                                     people= false;
//                                     selected = 4;
//                                     subExists = false;
//                                   });
//                                 },
//                               )
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           child: Row(
//                             children: [
//                               Image.asset("images/search-icon.png"),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Image.asset("images/notification-icon.png"),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   subExists
//                       ? SizedBox(
//                           height: 10,
//                         )
//                       : Container(),
//                   subExists
//                       ? Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               SelectedChip(
//                                 label: "RECOMMEND",
//                                 selected: selectedChip == 0,
//                                 onTap: () {
//                                   setState(() {
//                                     live = false;
//                                     people= false;
//                                     selectedChip = 0;
//                                   });
//                                 },
//                               ),
//                               SelectedChip(
//                                 label: "LIVE",
//                                 selected: selectedChip == 1,
//                                 onTap: () {
//                                   setState(() {
//                                     live= true;
//                                     people= false;
//                                     selectedChip = 1;
//                                   });
//                                 },
//                               ),
//                               SelectedChip(
//                                 label: "BAR",
//                                 selected: selectedChip == 2,
//                                 onTap: () {
//                                   setState(() {
//                                     live = false;
//                                     people= false;
//                                     selectedChip = 2;
//                                   });
//                                 },
//                               ),
//                               SelectedChip(
//                                 label: "PEOPLE",
//                                 selected: selectedChip == 3,
//                                 onTap: () {
//                                   setState(() {
//                                     live = false;
//                                     people= true;
//                                     selectedChip = 3;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         )
//                       : Container()
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: Color(0xFFF1F2F2),
//                 child: ListView(
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     subExists
//                         ? Container(
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 45,
//                                   padding: EdgeInsets.only(left: 30),
//                                   child: Center(
//                                     child: Stack(
//                                       children: <Widget>[
//                                         Positioned(
//                                           left: 0,
//                                           right: 180,
//                                           child: CircleAvatar(
//                                             radius: 20,
//                                             backgroundColor: Colors.white,
//                                             child: CircleAvatar(
//                                               radius: 18,
//                                               backgroundImage: AssetImage(
//                                                   'images/img-01.jpg'),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 30,
//                                           right: 150,
//                                           child: CircleAvatar(
//                                             radius: 20,
//                                             backgroundColor: Colors.white,
//                                             child: CircleAvatar(
//                                               radius: 18,
//                                               backgroundImage: AssetImage(
//                                                   'images/img-02.jpg'),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 60,
//                                           right: 120,
//                                           child: CircleAvatar(
//                                             radius: 20,
//                                             backgroundColor: Colors.white,
//                                             child: CircleAvatar(
//                                               radius: 18,
//                                               backgroundImage: AssetImage(
//                                                   'images/img-03.jpg'),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 90,
//                                           right: 90,
//                                           child: CircleAvatar(
//                                             radius: 20,
//                                             backgroundColor: Colors.white,
//                                             child: CircleAvatar(
//                                               radius: 18,
//                                               backgroundImage: AssetImage(
//                                                   'images/img-04.jpg'),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 120,
//                                           right: 60,
//                                           child: CircleAvatar(
//                                             radius: 20,
//                                             backgroundColor: Colors.white,
//                                             child: CircleAvatar(
//                                               radius: 18,
//                                               backgroundImage: AssetImage(
//                                                   'images/img-05.jpg'),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 150,
//                                           right: 30,
//                                           child: CircleAvatar(
//                                             radius: 20,
//                                             backgroundColor: Colors.white,
//                                             child: CircleAvatar(
//                                               radius: 18,
//                                               backgroundImage: AssetImage(
//                                                   'images/img-06.jpg'),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           left: 180,
//                                           right: 0,
//                                           child: CircleAvatar(
//                                             radius: 20,
//                                             backgroundColor: Colors.white,
//                                             child: CircleAvatar(
//                                               radius: 18,
//                                               backgroundImage: AssetImage(
//                                                   'images/img-07.jpg'),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Center(
//                                   child: Text(
//                                     "7 People nearby are interested in you",
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 11),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Center(
//                                     child: Container(
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.white),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 15, vertical: 3),
//                                     child: Text(
//                                       "Say Hello",
//                                       style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                   ),
//                                 )),
//                               ],
//                             ),
//                           )
//                         : Container(),
//                     SizedBox(
//                       height: 15,
//                     ),
//                   live?CurrentLive():people?NearbyPeople():Container()
//
//
//
//                   // Container(
//                   //   child: Column(
//                   //     children: [
//                   //       Container(
//                   //         child: Row(
//                   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //           children: [
//                   //             ImageBox(
//                   //               edge: EdgeInsets.only(left: 10),
//                   //               image: "img-08.jpg",
//                   //             ),
//                   //             ImageBox(
//                   //               edge: EdgeInsets.only(right: 10),
//                   //               image: "img-07.jpg",
//                   //             )
//                   //           ],
//                   //         ),
//                   //       ),
//                   //       SizedBox(
//                   //         height: 10,
//                   //       ),
//                   //       Container(
//                   //         child: Row(
//                   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //           children: [
//                   //             ImageBox(
//                   //               edge: EdgeInsets.only(left: 10),
//                   //               image: "img-06.jpg",
//                   //             ),
//                   //             ImageBox(
//                   //               edge: EdgeInsets.only(right: 10),
//                   //               image: "img-05.jpg",
//                   //             )
//                   //           ],
//                   //         ),
//                   //       ),
//                   //       SizedBox(
//                   //         height: 10,
//                   //       ),
//                   //       Container(
//                   //         child: Image(
//                   //           image: AssetImage("images/img-09.jpg"),
//                   //         ),
//                   //       ),
//                   //       SizedBox(
//                   //         height: 10,
//                   //       ),
//                   //       Container(
//                   //         child: Row(
//                   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //           children: [
//                   //             ImageBox(
//                   //               edge: EdgeInsets.only(left: 10),
//                   //               image: "img-04.jpg",
//                   //             ),
//                   //             ImageBox(
//                   //               edge: EdgeInsets.only(right: 10),
//                   //               image: "img-03.jpg",
//                   //             )
//                   //           ],
//                   //         ),
//                   //       ),
//                   //       SizedBox(
//                   //         height: 10,
//                   //       ),
//                   //       Container(
//                   //         child: Row(
//                   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //           children: [
//                   //             ImageBox(
//                   //               edge: EdgeInsets.only(left: 10),
//                   //               image: "img-02.jpg",
//                   //             ),
//                   //             ImageBox(
//                   //               edge: EdgeInsets.only(right: 10),
//                   //               image: "img-01.jpg",
//                   //             )
//                   //           ],
//                   //         ),
//                   //       ),
//                   //       SizedBox(
//                   //         height: 50,
//                   //       ),
//                   //     ],
//                   //   ),
//                   // )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//
//   }
//   Future<void> _handleCameraAndMic(Permission permission) async {
//     final status = await permission.request();
//     print(status);
//   }
// }
//
// class ImageBox extends StatelessWidget {
//   final EdgeInsetsGeometry edge;
//   final String image;
//   ImageBox({this.edge, this.image});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: edge,
//       child: Container(
//         height: MediaQuery.of(context).size.width / 2.2,
//         width: MediaQuery.of(context).size.width / 2.2,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Color(0xFFEFAA1F),
//           ),
//
//           image: DecorationImage(
//               fit: BoxFit.cover, image: AssetImage("images/$image")),
//           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//           color: Colors.redAccent,
//         ),
//       ),
//     );
//   }
// }
//
// class SelectedChip extends StatelessWidget {
//   final Function onTap;
//   final String label;
//   final bool selected;
//   SelectedChip({this.onTap, this.label, this.selected});
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//             border: Border.all(color:Color(0xFFE1233F) ),
//             borderRadius: BorderRadius.circular(12),
//             color: selected ? Color(0xFFE1233F) : Colors.white),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
//           child: Text(
//             label,
//             style: TextStyle(
//                 color: selected ? Colors.white : Colors.black,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LabelText extends StatelessWidget {
//   final Function onTap;
//   final String label;
//   final bool selected;
//
//   LabelText({this.onTap, this.label, this.selected});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 10),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Text(
//           label,
//           style: selected ? selectedLableStyle : lableStyle,
//         ),
//       ),
//     );
//   }
// }
