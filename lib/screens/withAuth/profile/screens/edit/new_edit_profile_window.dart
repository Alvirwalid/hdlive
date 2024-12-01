import 'dart:async';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hdlive_latest/models/country_model.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/network_image.dart';
import 'package:hdlive_latest/screens/verifications/country_select.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/edit/country_preference.dart';
import 'package:hdlive_latest/screens/withAuth/profile/screens/profile_tags.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:image_cropper/image_cropper.dart';

class NewEditProfileWindow extends StatefulWidget {
  CurrentUserModel? user;
  final Function? onDispose;

  NewEditProfileWindow({this.user, this.onDispose});

  @override
  _NewEditProfileWindowState createState() => _NewEditProfileWindowState();
}

class _NewEditProfileWindowState extends State<NewEditProfileWindow> {
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController dateofbirth = TextEditingController();

  int selectedGender = 2;
  List<String> options = [
    "Male",
    "Female",
    "Other",
  ];

  List<File> uploadedCovers = [File(''), File(''), File(''), File(''), File('')];

  ProfileUpdateServices ser = ProfileUpdateServices();
  File? _profilePic;

  bool edited = false;

  String? countryImage;
  List<int> preferenceIds = [];
  List<String> preferenceNames = [];

  List<String> allTags = [];
  List<String> myTags = [];
  List<String> allTagsId = [];

  File? _file;


  @override
  void initState() {
    getPreferenceCountries();
    // getAllTags();
    getuser();
    user = widget.user??CurrentUserModel();

    super.initState();
  }
  getuser() async {
    widget.user = await TokenManagerServices().getData();
  }

  getPreferenceCountries() {
    List<int> tempIds = [];
    List<String> tempNames = [];
    // if (widget.user.preferenceCountries.length > 0) {
    //   for (var i = 0; i < widget.user.preferenceCountries.length; i++) {
    //     tempIds.add(int.parse(widget.user.preferenceCountries[i].id));
    //     tempNames.add(widget.user.preferenceCountries[i].name);
    //   }
    // }
    setState(() {
      preferenceIds = tempIds;
      preferenceNames = tempNames;
    });
  }

  //
  // getAllTags() async {
  //   if (widget.user.tags.length > 0) {
  //     for (var i = 0; i < widget.user.tags.length; i++) {
  //       myTags.add(widget.user.tags[i].name);
  //     }
  //   }
  //   Map<String, dynamic> tempTags = await TagsServices.getAllTags();
  //
  //   if (this.mounted) {
  //     setState(() {
  //       allTags = tempTags['tags'];
  //       allTagsId = tempTags['ids'];
  //     });
  //   }
  // }

  @override
  void dispose() {
    widget.onDispose!();
    _file?.delete();
    name.dispose();
    bio.dispose();
    dateofbirth.dispose();
    super.dispose();
  }

  changeCoverPhoto(index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result != null) {
      File file1 = File(result.files[0].path??"");
      if (file1 != null) {
        File croppedFile = (await CropImage(file1)) as File;
        setState(() {
          file1 = croppedFile;
        });

        // setState(() {
        //   _profilePic = file1;
        // });
        //  ser.updateProfilePic(file1, user);

        setState(() {
          uploadedCovers[index] = file1;
        });
        ser.updateCoverPics(
          file1,
          index,
          widget.user?.userId??"",
        );
      } else {
        // User canceled the picker
      }
    }
  }

  // Widget _buildCropImage() {
  //   return Container(
  //     color: Colors.black,
  //     padding: const EdgeInsets.all(20.0),
  //     child: Crop(
  //       key: cropKey,
  //       image: Image.file(imageFile),
  //       aspectRatio: 4.0 / 3.0,
  //     ),
  //   );
  // }
  Future<Future<File?>> CropImage(File image) async {
    Future<File?> croppedFile = ImageCropper().cropImage(
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    return croppedFile;
  }

  changeProfilePic(CurrentUserModel user) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path??"");
      if (file != null) {
        File croppedFile = (await CropImage(file)) as File;
        setState(() {
          file = croppedFile;
        });

        setState(() {
          _profilePic = file;
        });
        ser.updateProfilePic(file, user);
      } else {
        // User canceled the picker
      }
    }
  }

  List<Widget> getCountryPreferenceWrapChildren() {
    List<Widget> list = [];
    if (preferenceIds.length > 0) {
      for (var i = 0; i < preferenceIds.length; i++) {
        list.add(Container(
          //  color: Colors.red,
          decoration: BoxDecoration(
              color: Color(0xFFCC2206), borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(
              preferenceNames[i],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));

        list.add(SizedBox(
          width: 5,
        ));
      }
    }

    return list;
  }

  CurrentUserModel? user;

  Widget _myRadioButton({String? title, int? value, Function? onChanged}) {
    return RadioListTile(
      dense: true,
      activeColor: Colors.red,
      value: value,
      groupValue: user?.gender == "Male"
          ? 0
          : user?.gender == "Female"
              ? 1
              : 2,
      onChanged: onChanged!(),
      title: Text(
        title??"",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    dateofbirth.text = user?.dob??"";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              // List<String> myTagIds = [];
              // for (var i = 0; i < allTags.length; i++) {
              //   print("all tags ==== ${allTags.length}");
              //   if (myTags.contains(allTags[i])) {
              //     myTagIds.add(allTagsId[i]);
              //   }
              // }

              floatingLoading(context);
              var re;
              await ser.updateProfileInfos(
                user!.userId!.isNotEmpty ? user?.userId??"" : widget.user?.userId??"",
                user!.userId!.isNotEmpty ? user?.userId??"" : widget.user?.userId??"",
                user?.deviceId != null ? user?.deviceId??"" : widget.user?.deviceId??"",
                user?.nickName != null ? user?.nickName??"" : widget.user?.nickName??"",
                user?.name != null ? user?.name??"" : widget.user?.name??"",
                user?.name != null ? user?.name??"" : widget.user?.name??"",
                dateofbirth.text != null ? dateofbirth.text??"" : widget.user?.dob??"",
                user?.gender != null ? user?.gender??"" : widget.user?.gender??"",
                widget.user?.countryId != null
                    ? widget.user?.countryId??""
                    : user?.countryId??"",
                user?.countryName != null
                    ? user?.countryName??""
                    : widget.user?.countryName??"",
                user?.bio != null ? user?.bio??"" : widget.user?.bio??"",

                // preferenceIds != null
                //     ? preferenceIds
                //     : widget.user.preferenceCountries,
                // user.countryCode != null
                //     ? user.countryCode
                //     : widget.user.countryCode,
                // myTagIds != null ? myTagIds : widget.user.tags
              )
                  .then((value) {
                re = value;
              });
              if (re['error'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(re['msg']),
                  backgroundColor: Colors.red,
                ));
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(re['msg'])));
              }
              setState(() {});
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              "Update",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
      body: Container(
          color: Color(0xFFF8F8F8),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                height: height * .30,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          changeCoverPhoto(0);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            color: Colors.white,
                            child: uploadedCovers[0] == null
                                ? user?.coverPhotos != null
                                    ? CoverPhotoNetworkImage(
                                        url: user?.coverPhotos?[0].image,
                                      )
                                    : Center(
                                        child:
                                            Image.asset("images/icon-plus.png"),
                                      )
                                : CoverPhotoFileImage(
                                    file: uploadedCovers[0],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        changeCoverPhoto(1);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: uploadedCovers[1] == null
                                              ? user?.coverPhotos != null
                                                  ? CoverPhotoNetworkImage(
                                                      url: user?.coverPhotos?[1].image,
                                                    )
                                                  : Center(
                                                      child: Image.asset(
                                                          "images/icon-plus.png"),
                                                    )
                                              : CoverPhotoFileImage(
                                                  file: uploadedCovers[1],
                                                ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        changeCoverPhoto(2);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: uploadedCovers[2] == null
                                              ? user?.coverPhotos != null
                                                  ? CoverPhotoNetworkImage(
                                                      url: user?.coverPhotos?[2].image,
                                                    )
                                                  : Center(
                                                      child: Image.asset(
                                                          "images/icon-plus.png"),
                                                    )
                                              : CoverPhotoFileImage(
                                                  file: uploadedCovers[2],
                                                ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        changeCoverPhoto(3);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: uploadedCovers[3] == null
                                              ? user?.coverPhotos != null
                                                  ? CoverPhotoNetworkImage(
                                                      url: user?.coverPhotos?[3].image,
                                                    )
                                                  : Center(
                                                      child: Image.asset(
                                                          "images/icon-plus.png"),
                                                    )
                                              : CoverPhotoFileImage(
                                                  file: uploadedCovers[3],
                                                ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        changeCoverPhoto(4);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          child: uploadedCovers[4] == null
                                              ? user?.coverPhotos != null
                                                  ? CoverPhotoNetworkImage(
                                                      url: user?.coverPhotos?[4].image,
                                                    )
                                                  : Center(
                                                      child: Image.asset(
                                                          "images/icon-plus.png"),
                                                    )
                                              : CoverPhotoFileImage(
                                                  file: uploadedCovers[4],
                                                ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                child: Row(
                  children: [
                    //  _profilePic==null? Image.asset("images/icon-plus-hex.png"):HexagonProfilePicNetworkImage(),
                    GestureDetector(
                      onTap: () => changeProfilePic(widget.user??CurrentUserModel()),

                      //changeProfilePic(widget.user),
                      child: HexagonWidget.pointy(
                          width: width * 0.22,
                          color: Colors.grey,
                          height: width * 0.22,
                          child: _profilePic == null
                              ? user?.image != null
                                  ? HexagonProfilePicNetworkImage(
                                      url: user?.image,
                                    )
                                  : Image.asset("images/icon-plus.png")
                              : HexagonProfilePicFile(
                                  file: _profilePic,
                                )),
                    ),

                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add at least 3 photos to get more exposure",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11),
                            ),
                            Text(
                              "Post updated photos and become cover automatically",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13),
                            ),
                            Text(
                              "Click to change or delete photo, Drag photo to change order",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              TextFieldProfileWithPopUp(
                label: "Name",
                value: user?.name??"",
                maxLenght: 16,
                userField: "displayName",
                modalLabel: "Input your name:",
                updateField: "name",
                onChange: (val) {
                  user?.name = val;
                },
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Gender",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _myRadioButton(
                              title: "MALE",
                              value: 0,
                              onChanged: (newValue) {
                                setState(() {
                                  user?.gender = "Male";
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: _myRadioButton(
                                title: "FEMALE",
                                value: 1,
                                onChanged: (newValue) {
                                  setState(() {
                                    user?.gender = "Female";
                                  });
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Birthday",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Theme(
                        data: ThemeData(primarySwatch: Colors.red),
                        child: DateTimePicker(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "BIRTHDAY",
                            hintStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          onChanged: (val) {},
                          type: DateTimePickerType.date,
                          dateMask: 'd MMM, yyyy',
                          initialDate: DateTime(1990),
                          controller: dateofbirth,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2050),
                          icon: Icon(Icons.event),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CountrySelect(
                        onSelect: (CountryModel c) {
                          setState(() {
                            widget.user?.countryName = c.name;
                            widget.user?.countryId = c.id.toString();
                            widget.user?.countryCode = c.iso.toString();
                          });

                          Navigator.of(context).pop();
                        },
                      )
                  ));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Hometown",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child:  widget.user?.countryName != null
                                ? Row(
                                    children: [
                                      Text(
                                        widget.user?.countryName??"",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                : Text(
                                    "Set Country",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                      )
                    ],
                  ),
                ),
              ),
              // TextFieldProfileWithPopUp(
              //   label: "Lovello ID",
              //   value: user.lovelloId,
              //   maxLenght: 16,
              //   userField: "",
              //   modalLabel:
              //       "Users can search for you easily by your ID. Once set, your ID cannot be changed",
              //   updateField: "lovello_id",
              //   isLovello: true,
              //   isLovelloEditable: !user.lovelloIdEdited,
              // ),
              // TextFieldProfile(
              //   label: "Lovello ID",
              //   hint: "548866",
              // ),
              TextFieldProfileWithPopUp(
                label: "Bio",
                value: user?.bio??"",
                maxLenght: 80,
                userField: "",
                modalLabel: "Input bio:",
                updateField: "bio",
                onChange: (val) {
                  user?.bio = val;
                },
              ),
              SizedBox(
                height: height * .015,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Preference",
                  style: TextStyle(color: Colors.grey[700], fontSize: 12.5),
                ),
              ),
              Container(
                color: Colors.white,
                //  padding: const EdgeInsets.only(left: 10.0, ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(
                        "Countries & regions",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CountryPreference(
                                  preferenceIds: preferenceIds,
                                  preferenceCountries: preferenceNames,
                                  onSave: (List<int> ids, List<String> names) {
                                    setState(() {
                                      preferenceIds = ids;
                                      preferenceNames = names;
                                    });

                                    Navigator.of(context).pop();
                                  },
                                )));
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey[400],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: preferenceNames.length > 0
                          ? Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Wrap(
                                children: getCountryPreferenceWrapChildren(),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .015,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Personality tags",
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 13)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add personality tags to attract more friends",
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    )
                  ],
                ),
              ),
              TagWithoutLabel(
                allTags: allTags,
                onAdd: (currentTags) {
                  // // ser.updateNormalProfileFields("tags", currentTags, "");
                  setState(() {
                    myTags = currentTags;
                  });
                  Navigator.of(context).pop();
                },
                tags: myTags,
                // tags: [
                //   // "🥳PARRTY",
                //   // "💕LOVE",
                //   // "✋Chat with me",
                //   // "💃 Fashion",
                //   // "💋 Sexey",
                //   // "❤ relationship",
                //   // "Photography",
                //   // "pets"
                // ],
              ),
              SizedBox(
                height: height * .1,
              ),
            ],
          )),
    );
  }
}

class TextFieldProfile extends StatelessWidget {
  final String? label;
  final String? hint;
  final int ?maxLines;

  final TextEditingController? controller;

  TextFieldProfile({this.label, this.hint, this.maxLines = 1, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                label??"",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }
}

class TextFieldProfileWithPopUp extends StatefulWidget {
  final String? label;
  final String? value;
  final int? maxLenght;
  final String? modalLabel;
  final String ?updateField;
  final String? userField;
  final bool? isLovello;
  bool? isLovelloEditable;
  final Function? onChange;

  TextFieldProfileWithPopUp(
      {this.label,
      this.value,
      this.maxLenght,
      this.userField,
      this.modalLabel,
      this.updateField,
      this.onChange,
      this.isLovello = false,
      this.isLovelloEditable = false});

  @override
  _TextFieldProfileWithPopUpState createState() =>
      _TextFieldProfileWithPopUpState();
}

class _TextFieldProfileWithPopUpState extends State<TextFieldProfileWithPopUp> {
  String? value;
  String? finalValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text(
              widget.modalLabel??"",
              style: TextStyle(fontSize: 12),
            ),
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextFormField(
                    decoration: InputDecoration(
                        hintText: widget.isLovello! ? widget.value : "",
                        hintStyle: TextStyle()),
                    onChanged: (val) {
                      value = val;
                    },
                    style: TextStyle(fontSize: 12),
                    initialValue: widget.isLovello!
                        ? ""
                        : finalValue == null
                            ? widget.value
                            : finalValue,
                    autofocus: true,
                    maxLength: widget.maxLenght,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                  minWidth: 40,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 12, color: Color(0xFFCC2206)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new MaterialButton(
                minWidth: 40,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 12, color: Color(0xFFCC2206)),
                ),
                onPressed: () async {
                  // ProfileUpdateServices ser = ProfileUpdateServices();
                  // bool submit = true;
                  // if (widget.isLovello) {
                  //   var taken = await ser.checkAvailableLovelloId(value);
                  //   submit = !taken;
                  // }
                  //
                  // if (submit) {

                  setState(() {
                    finalValue = value;
                  });
                  if (widget.onChange != null) {
                    widget.onChange!(value);
                  }
                  Navigator.pop(context);
                  // } else {
                  //   Fluttertoast.showToast(
                  //       msg: "This Lovello ID is already taken",
                  //       toastLength: Toast.LENGTH_LONG,
                  //       gravity: ToastGravity.CENTER,
                  //       backgroundColor: Colors.red,
                  //       textColor: Colors.white);
                  // }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          border: widget.updateField != 'bio'
              ? Border(bottom: BorderSide(color: Colors.grey))
              : Border()),
      child: GestureDetector(
        onTap: () {
          if (!widget.isLovello! || widget.isLovelloEditable!) _showDialog();
        },
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.label??"",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Text(
                  finalValue == null ? widget.value ?? ' ' : finalValue??"",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ))
          ],
        ),
      ),
    );
  }
}
