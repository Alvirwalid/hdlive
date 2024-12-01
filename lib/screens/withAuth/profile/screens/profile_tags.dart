import 'package:flutter/material.dart';
import 'package:hdlive_latest/screens/shared/raised_gradient_button.dart';


class ProfileTags extends StatelessWidget {
  final List<String>? tags;
  ProfileTags({this.tags});
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < tags!.length; i++) {
      list.add(Padding(
        padding: EdgeInsets.only(top: 8),
        child: Container(

          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(
              tags![i],
              style: TextStyle(
                  color:Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ));
      list.add(SizedBox(
        width: 5,
      ));
    }
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "TAG",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            list.length > 0
                ? Wrap(
              children: list,
            )
                : Text(
              "No Tags Found",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            )
          ],
        ));
  }
}

class TagWithoutLabel extends StatefulWidget {
  final List<String>? tags;
  final Function? onAdd;
  final List<String>? allTags;
  TagWithoutLabel({this.tags, this.onAdd, this.allTags});

  @override
  _TagWithoutLabelState createState() => _TagWithoutLabelState();
}

class _TagWithoutLabelState extends State<TagWithoutLabel> {
  List<String> tags = [];
  @override
  void initState() {
    tags = widget.tags!;
    super.initState();
  }

  getallChips(StateSetter updateState) {

    List<Widget> chips = [];
    for (var i = 0; i < widget.allTags!.length; i++) {
      chips.add(GestureDetector(
        onTap: () {
          if (tags.contains(widget.allTags?[i])) {
            updateState(() {
              tags.remove(widget.allTags?[i]);
            });
          } else {
            updateState(() {
              tags.add(widget.allTags![i]);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
                color: tags.contains(widget.allTags?[i])
                    ? Color(0xFFCC2206)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(30)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: Text(
                widget.allTags?[i]??"",
                style: TextStyle(
                    color: tags.contains(widget.allTags![i])
                        ? Colors.white
                        : Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ));
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < tags.length; i++) {
      list.add(Padding(
        padding: EdgeInsets.only(top: 8),
        child: Container(

          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(
              tags[i],
              style: TextStyle(
                  color:Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ));
      list.add(SizedBox(
        width: 5,
      ));
    }
    list.add(GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return StatefulBuilder(builder: (context, state) {
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: .6,
                  minChildSize: .6,
                  maxChildSize: .6,
                  builder: (context, scrollController) {

                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            child: Center(
                                child: Text(
                                  "Choose your personality tags",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Expanded(
                              child: Container(
                                child: ListView(
                                  controller: scrollController,
                                  children: [
                                    Container(

                                      child: Wrap(
                                        children: getallChips(state),
                                      ),
                                      padding: EdgeInsets.all(10),
                                    )
                                  ],
                                ),
                              )),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: RaisedGradientButton(
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color(0xFFF33117),
                                      Color(0xFFAA2104)
                                    ],
                                  ),
                                  onPressed: () {

                                    widget.onAdd!(tags);
                                  }),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              });
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Icon(

          Icons.add_circle_outline_sharp,
          size: 17,
          color: Colors.red,
        ),
      ),
    ));
    return Container(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            list.length > 0
                ? Wrap(
              children: list,
            )
                : Text(
              "No Tags Found",
              style: TextStyle(color: Colors.grey[500], fontSize: 17),
            )
          ],
        ));
  }
}
