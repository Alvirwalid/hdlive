import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/models/signup_data_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/raised_gradient_button.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:hdlive_latest/screens/withAuth/setting/Brodcast.dart';
import 'package:hdlive_latest/screens/withAuth/setting/privacypolicy.dart';
import 'package:hdlive_latest/screens/withAuth/setting/user_agreement.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsCondition extends StatefulWidget {
  final SignupDataModel? data;
  TermsCondition({this.data});

  @override
  _TermsConditionState createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  bool agreed = false;

  bool loading = false;

  File? _image;

  @override
  void initState() {
    super.initState();
  }

  changeProfilePic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path??"");
      setState(() {
        _image = file;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Loading()
            : Container(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: height * 0.35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xFFCC2206),
                                Color(0xFFA92104)
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // LoginController(context).verifySignup(widget.data);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 10.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                              Center(
                                child: CircleLogoWithRadius(h: 0.065),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              FrontTextInTerms(),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(top: 75),
                          child: Column(
                            children: [
                              Text(
                                widget.data?.name??"",
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.black),
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                              Center(
                                  child: Text(
                                "In order to use HD Live, you need to read and agree to the following terms",
                                style: TextStyle(
                                    fontSize: width * .0275,
                                    color: Colors.grey[600]),
                              )),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              TermsWindows(),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: Colors.red,
                                      value: agreed,
                                      onChanged: (v) {
                                        print(v);
                                        setState(() {
                                          agreed = v!;
                                        });
                                      },
                                    ),
                                    Text(
                                      "I have read and agree to the above agreement",
                                      style: TextStyle(
                                          fontSize: width * .0275,
                                          color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: RaisedGradientButton(
                                    child: Text(
                                      'NEXT',
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
                                      if (agreed) {
                                        widget.data!.image = _image;
                                        Navigator.of(context).pushNamed(
                                            "/set_gender_country",
                                            arguments: widget.data);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please agree to our terms/conditions",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height * .05,
                          child: Text(
                            "HD Live targets not for children, instead, you need to be over the minimum age as specified in User Agreemen",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: width * .0275,
                                color: Colors.grey[600]),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: height * 0.35 - 50,
                      left: width / 2 - width * 0.125,
                      // child: CustomHexagon(),
                      child: GestureDetector(
                          onTap: changeProfilePic,
                          child: _image != null
                              ? CircleAvatar(
                                  radius: width * 0.125,
                                  backgroundImage: FileImage(_image!),
                                )
                              : Initicon(
                                  text: widget.data!.name??"",
                                  size: width * 0.25,
                                )),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class TermsWindows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => UserAgreementScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 10.sp,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Terms Of Use",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.red,
                size: 12.sp,
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BrodcastScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 10.sp,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Broadcaster Agreement",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.red,
                  size: 12.sp,
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PrivcyPolicyScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 10.sp,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.red,
                  size: 12.sp,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FrontTextInTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to HD Live",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.white),
          ),
          Text(
            "Improve the profile to win more attention",
            style: TextStyle(color: Colors.grey[200], fontSize: 15.sp),
          )
        ],
      ),
    );
  }
}
